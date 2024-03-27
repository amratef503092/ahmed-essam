import 'package:equatable/equatable.dart';

import '../models/lesson.dart';
/* 
class Section {
  int? id;
  int? numberOfCompletedLessons;
  String? title;
  String? totalDuration;
  int? lessonCounterStarts;
  int? lessonCounterEnds;
  List<Lesson>? mLesson;

  Section({
    required this.id,
    required this.numberOfCompletedLessons,
    required this.title,
    required this.totalDuration,
    required this.lessonCounterEnds,
    required this.lessonCounterStarts,
    required this.mLesson,
  });
}
 */

class Section extends Equatable {
  final String id, title, totalDuration;
  final List<Lesson> mLesson;
  final int lessonCounterStarts, lessonCounterEnds, numberOfCompletedLessons;
  const Section({
    required this.id,
    required this.title,
    required this.mLesson,
    required this.totalDuration,
    required this.lessonCounterStarts,
    required this.lessonCounterEnds,
    required this.numberOfCompletedLessons,
  });
  Section copyWith({
    String? id,
    String? title,
    List<Lesson>? mLesson,
    String? totalDuration,
    int? lessonCounterStarts,
    int? lessonCounterEnds,
    int? numberOfCompletedLessons,
  }) {
    return Section(
      id: id ?? this.id,
      title: title ?? this.title,
      mLesson: mLesson ?? this.mLesson,
      totalDuration: totalDuration ?? this.totalDuration,
      lessonCounterStarts: lessonCounterStarts ?? this.lessonCounterStarts,
      lessonCounterEnds: lessonCounterEnds ?? this.lessonCounterEnds,
      numberOfCompletedLessons:
          numberOfCompletedLessons ?? this.numberOfCompletedLessons,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'lessons':
          mLesson.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
      'total_duration': totalDuration,
      'lesson_counter_starts': lessonCounterStarts,
      'lesson_counter_ends': lessonCounterEnds,
      'completed_lesson_number': numberOfCompletedLessons,
    };
  }

  factory Section.fromJson(Map<String, Object?> json) {
    return Section(
      id: json['id'] == null ? "" : json['id'] as String,
      title: json['title'] == null ? "" : json['title'] as String,
      mLesson: json['lessons'] == null
          ? []
          : (json['lessons'] as List)
              .map<Lesson>(
                (data) => Lesson.fromJson(data as Map<String, Object?>),
              )
              .toList(),
      totalDuration: json['total_duration'] == null
          ? ""
          : json['total_duration'] as String,
      lessonCounterStarts: json['lesson_counter_starts'] == null
          ? 0
          : json['lesson_counter_starts'] as int,
      lessonCounterEnds: json['lesson_counter_ends'] == null
          ? 0
          : json['lesson_counter_ends'] as int,
      numberOfCompletedLessons: json['completed_lesson_number'] == null
          ? 0
          : json['completed_lesson_number'] as int,
    );
  }

  @override
  String toString() {
    return '''Section(
                id:$id,
title:$title,
courseId:courseId,
order:order,
lessons:${mLesson.toString()},
totalDuration:$totalDuration,
lessonCounterStarts:$lessonCounterStarts,
lessonCounterEnds:$lessonCounterEnds,
completedLessonNumber:$numberOfCompletedLessons,
userValidity:userValidity
    ) ''';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        mLesson,
        totalDuration,
        lessonCounterStarts,
        lessonCounterEnds,
        numberOfCompletedLessons,
      ];
}
