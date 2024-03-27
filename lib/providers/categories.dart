import 'package:three_m_physics/models/all_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category.dart';
import '../constants.dart';

class Categories with ChangeNotifier {
  List<CategoryPlatformData> get items => _items;
  List<CategoryPlatformData> _items = [];
  Future<void> fetchCategories() async {
    var url = '$BASE_URL/api/categories';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      final List<CategoryPlatformData> loadedCategories = (extractedData)
          .map<CategoryPlatformData>((data) =>
              CategoryPlatformData.fromJson(data as Map<String, Object?>))
          .toList();
      _items = loadedCategories;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  /* List<SubCategories> _subItems = [];
  List<SubCategories> get subItems => [..._subItems];

  Future<void> fetchSubCategories(int catId) async {
    var url = '$BASE_URL/api/sub_categories/$catId';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      debugPrint(extractedData.length.toString());
      final List<SubCategories> loadedCategories =
          extractedData.map((e) => SubCategories.fromJson(e)).toList();
      debugPrint(" View <1>  ${_subItems.length}");
      _subItems = loadedCategories;
      notifyListeners();
      debugPrint(" res ${extractedData.length}  ");
      debugPrint(" TTTTT ${loadedCategories.length}  ");
      debugPrint(" View <2>  ${_subItems.length}");
    } catch (error) {
      rethrow;
    }
  }
 */

  List<AllCategory> _allItems = [];
  List<AllCategory> get allItems => _allItems;

  Future<void> fetchAllCategory() async {
    var url = '$BASE_URL/api/all_categories';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      final List<AllCategory> loadedCategories = [];

      for (var catData in extractedData) {
        loadedCategories.add(
          AllCategory(
            id: int.parse(catData['id']),
            title: catData['name'],
            subCategory:
                buildSubCategory(catData['sub_categories'] as List<dynamic>),
          ),
        );
      }
      _allItems = loadedCategories;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<AllSubCategory> buildSubCategory(List extractedSubCategory) {
    final List<AllSubCategory> loadedSubCategories = [];

    for (var subData in extractedSubCategory) {
      loadedSubCategories.add(AllSubCategory(
        id: int.parse(subData['id']),
        title: subData['name'],
      ));
    }
    return loadedSubCategories;
  }
}
