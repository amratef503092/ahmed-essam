class SubCategory {
  final int? id, parent, numberOfCourses;
  final String? title;

  SubCategory({
    required this.id,
    required this.title,
    required this.parent,
    required this.numberOfCourses,
  });
}
