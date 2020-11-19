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

enum countryselect { nigeria, ghana }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Intializing variables to be use
  String phoneNumber;
  String phoneIsoCode;
  String selectedCountryCapital;
  String selectedCountryContinent;
  String selectedCountryCurrency;
  String selectedCountryName;
  bool visible = false;
  String confirmedNumber = '';

  void onPhoneNumberChange(
      String number,
      String internationalizedPhoneNumber,
      String isoCode,
      String dialCode,
      String countryCapital,
      String countryContinent,
      String countryCurrency,
      String countryName) {
    print(number);

    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
      selectedCountryCapital = countryCapital;
      selectedCountryContinent = countryContinent;
      selectedCountryCurrency = countryCurrency;
      selectedCountryName = countryName;
    });
  }

  onValidPhoneNumber(
      String number,
      String internationalizedPhoneNumber,
      String isoCode,
      String dialCode,
      String countryCapital,
      String countryContinent,
      String countryCurrency,
      String countryName) {
    setState(() {
      visible = true;
      confirmedNumber = internationalizedPhoneNumber;
    });
  }
  //   var hintElement = countryselect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example Project'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: InterField(
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: InterField(
                onPhoneNumberChange: onPhoneNumberChange,
                initialPhoneNumber: phoneNumber,
                initialSelection: phoneIsoCode,
                enabledCountries: ['+233', '+234'],
                showCountryCodes: false,
                labelText: "Hide country code",
                addCountryComponentInsideField: false,
              ),
            ),
            SizedBox(height: 20),
            NormalInterField(
              displayPlusSign: false,
              onValidPhoneNumber: onValidPhoneNumber,
            ),
            Visibility(
              child: Text(confirmedNumber),
              visible: visible,
            ),
            Spacer(flex: 2),
            selectedCountryName != null
                ? tableDesign()
                : Text(
                    "Start typing and see the magic happen",
                    style: TextStyle(fontSize: 17),
                  )
          ],
        ),
      ),
    );
  }

  DataTable tableDesign() {
    return DataTable(
      columnSpacing: 40,
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Name',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Currency',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Continent',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Capital',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('$selectedCountryName')),
            DataCell(Text('$selectedCountryCurrency')),
            DataCell(Text('$selectedCountryContinent')),
            DataCell(Text('$selectedCountryCapital')),
          ],
        ),
      ],
    );
  }
}
