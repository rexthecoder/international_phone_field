import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../international_phone_field.dart';
import 'country.dart';

class InternationalPhoneInput extends StatefulWidget {
  /// Returning selected country details
  ///
  ///  [onPhoneNumberChange] returns all infromation hold by the selected country
  /// {@tool snippet}
  /// ```dart
  /// String phoneNumber;
  /// void onPhoneNumberChange(
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
  /// phoneIsoCode = isoCode;
  /// });
  /// }
  /// ```
  final void Function(
      String phoneNumber,
      String internationalizedPhoneNumber,
      String isoCode,
      String dialCode,
      String capital,
      String continent,
      String currency,
      String name) onPhoneNumberChange;

  /// User typed phone number
  ///
  /// [initialPhoneNumber] this set the phone number typed by the user
  final String initialPhoneNumber;

  /// Setting the default iso
  ///
  /// [initialSelection] works in controllering the iso
  final String initialSelection;

  /// Text that appears below the [InputDecorator.child] and the border.
  ///
  /// If non-null, the border's color animates to red and the [helperText] is
  /// not shown.
  ///
  /// In a [TextFormField], this is overridden by the value returned from
  /// [TextFormField.validator], if that is not null.
  final String errorText;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed on top of the [InputDecorator.child] (i.e., at the same location
  /// on the screen where text may be entered in the [InputDecorator.child])
  /// when the input [isEmpty] and either (a) [labelText] is null or (b) the
  /// input has the focus.
  final String hintText;

  /// An action the user has requested the text input control to perform.
  ///
  /// Each action represents a logical meaning, and also configures the soft
  /// keyboard to display a certain kind of action button. The visual appearance
  /// of the action button might differ between versions of the same OS.
  ///
  /// Despite the logical meaning of each action, choosing a particular
  /// [TextInputAction] does not necessarily cause any specific behavior to
  /// happen. It is up to the developer to ensure that the behavior that occurs
  /// when an action button is pressed is appropriate for the action button chosen.
  ///
  /// For example: If the user presses the keyboard action button on iOS when it
  /// reads "Emergency Call", the result should not be a focus change to the next
  /// TextField. This behavior is not logically appropriate for a button that says
  /// "Emergency Call".
  ///
  /// See [EditableText] for more information about customizing action button
  /// behavior.
  ///
  /// Most [TextInputAction]s are supported equally by both Android and iOS.
  /// However, there is not a complete, direct mapping between Android's IME input
  /// types and iOS's keyboard return types. Therefore, some [TextInputAction]s
  /// are inappropriate for one of the platforms. If a developer chooses an
  /// inappropriate [TextInputAction] when running in debug mode, an error will be
  /// thrown. If the same thing is done in release mode, then instead of sending
  /// the inappropriate value, Android will use "unspecified" on the platform
  /// side and iOS will use "default" on the platform side.
  final TextInputAction textInputAction;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to the brightness of [ThemeData.primaryColorBrightness].
  final Brightness keyboardAppearance;

  /// If false the text field is "disabled": it ignores taps and its
  /// [decoration] is rendered in grey.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [Decoration.enabled] property.
  final bool enabled;

  /// A [TextInputFormatter] can be optionally injected into an [EditableText]
  /// to provide as-you-type validation and formatting of the text being edited.
  ///
  /// Text modification should only be applied when text is being committed by the
  /// IME and not on text under composition (i.e., only when
  /// [TextEditingValue.composing] is collapsed).
  ///
  /// See also the [FilteringTextInputFormatter], a subclass that
  /// removes characters that the user tries to enter if they do, or do
  /// not, match a given pattern (as applicable).
  ///
  /// To create custom formatters, extend the [TextInputFormatter] class and
  /// implement the [formatEditUpdate] method.
  final List<TextInputFormatter> inputFormatters;

  /// Text that describes the input field.
  ///
  /// When the input field is empty and unfocused, the label is displayed on
  /// top of the input field (i.e., at the same location on the screen where
  /// text may be entered in the input field). When the input field receives
  /// focus (or if the field is non-empty), the label moves above (i.e.,
  /// vertically adjacent to) the input field.
  final String labelText;

  /// Apperence of the drop dowm icon
  ///
  /// [dropDownArrowColor] is use to set the color of the drop down Icon
  final Color dropDownArrowColor;

  /// Apperence of Error display
  ///
  /// [errorStyle] is use for setting the style of error display when numbers are not valid
  final TextStyle errorStyle;

  /// The style to use for the [hintText].
  ///
  /// Also used for the [labelText] when the [labelText] is displayed on
  /// top of the input field (i.e., at the same location on the screen where
  /// text may be entered in the [InputDecorator.child]).
  ///
  /// If null, defaults to a value derived from the base [TextStyle] for the
  /// input field and the current [Theme].
  final TextStyle hintStyle;

  /// The style to use for the [labelText] when the label is above (i.e.,
  /// vertically adjacent to) the input field.
  ///
  /// When the [labelText] is on top of the input field, the text uses the
  /// [hintStyle] instead.
  ///
  /// If null, defaults to a value derived from the base [TextStyle] for the
  /// input field and the current [Theme].
  final TextStyle labelStyle;

  /// Error Apperance
  ///
  /// [erroMaxLines] set the max line for the [errorText]
  final int errorMaxLines;

  /// Setting the number of country list to be display
  ///
  /// [enabledCountries] use to set the kind of countries you want to display
  final List<String> enabledCountries;

  /// Apperence of [Input]
  ///
  /// [decoration] is use to set the apperance of the define [TextField]
  final InputDecoration decoration;

  /// Show country code
  ///
  /// [showCountryCodes] when enable display the iso code for the selected country
  final bool showCountryCodes;

  /// Show country flag
  ///
  /// [showCountryFlags] when set to true display the flag of the selected country
  final bool showCountryFlags;

  /// set  dropdown icon
  ///
  /// [dropdownIcon] use to set icon for the drop down button
  final Widget dropdownIcon;

  /// Defines the appearance of an [InputDecorator]'s border.
  ///
  /// An input decorator's border is specified by [InputDecoration.border].
  ///
  /// The border is drawn relative to the input decorator's "container" which
  /// is the optionally filled area above the decorator's helper, error,
  /// and counter.
  ///
  /// Input border's are decorated with a line whose weight and color are defined
  /// by [borderSide]. The input decorator's renderer animates the input border's
  /// appearance in response to state changes, like gaining or losing the focus,
  /// by creating new copies of its input border with [copyWith].
  ///
  /// See also:
  ///
  ///  * [UnderlineInputBorder], the default [InputDecorator] border which
  ///    draws a horizontal line at the bottom of the input decorator's container.
  ///  * [OutlineInputBorder], an [InputDecorator] border which draws a
  ///    rounded rectangle around the input decorator's container.
  ///  * [InputDecoration], which is used to configure an [InputDecorator]
  final InputBorder border;

  /// Position country components
  ///
  /// [addCountryComponentInsideField] set wheather the country flag & code should be set as prefix
  final bool addCountryComponentInsideField;
  InternationalPhoneInput(
      {this.onPhoneNumberChange,
      this.initialPhoneNumber,
      this.dropDownArrowColor,
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
      this.addCountryComponentInsideField = true,
      this.dropdownIcon,
      this.border,
      this.keyboardAppearance,
      this.enabled,
      this.inputFormatters,
      this.textInputAction});

  static Future<String> internationalizeNumber(String number, String iso) {
    return PhoneService.getNormalizedPhoneNumber(number, iso);
  }

  @override
  _InternationalPhoneInputState createState() =>
      _InternationalPhoneInputState();
}

class _InternationalPhoneInputState extends State<InternationalPhoneInput> {
  // Define blueprint and variable to be use in the code
  Country countries;
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

  _InternationalPhoneInputState();

  final phoneTextController = TextEditingController();

// Initializing some user define widget
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
                (e.code.toUpperCase() ==
                    widget.initialSelection.toUpperCase()) ||
                (e.dialCode == widget.initialSelection.toString()),
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

  ///Validating the number
  ///
  ///This function validate the user type number. 
  _validatePhoneNumber() {
    String phoneText = phoneTextController.text;
    if (phoneText != null && phoneText.isNotEmpty) {
      PhoneService.parsePhoneNumber(phoneText, selectedItem.code)
          .then((isValid) {
        setState(() {
          hasError = !isValid;
        });

        if (widget.onPhoneNumberChange != null) {
          if (isValid) {
            PhoneService.getNormalizedPhoneNumber(phoneText, selectedItem.code)
                .then((number) {
              widget.onPhoneNumberChange(
                  phoneText,
                  number,
                  selectedItem.code,
                  selectedItem.dialCode,
                  selectedItem.capital,
                  selectedItem.continent,
                  selectedItem.currency,
                  selectedItem.name);
            });
          } else {
            widget.onPhoneNumberChange(
                '',
                '',
                selectedItem.code,
                selectedItem.dialCode,
                selectedItem.capital,
                selectedItem.continent,
                selectedItem.currency,
                selectedItem.name);
          }
        }
      });
    }
  }
 /// Fatching country Data
 /// 
 /// This is use to get all the selected item
  Future<List<Country>> _fetchCountryData() async {
    var list = await DefaultAssetBundle.of(context)
        .loadString('packages/international_phone_field/assets/countries.json');
    List<dynamic> jsonList = json.decode(list);

    List<Country> countries = List<Country>.generate(jsonList.length, (index) {
      Map<String, String> elem = Map<String, String>.from(jsonList[index]);
      if (widget.enabledCountries.isEmpty) {
        return Country(
            name: elem['Name'],
            code: elem['Iso2'],
            dialCode: elem['Dial'],
            flagUri: elem['Unicode'],
            currency: elem['Currency'],
            capital: elem['Capital'],
            continent: elem['Continent']);
      } else if (widget.enabledCountries.contains(elem['Iso2']) ||
          widget.enabledCountries.contains(elem['Dial'])) {
        return Country(
            name: elem['Name'],
            code: elem['Iso2'],
            dialCode: elem['Dial'],
            flagUri: elem['Unicode'],
            currency: elem['Currency'],
            capital: elem['Capital'],
            continent: elem['Continent']);
      } else {
        return null;
      }
    });

    countries.removeWhere((value) => value == null);

    return countries;
  }
  /// Dialog Design
  /// 
  /// [_changeCountry] use for changing the display country and also for displaying [Dialog] box
   Future<void> _changeCountry() async {
    var filteredCountries = itemList;
    await showDialog(
      context: context,
      useRootNavigator: false,
      child: StatefulBuilder(
        builder: (ctx, setState) => Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    labelText: "Type something",
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredCountries = itemList
                          .where((country) => country.name
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                    //           _validatePhoneNumber();
                  },
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredCountries.length,
                    itemBuilder: (ctx, index) => Column(
                      children: <Widget>[
                        ListTile(
                          leading: Text(
                            filteredCountries[index].flagUri,
                            style: TextStyle(fontSize: 30),
                          ),
                          title: Text(
                            filteredCountries[index].name,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          trailing: Text(
                            filteredCountries[index].dialCode,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          onTap: () {
                            selectedItem = filteredCountries[index];
                            _validatePhoneNumber();
                            Navigator.of(context).pop();
                          },
                        ),
                        Divider(thickness: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        widget.addCountryComponentInsideField
            ? SizedBox.shrink()
            : dropDownButton(),
        Flexible(
            child: TextField(
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          keyboardAppearance: widget.keyboardAppearance,
          textInputAction: widget.textInputAction,
          keyboardType: TextInputType.phone,
          controller: phoneTextController,
          decoration: decoration ??
              InputDecoration(
                prefixIcon: widget.addCountryComponentInsideField
                    ? Padding(
                        padding: widget.border != null
                            ? EdgeInsets.only(left: 10)
                            : EdgeInsets.zero,
                        child: dropDownButton())
                    : null,
                contentPadding: EdgeInsets.zero,
                hintText: hintText,
                labelText: labelText,
                errorText: hasError ? errorText : null,
                hintStyle: hintStyle ?? null,
                errorStyle: errorStyle ?? null,
                labelStyle: labelStyle,
                errorMaxLines: errorMaxLines ?? 3,
                border: widget.border ?? null,
              ),
        ))
      ],
    );
  }

  /// DropDown like Icon
  /// 
  /// [dropDownButton] use for setting the item needed to display for users to set
  Container dropDownButton() {
    return Container(
      width: 100,
      alignment: Alignment.center,
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (widget.showCountryFlags) ...[
              Text(
                selectedItem?.flagUri ?? '',
                style: TextStyle(fontSize: 24),
              ),
            ],
            if (showCountryCodes) ...[
              SizedBox(width: 4),
              Text(
                selectedItem?.dialCode ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            Icon(
              Icons.arrow_drop_down,
              color: widget.dropDownArrowColor ?? Colors.black,
            ),
          ],
        ),
        onTap: _changeCountry,
      ),
    );
  }
}
