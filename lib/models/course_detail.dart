import 'package:equatable/equatable.dart';

import 'section.dart';

class CourseDetail extends Equatable {
  final String courseId;
  final List<String> courseIncludes, courseRequirements, courseOutcomes;
  final bool isWishlisted, isPurchased;
  final List<Section> mSection;

  const CourseDetail({
    required this.courseId,
    required this.courseOutcomes,
    required this.courseRequirements,
    required this.mSection,
    required this.isWishlisted,
    required this.isPurchased,
    required this.courseIncludes,
  });
  CourseDetail copyWith({
    String? courseId,
    List<String>? courseOutcomes,
    List<String>? courseRequirements,
    List<Section>? mSection,
    bool? isWishlisted,
    bool? isPurchased,
    List<String>? courseIncludes,
  }) {
    return CourseDetail(
      courseId: courseId ?? this.courseId,
      courseRequirements: courseRequirements ?? this.courseRequirements,
      mSection: mSection ?? this.mSection,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      isPurchased: isPurchased ?? this.isPurchased,
      courseIncludes: courseIncludes ?? this.courseIncludes,
      courseOutcomes: courseOutcomes ?? this.courseOutcomes,
    );
  }

  factory CourseDetail.fromJson(Map<String, Object?> json) {
    return CourseDetail(
      courseId: json['id'] == null ? "0" : json['id'] as String,
      courseOutcomes: json['outcomes'] == null
          ? []
          : (json['outcomes'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
      courseRequirements: json['requirements'] == null
          ? []
          : (json['requirements'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
      mSection: json['sections'] == null
          ? []
          : (json['sections'] as List)
              .map<Section>(
                  (data) => Section.fromJson(data as Map<String, Object?>))
              .toList(),
      isWishlisted:
          json['is_wishlisted'] == null ? false : json['is_wishlisted'] as bool,
      isPurchased: json['is_purchased'] == null
          ? false
          : (json['is_purchased'].toString() == "1" ? true : false),
      courseIncludes: json['includes'] == null
          ? []
          : (json['includes'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
    );
  }

  @override
  String toString() {
    return '''CourseDetail(
                id:$courseId,
title:title,
shortDescription:shortDescription,
description:description,
outcomes:$courseOutcomes,
faqs:faqs,
language:language,
categoryId:categoryId,
subCategoryId:subCategoryId,
section:section,
requirements:$courseRequirements,
price:price,
discountedPrice:discountedPrice,
level:level,
userId:userId,
countryId:countryId,
thumbnail:thumbnail,
videoUrl:videoUrl,
dateAdded:dateAdded,
lastModified:lastModified,
courseType:courseType,
isTopCourse:isTopCourse,
isAdmin:isAdmin,
status:status,
courseOverviewProvider:courseOverviewProvider,
metaKeywords:metaKeywords,
metaDescription:metaDescription,
isFreeCourse:isFreeCourse,
multiInstructor:multiInstructor,
enableDripContent:enableDripContent,
creator:creator,
rating:rating,
numberOfRatings:numberOfRatings,
instructorName:instructorName,
instructorImage:instructorImage,
totalEnrollment:totalEnrollment,
shareableLink:shareableLink,
sections:${mSection.toString()},
isWishlisted:$isWishlisted,
isPurchased:$isPurchased,
includes:$courseIncludes
    ) ''';
  }

  @override
  List<Object> get props => [
        courseId,
        courseRequirements,
        mSection,
        isWishlisted,
        isPurchased,
        courseIncludes,
        courseOutcomes,
      ];
}
