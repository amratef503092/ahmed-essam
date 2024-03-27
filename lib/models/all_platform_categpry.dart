import 'package:three_m_physics/models/course.dart';
import 'package:equatable/equatable.dart';

import 'category.dart';

class AllCategoriesPlatformModel extends Equatable {
  final List<SubCategories> allCategories;
  const AllCategoriesPlatformModel({required this.allCategories});

  AllCategoriesPlatformModel copyWith({
    List<SubCategories>? allCategories,
  }) {
    return AllCategoriesPlatformModel(
      allCategories: allCategories ?? this.allCategories,
    );
  }

  factory AllCategoriesPlatformModel.fromJson(List json) {
    return AllCategoriesPlatformModel(
      allCategories: (json)
          .map<SubCategories>(
              (data) => SubCategories.fromJson(data as Map<String, Object?>))
          .toList(),
    );
  }

  @override
  String toString() {
    return '''AllCategoriesModel(
allCategories:${allCategories.toString()},
    ) ''';
  }

  @override
  List<Object> get props => [allCategories];
}

class AllCategoriesData extends Equatable {
  final CategoryPlatformData? category;
  final List<SubCategories> subCategories;
  final List<Course> courses;
  const AllCategoriesData({
    required this.category,
    required this.subCategories,
    required this.courses,
  });

  AllCategoriesData copyWith({
    CategoryPlatformData? category,
    List<SubCategories>? subCategories,
    List<Course>? courses,
  }) {
    return AllCategoriesData(
      category: category ?? this.category,
      subCategories: subCategories ?? this.subCategories,
      courses: courses ?? this.courses,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'category': category?.toJson(),
      'sub_categories': subCategories
          .map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'courses':
          courses.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  factory AllCategoriesData.fromJson(Map<String, Object?> json) {
    return AllCategoriesData(
      category: json['category'] == null
          ? null
          : CategoryPlatformData.fromJson(
              json['category'] as Map<String, Object?>),
      subCategories: json['sub_categories'] == null
          ? []
          : (json['subCategories'] as List)
              .map<SubCategories>((data) =>
                  SubCategories.fromJson(data as Map<String, Object?>))
              .toList(),
      courses: json['courses'] == null
          ? []
          : (json['courses'] as List)
              .map<Course>(
                  (data) => Course.fromJson(data as Map<String, Object?>))
              .toList(),
    );
  }

  @override
  String toString() {
    return '''AllCategoriesData(
                category:${category.toString()},
subCategories:${subCategories.toString()},
courses:$courses
    ) ''';
  }

  @override
  List<Object?> get props => [category, subCategories, courses];
}

class SubCategories extends Equatable {
  final CategoryPlatformData? category;
  final List<SubCategories> subCategories;
  final List<Course> courses;
  const SubCategories({
    this.category,
    required this.subCategories,
    required this.courses,
  });

  SubCategories copyWith({
    CategoryPlatformData? category,
    List<SubCategories>? subCategories,
    List<Course>? courses,
  }) {
    return SubCategories(
      category: category ?? this.category,
      subCategories: subCategories ?? this.subCategories,
      courses: courses ?? this.courses,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'category': category?.toJson(),
      'sub_categories': subCategories
          .map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'courses':
          courses.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  factory SubCategories.fromJson(Map<String, Object?> json) {
    return SubCategories(
      category: json['category'] == null
          ? null
          : CategoryPlatformData.fromJson(
              json['category'] as Map<String, Object?>),
      subCategories: json['sub_categories'] == null
          ? []
          : (json['sub_categories'] as List)
              .map<SubCategories>(
                (data) => SubCategories.fromJson(
                  data as Map<String, Object?>,
                ),
              )
              .toList(),
      courses: json['courses'] == null
          ? []
          : (json['courses'] as List)
              .map<Course>(
                  (data) => Course.fromJson(data as Map<String, Object?>))
              .toList(),
    );
  }

  @override
  String toString() {
    return '''SubCategories(
                category:${category.toString()},
subCategories:${subCategories.toString()},
courses:$courses
    ) ''';
  }

  @override
  List<Object?> get props => [category, subCategories, courses];
}

class SubCategoriesPlatformModel extends Equatable {
  final CategoryPlatformData? category;
  final List<SubCategories> subCategories;
  final List<Course> courses;
  const SubCategoriesPlatformModel({
    this.category,
    required this.subCategories,
    required this.courses,
  });

  SubCategoriesPlatformModel copyWith({
    CategoryPlatformData? category,
    List<SubCategories>? subCategories,
    List<Course>? courses,
  }) {
    return SubCategoriesPlatformModel(
      category: category ?? this.category,
      subCategories: subCategories ?? this.subCategories,
      courses: courses ?? this.courses,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'category': category?.toJson(),
      'sub_categories': subCategories
          .map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'courses':
          courses.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  factory SubCategoriesPlatformModel.fromJson(Map<String, Object?> json) {
    return SubCategoriesPlatformModel(
      category: CategoryPlatformData.fromJson(json),
      subCategories: json['sub_categories'] == null
          ? []
          : (json['sub_categories'] as List)
              .map<SubCategories>(
                (data) => SubCategories.fromJson(
                  data as Map<String, Object?>,
                ),
              )
              .toList(),
      courses: json['courses'] == null
          ? []
          : (json['courses'] as List)
              .map<Course>(
                  (data) => Course.fromJson(data as Map<String, Object?>))
              .toList(),
    );
  }

  @override
  String toString() {
    return '''SubCategoriesPlatformModel(
                category:${category.toString()},
subCategories:${subCategories.toString()},
courses:$courses
    ) ''';
  }

  @override
  List<Object?> get props => [category, subCategories, courses];
}
