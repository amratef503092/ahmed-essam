/* class Lesson {
  int? id;
  String? title;
  String? duration;
  String? videoUrl;
  String? lessonType;
  String? isFree;
  String? summary;
  String? attachmentType;
  String? attachment;
  String? attachmentUrl;
  String? isCompleted;
  String? videoUrlWeb;
  String? videoTypeWeb;
  String? vimeoVideoId;

  Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.lessonType,
    this.isFree,
    this.videoUrl,
    this.summary,
    this.attachmentType,
    this.attachment,
    this.attachmentUrl,
    this.isCompleted,
    this.videoUrlWeb,
    this.videoTypeWeb,
    this.vimeoVideoId,
  });
}
 */

import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final String id,
      title,
      duration,
      videoUrl,
      lessonType,
      isFree,
      summary,
      attachmentType,
      attachment,
      attachmentUrl,
      isCompleted,
      videoUrlWeb,
      videoTypeWeb /* ,
      vimeoVideoId */
      ;
  /* final String courseId;
  final String sectionId;
  final String videoType;
  final bool userValidity; */
  const Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.lessonType,
    this.videoUrl = "",
    this.videoUrlWeb = "",
    this.videoTypeWeb = "",
    this.isFree = "",
    this.attachment = "",
    this.attachmentUrl = "",
    this.attachmentType = "",
    this.summary = "",
    this.isCompleted = "",
/*     required this.courseId,
    required this.sectionId,
    required this.videoType,
    required this.userValidity,
 */
  });
  Lesson copyWith({
    String? id,
    String? title,
    String? duration,
    String? courseId,
    String? sectionId,
    String? videoType,
    String? videoUrl,
    String? videoUrlWeb,
    String? videoTypeWeb,
    String? lessonType,
    String? isFree,
    String? attachmentUrl,
    String? attachment,
    String? attachmentType,
    String? summary,
    String? isCompleted,
    bool? userValidity,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      videoUrl: videoUrl ?? this.videoUrl,
      videoUrlWeb: videoUrlWeb ?? this.videoUrlWeb,
      videoTypeWeb: videoTypeWeb ?? this.videoTypeWeb,
      lessonType: lessonType ?? this.lessonType,
      isFree: isFree ?? this.isFree,
      attachment: attachment ?? this.attachment,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      attachmentType: attachmentType ?? this.attachmentType,
      summary: summary ?? this.summary,
      isCompleted: isCompleted ?? this.isCompleted,
/*       courseId: courseId ?? this.courseId,
      sectionId: sectionId ?? this.sectionId,
      videoType: videoType ?? this.videoType,
      userValidity: userValidity ?? this.userValidity,
 */
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'video_url': videoUrl,
      'video_url_web': videoUrlWeb,
      'video_type_web': videoTypeWeb,
      'lesson_type': lessonType,
      'is_free': isFree,
      'attachment': attachment,
      'attachment_url': attachmentUrl,
      'attachment_type': attachmentType,
      'summary': summary,
      'is_completed': isCompleted,
/*       'course_id': courseId,
      'section_id': sectionId,
      'video_type': videoType,
      'user_validity': userValidity
 */
    };
  }

  factory Lesson.fromJson(Map<String, Object?> json) {
    return Lesson(
      id: json['id'] == null ? "" : json['id'] as String,
      title: json['title'] == null ? "" : json['title'] as String,
      duration: json['duration'] == null ? "" : json['duration'] as String,
      videoUrl: json['video_url'] == null ? "" : json['video_url'] as String,
      videoUrlWeb:
          json['video_url_web'] == null ? "" : json['video_url_web'] as String,
      videoTypeWeb: json['video_type_web'] == null
          ? ""
          : json['video_type_web'] as String,
      lessonType:
          json['lesson_type'] == null ? "" : json['lesson_type'] as String,
      isFree: json['is_free'] == null ? "" : json['is_free'] as String,
      attachment:
          json['attachment'] == null ? "" : json['attachment'] as String,
      attachmentUrl: json['attachment_url'] == null
          ? ""
          : json['attachment_url'] as String,
      attachmentType: json['attachment_type'] == null
          ? ""
          : json['attachment_type'] as String,
      summary: json['summary'] == null ? "" : json['summary'] as String,
      isCompleted:
          json['is_completed'] == null ? "" : json['is_completed'].toString(),
/*       courseId: json['course_id'] == null ? "" : json['course_id'] as String,
      sectionId: json['section_id'] == null ? "" : json['section_id'] as String,
      videoType: json['video_type'] == null ? "" : json['video_type'] as String,
      userValidity:
          json['user_validity'] == null ? false : json['user_validity'] as bool,
 */
    );
  }

  @override
  String toString() {
    return '''Lessons(
                id:$id,
title:$title,
duration:$duration,
videoUrl:$videoUrl,
videoUrlWeb:$videoUrlWeb,
videoTypeWeb:$videoTypeWeb,
lessonType:$lessonType,
isFree:$isFree,
attachment:$attachment,
attachmentUrl:$attachmentUrl,
attachmentType:$attachmentType,
summary:$summary,
isCompleted:$isCompleted,
courseId:courseId,
sectionId:sectionId,
videoType:videoType,
userValidity:userValidity
    ) ''';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        duration,
        videoUrl,
        videoUrlWeb,
        videoTypeWeb,
        lessonType,
        isFree,
        attachment,
        attachmentUrl,
        attachmentType,
        summary,
        isCompleted,
/*         courseId,
        sectionId,
        videoType,
        userValidity,
 */
      ];
}
