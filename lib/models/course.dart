import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id,
      title,
      thumbnail,
      price,
      instructor,
      instructorImage,
      shareableLink,
      courseOverviewUrl,
      vimeoVideoId,
      courseOverviewProvider,
      // courseOverviewProvider,
      isFreeCourse;
  final int rating, numberOfEnrollment, totalNumberRating;

  // final String shortDescription, description;
  // final String language, categoryId, subCategoryId, section;
  // final String discountedPrice, level, userId, countryId;
  // final String dateAdded, lastModified;
  // final String courseType, isTopCourse, isAdmin, status, metaDescription;
  // final String metaKeywords, multiInstructor, enableDripContent, creator;
  // final List<String> outcomes;
  // final List<String> requirements;
  // // dynamic discountFlag;
  // final String expiryPeriod;
  // final String instructorName;

  const Course({
    required this.courseOverviewProvider,
    required this.instructor,
    required this.vimeoVideoId,
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.courseOverviewUrl,
    required this.isFreeCourse,
    required this.rating,
    required this.totalNumberRating,
    required this.instructorImage,
    required this.numberOfEnrollment,
    required this.shareableLink,
    // required this.instructorName,
    // required this.shortDescription,
    // required this.description,
    // required this.outcomes,
    // required this.faqs,
    // required this.language,
    // required this.categoryId,
    // required this.subCategoryId,
    // required this.section,
    // required this.requirements,
    // // required this.discountFlag,
    // required this.discountedPrice,
    // required this.level,
    // required this.userId,
    // required this.countryId,
    // required this.dateAdded,
    // required this.lastModified,
    // required this.courseType,
    // required this.isTopCourse,
    // required this.isAdmin,
    // required this.status,
    // // required this.courseOverviewProvider,
    // required this.metaKeywords,
    // required this.metaDescription,
    // required this.multiInstructor,
    // required this.enableDripContent,
    // required this.creator,
    // required this.expiryPeriod,
  });
  Course copyWith({
    String? courseOverviewProvider,
    String? instructor,
    String? vimeoVideoId,
    String? id,
    String? title,
    String? shortDescription,
    String? description,
    List<String>? outcomes,
    String? faqs,
    String? language,
    String? categoryId,
    String? subCategoryId,
    String? section,
    List<String>? requirements,
    String? price,
    // String? discountFlag,
    String? discountedPrice,
    String? level,
    String? userId,
    String? countryId,
    String? thumbnail,
    String? courseOverviewUrl,
    String? dateAdded,
    String? lastModified,
    String? courseType,
    String? isTopCourse,
    String? isAdmin,
    String? status,
    // String? courseOverviewProvider,
    String? metaKeywords,
    String? metaDescription,
    String? isFreeCourse,
    String? multiInstructor,
    String? enableDripContent,
    String? creator,
    String? expiryPeriod,
    int? rating,
    int? totalNumberRating,
    // String? instructorName,
    String? instructorImage,
    int? numberOfEnrollment,
    String? shareableLink,
  }) {
    return Course(
      courseOverviewProvider:
          courseOverviewProvider ?? this.courseOverviewProvider,
      instructor: instructor ?? this.instructor,
      vimeoVideoId: vimeoVideoId ?? this.vimeoVideoId,
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
      courseOverviewUrl: courseOverviewUrl ?? this.courseOverviewUrl,
      rating: rating ?? this.rating,
      isFreeCourse: isFreeCourse ?? this.isFreeCourse,
      totalNumberRating: totalNumberRating ?? this.totalNumberRating,
      instructorImage: instructorImage ?? this.instructorImage,
      numberOfEnrollment: numberOfEnrollment ?? this.numberOfEnrollment,
      shareableLink: shareableLink ?? this.shareableLink,
      // shortDescription: shortDescription ?? this.shortDescription,
      // description: description ?? this.description,
      // outcomes: outcomes ?? this.outcomes,
      // faqs: faqs ?? this.faqs,
      // language: language ?? this.language,
      // categoryId: categoryId ?? this.categoryId,
      // subCategoryId: subCategoryId ?? this.subCategoryId,
      // section: section ?? this.section,
      // requirements: requirements ?? this.requirements,
      // discountFlag: discountFlag ?? this.discountFlag,
      // discountedPrice: discountedPrice ?? this.discountedPrice,
      // level: level ?? this.level,
      // userId: userId ?? this.userId,
      // countryId: countryId ?? this.countryId,
      // dateAdded: dateAdded ?? this.dateAdded,
      // lastModified: lastModified ?? this.lastModified,
      // courseType: courseType ?? this.courseType,
      // isTopCourse: isTopCourse ?? this.isTopCourse,
      // isAdmin: isAdmin ?? this.isAdmin,
      // status: status ?? this.status,
      // courseOverviewProvider:
      // courseOverviewProvider ?? this.courseOverviewProvider,
      // metaKeywords: metaKeywords ?? this.metaKeywords,
      // metaDescription: metaDescription ?? this.metaDescription,
      // multiInstructor: multiInstructor ?? this.multiInstructor,
      // enableDripContent: enableDripContent ?? this.enableDripContent,
      // creator: creator ?? this.creator,
      // expiryPeriod: expiryPeriod ?? this.expiryPeriod,
      // instructorName: instructorName ?? this.instructorName,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'thumbnail': thumbnail,
      'video_url': courseOverviewUrl,
      'is_free_course': isFreeCourse,
      'rating': rating,
      'number_of_ratings': totalNumberRating,
      'instructor_image': instructorImage,
      'total_enrollment': numberOfEnrollment,
      'shareable_link': shareableLink,
      // 'short_description': shortDescription,
      // 'description': description,
      // 'outcomes': outcomes,
      // 'faqs': faqs,
      // 'language': language,
      // 'category_id': categoryId,
      // 'sub_category_id': subCategoryId,
      // 'section': section,
      // 'requirements': requirements,
      // 'discount_flag': discountFlag,
      // 'discounted_price': discountedPrice,
      // 'level': level,
      // 'user_id': userId,
      // 'country_id': countryId,
      // 'date_added': dateAdded,
      // 'last_modified': lastModified,
      // 'course_type': courseType,
      // 'is_top_course': isTopCourse,
      // 'is_admin': isAdmin,
      // 'status': status,
      // 'course_overview_provider': courseOverviewProvider,
      // 'meta_keywords': metaKeywords,
      // 'meta_description': metaDescription,
      // 'multi_instructor': multiInstructor,
      // 'enable_drip_content': enableDripContent,
      // 'creator': creator,
      // 'expiry_period': expiryPeriod,
      // 'instructor_name': instructorName,
    };
  }

  factory Course.fromJson(Map<String, Object?> json) {
    return Course(
      courseOverviewProvider: json['course_overview_provider'] == null
          ? ""
          : json['course_overview_provider'] as String,
      instructor: json['instructor_name'] == null
          ? ""
          : json['instructor_name'] as String,
      vimeoVideoId: json['vimeo_video_id'] == null
          ? ""
          : json['vimeo_video_id'] as String,
      id: json['id'] == null ? "" : json['id'] as String,
      title: json['title'] == null ? "" : json['title'] as String,
      price: json['price'] == null ? "" : json['price'] as String,
      thumbnail: json['thumbnail'] == null ? "" : json['thumbnail'] as String,
      courseOverviewUrl:
          json['video_url'] == null ? "" : json['video_url'] as String,
      isFreeCourse: json['is_free_course'] == null
          ? ""
          : json['is_free_course'] as String,
      rating: json['rating'] == null ? 0 : json['rating'] as int,
      totalNumberRating: json['number_of_ratings'] == null
          ? 0
          : json['number_of_ratings'] as int,
      instructorImage: json['instructor_image'] == null
          ? ""
          : json['instructor_image'] as String,
      numberOfEnrollment: json['total_enrollment'] == null
          ? 0
          : json['total_enrollment'] as int,
      shareableLink: json['shareable_link'] == null
          ? ""
          : json['shareable_link'] as String,
      // shortDescription: json['short_description'] == null
      //     ? ""
      //     : json['short_description'] as String,
      // description:
      //     json['description'] == null ? "" : json['description'] as String,
      // outcomes:
      //     json['outcomes'] == null ? [] : json['outcomes'] as List<String>,
      // faqs: json['faqs'] == null ? "" : json['faqs'] as String,
      // language: json['language'] == null ? "" : json['language'] as String,
      // categoryId:
      //     json['category_id'] == null ? "" : json['category_id'] as String,
      // subCategoryId: json['sub_category_id'] == null
      //     ? ""
      //     : json['sub_category_id'] as String,
      // section: json['section'] == null ? "" : json['section'] as String,
      // requirements: json['requirements'] == null
      //     ? []
      //     : json['requirements'] as List<String>,
      // discountFlag: json['discount_flag'] as dynamic,
      // discountedPrice: json['discounted_price'] == null
      //     ? ""
      //     : json['discounted_price'] as String,
      // level: json['level'] == null ? "" : json['level'] as String,
      // userId: json['user_id'] == null ? "" : json['user_id'] as String,
      // countryId: json['country_id'] == null ? "" : json['country_id'] as String,
      // dateAdded: json['date_added'] == null ? "" : json['date_added'] as String,
      // lastModified:
      //     json['last_modified'] == null ? "" : json['last_modified'] as String,
      // courseType:
      //     json['course_type'] == null ? "" : json['course_type'] as String,
      // isTopCourse:
      //     json['is_top_course'] == null ? "" : json['is_top_course'] as String,
      // isAdmin: json['is_admin'] == null ? "" : json['is_admin'] as String,
      // status: json['status'] == null ? "" : json['status'] as String,
      // courseOverviewProvider: json['course_overview_provider'] == null
      // ? ""
      // : json['course_overview_provider'] as String,
      // metaKeywords:
      //     json['meta_keywords'] == null ? "" : json['meta_keywords'] as String,
      // metaDescription: json['meta_description'] == null
      //     ? ""
      //     : json['meta_description'] as String,
      // multiInstructor: json['multi_instructor'] == null
      //     ? ""
      //     : json['multi_instructor'] as String,
      // enableDripContent: json['enable_drip_content'] == null
      //     ? ""
      //     : json['enable_drip_content'] as String,
      // creator: json['creator'] == null ? "" : json['creator'] as String,
      // expiryPeriod: json['expiry_period'] as dynamic,
      // instructorName: json['instructor_name'] == null
      // ? ""
      // : json['instructor_name'] as String,
    );
  }

  @override
  String toString() {
    return '''Course(
                id:$id,
title:$title,
shortDescription:shortDescription,
description:description,
outcomes:outcomes,
faqs:faqs,
language:language,
categoryId:categoryId,
subCategoryId:subCategoryId,
section:section,
requirements:requirements,
price:$price,
discountFlag:discountFlag,
discountedPrice:discountedPrice,
level:level,
userId:userId,
countryId:countryId,
thumbnail:$thumbnail,
videoUrl:$courseOverviewUrl,
dateAdded:dateAdded,
lastModified:lastModified,
courseType:courseType,
isTopCourse:isTopCourse,
isAdmin:isAdmin,
status:status,
courseOverviewProvider:courseOverviewProvider,
metaKeywords:metaKeywords,
metaDescription:metaDescription,
isFreeCourse:$isFreeCourse,
multiInstructor:multiInstructor,
enableDripContent:enableDripContent,
creator:creator,
expiryPeriod:expiryPeriod,
rating:$rating,
numberOfRatings:$totalNumberRating,
instructorName:instructorName,
instructorImage:$instructorImage,
totalEnrollment:$numberOfEnrollment,
shareableLink:$shareableLink
    ) ''';
  }

  @override
  List<Object> get props => [
        courseOverviewProvider,
        instructor,
        vimeoVideoId,
        id,
        title,
        price,
        thumbnail,
        courseOverviewUrl,
        isFreeCourse,
        rating,
        totalNumberRating,
        instructorImage,
        numberOfEnrollment,
        shareableLink,
      ];
}
