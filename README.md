# international_phone_field🌎
Validating numbers and providing necessary detail base on selected country😃. The pacakge comes with a enough detail about the country which is super useful and save you from api issues🐻

## Simple project screenshot
![Screenshot_20201118-173153](https://user-images.githubusercontent.com/36260221/99586029-0e579a00-29df-11eb-88fa-4a0066ad0cde.png)

![Screenshot_20201118-203641](https://user-images.githubusercontent.com/36260221/99586194-48c13700-29df-11eb-919d-6dd9b7faa016.png)

![Screenshot_20201118-203716](https://user-images.githubusercontent.com/36260221/99587738-6abbb900-29e1-11eb-8ad5-50b9235f585b.png)

## Usage
```dart
import 'package:international_phone_field/international_phone_field.dart';

String phoneNumber;
String phoneIsoCode;

void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
       phoneNumber = number;
       phoneIsoCode = isoCode;
    });
}

@override
 Widget build(BuildContext context) => Scaffold(
     body: Center(
       child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: InternationalPhoneInput(
                onPhoneNumberChange: onPhoneNumberChange,
                initialPhoneNumber: phoneNumber,
                initialSelection: phoneIsoCode,
                enabledCountries: ['+233', '+234'],
                labelText: "Enter your phone Number",
                addCountryComponentInsideField: true,
                border: OutlineInputBorder(
                  gapPadding: 20.0,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
      ),
     ),
 );

```