/* class Category {
  final int? id;
  final String? title;
  final String? thumbnail;
  final int? numberOfCourses;
  final int? numberOfSubCategories;

  Category({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.numberOfCourses,
    required this.numberOfSubCategories,
  });
}
 */

import 'package:equatable/equatable.dart';

class CategoryPlatformData extends Equatable {
  final String id,
      code,
      title,
      parent,
      slug,
      dateAdded,
      lastModified,
      fontAwesomeClass,
      thumbnail;
  final int numberOfSubCategories, numberOfCourses;
  const CategoryPlatformData({
    required this.id,
    required this.code,
    required this.title,
    required this.parent,
    required this.slug,
    required this.dateAdded,
    required this.lastModified,
    required this.fontAwesomeClass,
    required this.thumbnail,
    required this.numberOfSubCategories,
    required this.numberOfCourses,
  });
  CategoryPlatformData copyWith({
    String? id,
    String? code,
    String? title,
    String? parent,
    String? slug,
    String? dateAdded,
    String? lastModified,
    String? fontAwesomeClass,
    String? thumbnail,
    int? numberOfSubCategories,
    int? numberOfCourses,
  }) {
    return CategoryPlatformData(
      numberOfSubCategories:
          numberOfSubCategories ?? this.numberOfSubCategories,
      numberOfCourses: numberOfCourses ?? this.numberOfCourses,
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      parent: parent ?? this.parent,
      slug: slug ?? this.slug,
      dateAdded: dateAdded ?? this.dateAdded,
      lastModified: lastModified ?? this.lastModified,
      fontAwesomeClass: fontAwesomeClass ?? this.fontAwesomeClass,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'code': code,
      'name': title,
      'parent': parent,
      'slug': slug,
      'number_of_sub_categories': numberOfSubCategories,
      'number_of_courses': numberOfCourses,
      'date_added': dateAdded,
      'last_modified': lastModified,
      'font_awesome_class': fontAwesomeClass,
      'thumbnail': thumbnail
    };
  }

  factory CategoryPlatformData.fromJson(Map<String, Object?> json) {
    return CategoryPlatformData(
      numberOfCourses: json.containsKey("number_of_courses")
          ? json['number_of_courses'] == null
              ? 0
              : json['number_of_courses'] as int
          : 0,
      numberOfSubCategories: json.containsKey("number_of_sub_categories")
          ? json['number_of_sub_categories'] == null
              ? 0
              : json['number_of_sub_categories'] as int
          : json.containsKey("sub_categories")
              ? (json["sub_categories"] as List).length
              : 0,
      id: json['id'] == null ? '' : json['id'] as String,
      code: json['code'] == null ? '' : json['code'] as String,
      title: json['name'] == null ? '' : json['name'] as String,
      parent: json['parent'] == null ? '' : json['parent'] as String,
      slug: json['slug'] == null ? '' : json['slug'] as String,
      dateAdded: json['date_added'] == null ? '' : json['date_added'] as String,
      lastModified:
          json['last_modified'] == null ? '' : json['last_modified'] as String,
      fontAwesomeClass: json['font_awesome_class'] == null
          ? ''
          : json['font_awesome_class'] as String,
      thumbnail: json['thumbnail'] == null ? '' : json['thumbnail'] as String,
    );
  }

  @override
  String toString() {
    return '''Category(
                id:$id,
code:$code,
name:$title,
parent:$parent,
slug:$slug,
dateAdded:$dateAdded,
lastModified:$lastModified,
numberOfSubCategories:$numberOfSubCategories,
numberOfCourses:$numberOfCourses,
fontAwesomeClass:$fontAwesomeClass,
thumbnail:$thumbnail
    ) ''';
  }

  @override
  List<Object> get props => [
        code,
        title,
        parent,
        slug,
        dateAdded,
        lastModified,
        fontAwesomeClass,
        thumbnail,
        numberOfCourses,
        numberOfSubCategories,
      ];
}
