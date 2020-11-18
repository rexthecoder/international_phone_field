import 'package:flutter/material.dart';
import 'package:international_phone_field/international_phone_field.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String phoneNumber;
  String phoneIsoCode;
  bool visible = false;
  String confirmedNumber = '';

  void onPhoneNumberChange(
      String number,
      String internationalizedPhoneNumber,
      String isoCode,
      String code,
      String capital,
      String continent,
      String currency,
      String name) {
    print(number);
    print(currency);
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  onValidPhoneNumber(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      visible = true;
      confirmedNumber = internationalizedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('International Phone Input Example'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Spacer(flex: 1),
            InternationalPhoneInput(
              onPhoneNumberChange: onPhoneNumberChange,
              initialPhoneNumber: phoneNumber,
              initialSelection: phoneIsoCode,
              enabledCountries: ['+233', '+234'],
              labelText: "Phone Number",
              addCountryComponentInsideField: false,
              // border: OutlineInputBorder(
              //   gapPadding: 20.0,
              //   borderRadius: BorderRadius.circular(10),
              // ),
            ),
            SizedBox(height: 20),
            InternationalPhoneInput(
              decoration: InputDecoration.collapsed(hintText: '(123) 123-1234'),
              onPhoneNumberChange: onPhoneNumberChange,
              initialPhoneNumber: phoneNumber,
              initialSelection: phoneIsoCode,
              enabledCountries: ['+233', '+1'],
              showCountryCodes: false,
              showCountryFlags: true,
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.black,
            ),
            SizedBox(height: 50),
            InternationalPhoneInputText(
              onValidPhoneNumber: onValidPhoneNumber,
            ),
            Visibility(
              child: Text(confirmedNumber),
              visible: visible,
            ),
            Spacer(flex: 2),
            // Container(
            //     height: 50,
            //     child: TextFormField(
            //       maxLength: 12,
            //       buildCounter: (BuildContext context,
            //               {int currentLength, int maxLength, bool isFocused}) =>
            //           null,
            //       decoration: InputDecoration(
            //         border: OutlineInputBorder(
            //           gapPadding: 20.0,
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         prefixIcon: Padding(
            //             padding: const EdgeInsets.only(left: 10.0),
            //             child: Text("H")),
            //         focusColor: Color(0xff5662FE),
            //         labelText: "Phone Number",
            //         labelStyle: TextStyle(color: Colors.black26),
            //       ),
            //       validator: (value) {
            //         if (value.isEmpty) {
            //           return "Enter your phone number";
            //         } else {
            //           return null;
            //         }
            //       },
            //       onChanged: (value) {},
            //       keyboardType: TextInputType.number,
            //       style: TextStyle(fontFamily: "Poppins"),
            //     )),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
