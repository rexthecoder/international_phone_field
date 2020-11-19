import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:flutter/services.dart';

import '../international_phone_field.dart';

class PhoneService {
  /// reading potential countries
  ///
  /// [getPotentialCountries] for reading potential countries from enable countries
  static List<Country> getPotentialCountries(
      String number, List<Country> countries) {
    List<Country> result = [];
    if (number.length > 0 && number.length < 5) {
      List<String> potentialCodes =
          generatePotentialDialCodes(number, 0, number.length);
      for (var code in potentialCodes) {
        for (var country in countries) {
          if (code == country.dialCode) {
            result.add(country);
          }
        }
      }
    }
    if (number.length >= 5) {
      String intlCode = number.substring(0, 4);
      List<String> potentialCodes = generatePotentialDialCodes(intlCode, 0, 4);
      for (var code in potentialCodes) {
        for (var country in countries) {
          if (code == country.dialCode) {
            result.add(country);
          }
        }
      }
    }
    return result;
  }

  /// Generating Potentional Dial codes
  ///
  /// This function is use to generate Potentional Dial codde from the number input
  static List<String> generatePotentialDialCodes(
      String number, int index, int length) {
    List<String> digits = number.split('');
    List<String> potentialCodes = [];
    String aggregate = '+${digits[index]}';
    potentialCodes.add(aggregate);
    while (index < length - 1) {
      index += 1;
      aggregate = aggregate + digits[index];
      potentialCodes.add(aggregate);
    }
    return potentialCodes;
  }

  static Future<bool> parsePhoneNumber(String number, String iso) async {
    try {
      bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
          phoneNumber: number, isoCode: iso);
      return isValid;
    } on PlatformException {
      return false;
    }
  }

  static Future<String> getNormalizedPhoneNumber(
      String number, String iso) async {
    try {
      String normalizedNumber = await PhoneNumberUtil.normalizePhoneNumber(
          phoneNumber: number, isoCode: iso);

      return normalizedNumber;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Fetch Country data
  ///
  /// This is use to fetch all the country data from the json file and assign it to the object country

  static Future<List<Country>> fetchCountryData(
      BuildContext context, String jsonFile) async {
    var list = await DefaultAssetBundle.of(context).loadString(jsonFile);
    List<Country> elements = [];
    var jsonList = json.decode(list);
    jsonList.forEach((s) {
      Map elem = Map.from(s);
      elements.add(Country(
          name: elem['Name'],
          code: elem['Iso2'],
          dialCode: elem['Dial'],
          flagUri: elem['Unicode'],
          currency: elem['Currency'],
          capital: elem['Capital'],
          continent: elem['Continent']));
    });
    return elements;
  }
}
