import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/country_model.dart';
import 'package:http/http.dart' as http;


class CountryProvider extends ChangeNotifier

{
  bool loading = false;
  CountryModel ?countryModel ;
  Countries ? value ;
  void setValue(Countries newValue)
  {
    value = newValue;
    notifyListeners();
  }
  Future<void> getCountry()
  async{
    loading = true;
    notifyListeners();
    final url = Uri.parse('https://nata3lm.com/api/countries');
    final response = await http.get(url);
    final extractedData = json.decode(response.body);
    final List<Countries> loadedCountry = [];
    extractedData['countries'].forEach((country) {
      loadedCountry.add(Countries.fromJson(country));
    });
    countryModel = CountryModel(countries: loadedCountry);
    loading = false;
    notifyListeners();
  }
}