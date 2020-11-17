//library international_phone_input;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'country.dart';
import 'phone_service.dart';

class InternationalPhoneInput extends StatefulWidget {
  final void Function(String phoneNumber, String internationalizedPhoneNumber,
      String isoCode, String dialCode) onPhoneNumberChange;
  final String initialPhoneNumber;
  final String initialSelection;
  final String errorText;
  final String hintText;
  final String labelText;
  final TextStyle errorStyle;
  final TextStyle hintStyle;
  final TextStyle labelStyle;
  final int errorMaxLines;
  final List<String> enabledCountries;
  final InputDecoration decoration;
  final bool showCountryCodes;
  final bool showCountryFlags;
  final Widget dropdownIcon;
  final InputBorder border;

  InternationalPhoneInput(
      {this.onPhoneNumberChange,
      this.initialPhoneNumber,
      this.initialSelection,
      this.errorText,
      this.hintText,
      this.labelText,
      this.errorStyle,
      this.hintStyle,
      this.labelStyle,
      this.enabledCountries = const [],
      this.errorMaxLines,
      this.decoration,
      this.showCountryCodes = true,
      this.showCountryFlags = true,
      this.dropdownIcon,
      this.border});

  static Future<String> internationalizeNumber(String number, String iso) {
    return PhoneService.getNormalizedPhoneNumber(number, iso);
  }

  @override
  _InternationalPhoneInputState createState() =>
      _InternationalPhoneInputState();
}

class _InternationalPhoneInputState extends State<InternationalPhoneInput> {
  Country selectedItem;
  List<Country> itemList = [];

  String errorText;
  String hintText;
  String labelText;

  TextStyle errorStyle;
  TextStyle hintStyle;
  TextStyle labelStyle;

  int errorMaxLines;

  bool hasError = false;
  bool showCountryCodes;
  bool showCountryFlags;

  InputDecoration decoration;
  Widget dropdownIcon;
  InputBorder border;

  _InternationalPhoneInputState();

  final phoneTextController = TextEditingController();

  @override
  void initState() {
    errorText = widget.errorText ?? 'Please enter a valid phone number';
    hintText = widget.hintText ?? 'eg. 244056345';
    labelText = widget.labelText;
    errorStyle = widget.errorStyle;
    hintStyle = widget.hintStyle;
    labelStyle = widget.labelStyle;
    errorMaxLines = widget.errorMaxLines;
    decoration = widget.decoration;
    showCountryCodes = widget.showCountryCodes;
    showCountryFlags = widget.showCountryFlags;
    dropdownIcon = widget.dropdownIcon;

    phoneTextController.addListener(_validatePhoneNumber);
    phoneTextController.text = widget.initialPhoneNumber;

    _fetchCountryData().then((list) {
      Country preSelectedItem;

      if (widget.initialSelection != null) {
        preSelectedItem = list.firstWhere(
            (e) =>
                (e.iso2.toUpperCase() ==
                    widget.initialSelection.toUpperCase()) ||
                (e.dial == widget.initialSelection.toString()),
            orElse: () => list[0]);
      } else {
        preSelectedItem = list[0];
      }

      setState(() {
        itemList = list;
        selectedItem = preSelectedItem;
      });
    });

    super.initState();
  }

  _validatePhoneNumber() {
    String phoneText = phoneTextController.text;
    if (phoneText != null && phoneText.isNotEmpty) {
      PhoneService.parsePhoneNumber(phoneText, selectedItem.iso2)
          .then((isValid) {
        setState(() {
          hasError = !isValid;
        });

        if (widget.onPhoneNumberChange != null) {
          if (isValid) {
            PhoneService.getNormalizedPhoneNumber(phoneText, selectedItem.iso2)
                .then((number) {
              widget.onPhoneNumberChange(
                  phoneText, number, selectedItem.iso2, selectedItem.dial);
            });
          } else {
            widget.onPhoneNumberChange(
                '', '', selectedItem.iso2, selectedItem.dial);
          }
        }
      });
    }
  }

  Future<List<Country>> _fetchCountryData() async {
    var list = await DefaultAssetBundle.of(context)
        .loadString('packages/international_phone_field/assets/countries.json');
    List<dynamic> jsonList = json.decode(list);
 
    List<Country> countries = List<Country>.generate(jsonList.length, (index) {
      Map<String, String> elem = Map<String, String>.from(jsonList[index]);
          print("$elem");
      if (widget.enabledCountries.isEmpty) {
    
        return Country(
            name: elem['name'],
            iso2: elem['iso2'],
            dial: elem['dial'],
            uniCode: elem['unicode'],
            capital: elem['capital'],
            continent: elem['continent'],
            currency: elem['currency'],
            iso3: elem['iso3']);
      } else if (widget.enabledCountries.contains(elem['iso2']) ||
          widget.enabledCountries.contains(elem['dial'])) {
        return Country(
            name: elem['name'],
            iso2: elem['iso2'],
            dial: elem['dial'],
            uniCode: elem['unicode'],
            capital: elem['capital'],
            continent: elem['continent'],
            currency: elem['currency'],
            iso3: elem['iso3']);
      } else {
        return null;
      }
    });

    countries.removeWhere((value) => value == null);

    return countries;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DropdownButtonHideUnderline(
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: DropdownButton<Country>(
                value: selectedItem,
                icon: Padding(
                  padding:
                      EdgeInsets.only(bottom: (decoration != null) ? 6 : 0),
                  child: dropdownIcon ?? Icon(Icons.arrow_drop_down),
                ),
                onChanged: (Country newValue) {
                  setState(() {
                    selectedItem = newValue;
                  });
                  _validatePhoneNumber();
                },
                items: itemList.map<DropdownMenuItem<Country>>((Country value) {
                  return DropdownMenuItem<Country>(
                    value: value,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          if (showCountryFlags) ...[
                           
                            Text("${value.uniCode}")
                          ],
                          if (showCountryCodes) ...[
                            SizedBox(width: 4),
                            Text(value.dial)
                          ]
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Flexible(
              child: TextField(
            keyboardType: TextInputType.phone,
            controller: phoneTextController,
            decoration: decoration ??
                InputDecoration(
                  hintText: hintText,
                  labelText: labelText,
                  errorText: hasError ? errorText : null,
                  hintStyle: hintStyle ?? null,
                  errorStyle: errorStyle ?? null,
                  labelStyle: labelStyle,
                  errorMaxLines: errorMaxLines ?? 3,
                  border: border ?? null,
                ),
          ))
        ],
      ),
    );
  }
}
