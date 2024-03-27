import 'dart:convert';

import 'package:three_m_physics/models/lesson.dart';
import 'package:three_m_physics/models/my_course.dart';
import 'package:three_m_physics/models/section.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'shared_pref_helper.dart';

class MyCourses with ChangeNotifier {
  List<Section> _sectionItems = [];

  MyCourses(this._items, this._sectionItems);

  List<MyCourse> _items = [];
  List<MyCourse> get items {
    return [..._items];
  }

  List<Section> get sectionItems {
    return [..._sectionItems];
  }

  int get itemCount {
    return _items.length;
  }

  MyCourse? findById(int id) {
    if (_items.isEmpty) {
      // debugPrint("_items.isEmpty => is ${_items.isEmpty}");
      return MyCourse(
        id: id,
        title: "",
        thumbnail: "",
        price: "",
        instructor: "",
        rating: 0,
        totalNumberRating: 0,
        numberOfEnrollment: 0,
        shareableLink: "",
        courseOverviewProvider: "",
        courseOverviewUrl: "",
        courseCompletion: 0,
        totalNumberOfLessons: 0,
        totalNumberOfCompletedLessons: 0,
        enableDripContent: "",
      );
    }
    // debugPrint("findById(int id) => _items is ${_items.length}");
    // debugPrint("findById(int id) => id is $id");
    MyCourse? result = _items.firstWhereOrNull((myCourse) => myCourse.id == id);
    if (result == null) {
      // debugPrint("result => is null");

      // Get.back();
      return null; /*  MyCourse(
        id: id,
        title: "",
        thumbnail: "",
        price: "",
        instructor: "",
        rating: 0,
        totalNumberRating: 0,
        numberOfEnrollment: 0,
        shareableLink: "",
        courseOverviewProvider: "",
        courseOverviewUrl: "",
        courseCompletion: 0,
        totalNumberOfLessons: 0,
        totalNumberOfCompletedLessons: 0,
        enableDripContent: "",
      ); */
    } else {
      // debugPrint("result id => is ${result.id}");
      return result;
    }
  }

  Future<void> fetchMyCourses() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/my_courses?auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData.isEmpty || extractedData == null) {
        return;
      }
      // print(extractedData);
      _items = buildMyCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<MyCourse> buildMyCourseList(List extractedData) {
    final List<MyCourse> loadedCourses = [];
    for (var courseData in extractedData) {
      loadedCourses.add(MyCourse(
        id: int.parse(courseData['id']),
        title: courseData['title'],
        thumbnail: courseData['thumbnail'],
        price: courseData['price'],
        instructor: courseData['instructor_name'],
        rating: courseData['rating'],
        totalNumberRating: courseData['number_of_ratings'],
        numberOfEnrollment: courseData['total_enrollment'],
        shareableLink: courseData['shareable_link'],
        courseOverviewProvider: courseData['course_overview_provider'],
        courseOverviewUrl: courseData['video_url'],
        courseCompletion: courseData['completion'],
        totalNumberOfLessons: courseData['total_number_of_lessons'],
        totalNumberOfCompletedLessons:
            courseData['total_number_of_completed_lessons'],
        enableDripContent: courseData['enable_drip_content'],
      ));
      // print(catData['name']);
    }
    return loadedCourses;
  }

  MyCourse? _myCourse;
  MyCourse? get myCourse => _myCourse;
  Future<MyCourse?> fetchCourseDetailById(int courseId) async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/course_details_by_id?course_id=$courseId';
    if (authToken != null) {
      url =
          '$BASE_URL/api/course_details_by_id?auth_token=$authToken&course_id=$courseId';
    }

    try {
      final response = await http.get(Uri.parse(url));
      final courseData = json.decode(response.body);
      // debugPrint("courseData >>>is $courseData");
      if (courseData == null) {
        Get.back();
        return null;
      }
      _myCourse = MyCourse(
        id: int.parse(courseData['id']),
        title: courseData['title'],
        thumbnail: courseData['thumbnail'],
        price: courseData['price'],
        instructor: courseData['instructor_name'],
        rating: courseData['rating'],
        totalNumberRating: courseData['number_of_ratings'],
        numberOfEnrollment: courseData['total_enrollment'],
        shareableLink: courseData['shareable_link'],
        courseOverviewProvider: courseData['course_overview_provider'],
        courseOverviewUrl: courseData['video_url'],
        courseCompletion: courseData['completion'],
        totalNumberOfLessons: courseData['total_number_of_lessons'],
        totalNumberOfCompletedLessons:
            courseData['total_number_of_completed_lessons'],
        enableDripContent: courseData['enable_drip_content'],
      );
      notifyListeners();
      return _myCourse;
    } catch (error) {
      return null;
    }
  }

  Future<void> fetchCourseSections(int courseId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/sections?auth_token=$authToken&course_id=$courseId';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      if (extractedData.isEmpty) {
        return;
      }

      final List<Section> loadedSections =
          extractedData.map((e) => Section.fromJson(e)).toList();

      _sectionItems = loadedSections;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Lesson> buildSectionLessons(List extractedLessons) {
    final List<Lesson> loadedLessons =
        extractedLessons.map((e) => Lesson.fromJson(e)).toList();

    return loadedLessons;
  }

  Future<void> toggleLessonCompleted(int lessonId, int progress) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/save_course_progress?auth_token=$authToken&lesson_id=$lessonId';
    // print(url);
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData['course_id'] != null) {
        final myCourse = findById(int.parse(responseData['course_id']));
        myCourse?.courseCompletion = responseData['course_progress'];
        myCourse?.totalNumberOfCompletedLessons =
            responseData['number_of_completed_lessons'];

        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateDripContendLesson(
      int courseId, int courseProgress, int numberOfCompletedLessons) async {
    final myCourse = findById(courseId);
    myCourse?.courseCompletion = courseProgress;
    myCourse?.totalNumberOfCompletedLessons = numberOfCompletedLessons;

    notifyListeners();
  }

  Future<void> getEnrolled(int courseId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/enroll_free_course?course_id=$courseId&auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData == null) {
        return;
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
