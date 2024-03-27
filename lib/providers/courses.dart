import 'dart:convert';
import 'package:three_m_physics/models/course.dart';
import 'package:three_m_physics/models/course_detail.dart';
import 'package:three_m_physics/models/lesson.dart';
import 'package:three_m_physics/models/section.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import 'shared_pref_helper.dart';

class Courses with ChangeNotifier {
  List<Course> _items = [];
  List<Course> _topItems = [];
  CourseDetail? _courseDetailsitems;

  Courses(this._items, this._topItems);

  List<Course> get items {
    return [..._items];
  }

  List<Course> get topItems {
    return [..._topItems];
  }

  CourseDetail? get getCourseDetail {
    return _courseDetailsitems;
  }

  int get itemCount {
    return _items.length;
  }

  Course findById(int id) {
    // return _topItems.firstWhere((course) => course.id == id);
    return _items.firstWhere((course) => int.parse(course.id) == id,
        orElse: () =>
            _topItems.firstWhere((course) => int.parse(course.id) == id));
  }

  Future<void> fetchTopCourses() async {
    var url = '$BASE_URL/api/top_courses';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      _topItems = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCoursesByCategory(int categoryId) async {
    var url = '$BASE_URL/api/category_wise_course?category_id=$categoryId';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);

      _items = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCoursesBySearchQuery(String searchQuery) async {
    var url =
        '$BASE_URL/api/courses_by_search_string?search_string=$searchQuery';
    // print(url);
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);

      _items = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

   Future<void> filterCourses(
     { required  selectedCategory,
    required  String selectedPrice,
     required String selectedLevel,
    required  String selectedLanguage,
   required   String selectedRating,
      String? selectCountry}) async {
    var url =
        '$BASE_URL/api/filter_course?selected_country=$selectCountry&selected_category=$selectedCategory&selected_price=$selectedPrice&selected_level=$selectedLevel&selected_language=$selectedLanguage&selected_rating=$selectedRating&selected_search_string=';
    // print(url);
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);

      _items = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchMyWishlist() async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/my_wishlist?auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      _items = buildCourseList(extractedData);
      // print(_items);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Course> buildCourseList(List extractedData) {
    final List<Course> loadedCourses = (extractedData)
        .map<Course>((data) => Course.fromJson(data as Map<String, Object?>))
        .toList();

    return loadedCourses;
  }

  bool isWishlisted = false;
  Future<void> toggleWishlist(int courseId, bool removeItem) async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/toggle_wishlist_items?auth_token=$authToken&course_id=$courseId';
    if (!removeItem) {
      isWishlisted = !isWishlisted;
      _courseDetailsitems?.copyWith(
        isWishlisted: _courseDetailsitems?.isWishlisted == true ? false : true,
      );
      notifyListeners();
    }
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      debugPrint(responseData.toString());
      if (responseData['status'] == 'removed') {
        if (removeItem) {
          final existingMyCourseIndex =
              _items.indexWhere((mc) => int.parse(mc.id) == courseId);
          _items.removeAt(existingMyCourseIndex);
          notifyListeners();
        } else {
          isWishlisted = false;
          _courseDetailsitems?.copyWith(isWishlisted: false);
        }
      } else if (responseData['status'] == 'added') {
        if (!removeItem) {
          isWishlisted = true;
          _courseDetailsitems?.copyWith(isWishlisted: true);
        }
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<CourseDetail?> fetchCourseDetailById(int courseId) async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/course_details_by_id?course_id=$courseId';
    if (authToken != null) {
      url =
          '$BASE_URL/api/course_details_by_id?auth_token=$authToken&course_id=$courseId';
    }

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      if (extractedData.isEmpty) {
        return null;
      }
      _courseDetailsitems = CourseDetail.fromJson(extractedData.first);
      isWishlisted = _courseDetailsitems?.isWishlisted ?? false;
      notifyListeners();
      return _courseDetailsitems;
    } catch (error) {
      return null;
    }
  }
    bool isLoading = false;

  Future<void> getInestractorPhone(int courseId, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    // https://nata3lm.com/api/get_instructor_phone?course_id=4
    // var authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/get_instructor_phone?course_id=$courseId';

    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      Map data = jsonDecode(response.body);
      if (data['instructor_phone'] != null) {
        // url luncher
        String phoneNumber = data['instructor_phone'];
        String message = "Hello, I'm interested in your course.";
        String whatsappUrl = "https://wa.me/$phoneNumber?text=$message";

        if (await launchUrl(
            Uri.parse(
              whatsappUrl,
            ),
            mode: LaunchMode.externalApplication)) {
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Can not Get Whats App Number"),
              backgroundColor: Colors.red,
            ),
          );
          print("Could not launch $whatsappUrl");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Can not Get Whats App Number"),
            backgroundColor: Colors.red,
          ),
        );
      }
      isLoading = false;
    } catch (error) {
      isLoading = false;

      rethrow;
    }
    notifyListeners();
  }

  Future<void> getEnrolled(int courseId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/enroll_free_course?course_id=$courseId&auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData['message'] == 'success') {
        _courseDetailsitems?.copyWith(isPurchased: true);

        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  List<Section> buildCourseSections(List extractedSections) {
    List<Section> loadedSections =
        extractedSections.map((e) => Section.fromJson(e)).toList();
    return loadedSections;
  }

  List<Lesson> buildCourseLessons(List extractedLessons) {
    final List<Lesson> loadedLessons =
        extractedLessons.map((e) => Lesson.fromJson(e)).toList();

    return loadedLessons;
  }
}
