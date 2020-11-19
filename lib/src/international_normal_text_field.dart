import 'package:flutter/material.dart';
import 'package:international_phone_field/src/country.dart';
import 'package:international_phone_field/src/validation.dart';

class NormalInterField extends StatefulWidget {
  /// Returning selected country details
  ///
  ///  [onValidPhoneNumber] returns all infromation hold by the selected country after validation
  /// {@tool snippet}
  /// ```dart
  /// String phoneNumber;
  /// void onValidPhoneNumber(
  ///  String number,
  /// String internationalizedPhoneNumber,
  /// String isoCode,
  /// String code,
  /// String capital,
  /// String continent,
  /// String currency,
  /// String name) {
  /// print(number);
  /// print(currency);
  /// setState(() {
  /// phoneNumber = number;
  /// });
  /// }
  /// `
  final Function(
      String number,
      String internationalizedPhoneNumber,
      String isoCode,
      String dialCode,
      String capital,
      String continent,
      String currency,
      String name) onValidPhoneNumber;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed on top of the [InputDecorator.child] (i.e., at the same location
  /// on the screen where text may be entered in the [InputDecorator.child])
  /// when the input [isEmpty] and either (a) [labelText] is null or (b) the
  /// input has the focus.
  final String hintText;

  /// The style to use for the [hintText].
  ///
  /// Also used for the [labelText] when the [labelText] is displayed on
  /// top of the input field (i.e., at the same location on the screen where
  /// text may be entered in the [InputDecorator.child]).
  ///
  /// If null, defaults to a value derived from the base [TextStyle] for the
  /// input field and the current [Theme].
  final TextStyle hintStyle;

  /// The maximum number of lines the [errorText] can occupy.
  ///
  /// Defaults to null, which means that the [errorText] will be limited
  /// to a single line with [TextOverflow.ellipsis].
  ///
  /// This value is passed along to the [Text.maxLines] attribute
  /// of the [Text] widget used to display the error.
  ///
  /// See also:
  ///
  ///  * [helperMaxLines], the equivalent but for the [helperText].
  final int errorMaxLines;

  /// Text that describes the input field.
  ///
  /// When the input field is empty and unfocused, the label is displayed on
  /// top of the input field (i.e., at the same location on the screen where
  /// text may be entered in the input field). When the input field receives
  /// focus (or if the field is non-empty), the label moves above (i.e.,
  /// vertically adjacent to) the input field.
  final String labelText;

  /// Display plus sign
  ///
  /// [displayPlusSign] when set true display the plus sign for users to see
  /// it is true by default
  final bool displayPlusSign;
  const NormalInterField(
      {Key key,
      this.hintText,
      this.hintStyle,
      this.errorMaxLines,
      this.onValidPhoneNumber,
      this.displayPlusSign = true,
      this.labelText})
      : super(key: key);

  @override
  _NormalInterFieldState createState() => _NormalInterFieldState();
}

class _NormalInterFieldState extends State<NormalInterField> {
  TextEditingController controller = TextEditingController();
  List<Country> countries;
  bool isValid = false;
  String controlNumber = '';
  bool performValidation = true;

  @override
  void initState() {
    super.initState();
    PhoneService.fetchCountryData(
            context, 'packages/international_phone_field/assets/countries.json')
        .then((list) {
      setState(() {
        countries = list;
      });
    });
  }

  void onChanged() {
    // if user keeps inputting number, block the value to the last valid
    // number input
    if (isValid && controller.text.length > controlNumber.length) {
      setState(() {
        controller.text = controlNumber;
      });
    }

    // block execution of validation of user keeps inputting numbers
    if (controller.text == controlNumber) {
      setState(() {
        performValidation = false;
      });
    } else {
      setState(() {
        performValidation = true;
      });
    }

    if (performValidation) {
      _validatePhoneNumber(controller.text, countries).then((fullNumber) {
        if (fullNumber != null) {
          setState(() {
            controlNumber = fullNumber.substring(1);
          });
        }
      });
    }
    // place cursor at end of text string
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    return;
  }

  Future<String> _validatePhoneNumber(
      String number, List<Country> countries) async {
    String fullNumber;
    if (number != null && number.isNotEmpty) {
      //This step to avoid calling async function on the whole list of countries
      List<Country> potentialCountries =
          PhoneService.getPotentialCountries(number, countries);
      if (potentialCountries != null) {
        for (var country in potentialCountries) {
          //isolate local number before parsing. Using length-1 to cut the '+'
          String localNumber = number.substring(country.dialCode.length - 1);
          isValid =
              await PhoneService.parsePhoneNumber(localNumber, country.code);
          if (isValid) {
            fullNumber = await PhoneService.getNormalizedPhoneNumber(
                localNumber, country.code);
            widget.onValidPhoneNumber(
                localNumber,
                fullNumber,
                country.code,
                country.dialCode,
                country.capital,
                country.continent,
                country.currency,
                country.name);
          }
        }
      }
    }
    return fullNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (widget.displayPlusSign) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text('+ '),
            ),
          ),
        ],
        Expanded(
          child: TextField(
            keyboardType: TextInputType.phone,
            controller: controller,
            onChanged: (content) {
              onChanged();
            },
            decoration: InputDecoration(
                hintText: widget.hintText ?? null,
                hintStyle: widget.hintStyle ?? null,
                errorMaxLines: widget.errorMaxLines ?? 3,
                labelText: widget.labelText ?? 'Enter your phone number'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
