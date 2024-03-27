import 'package:three_m_physics/models/category.dart';
import 'package:three_m_physics/models/course.dart';
import 'package:three_m_physics/screens/courses_screen.dart';
import 'package:three_m_physics/screens/sub_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import '../constants.dart';
import 'course_grid.dart';
import 'random_calss.dart';

class SubCategoryListItem extends StatelessWidget {
  final CategoryPlatformData? catData;
  final int? index;

  const SubCategoryListItem({
    super.key,
    required this.catData,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (catData?.numberOfSubCategories != 0) {
          Get.offNamed(SubCategoryScreen.routeName, parameters: {
            'category_id': catData!.id.toString(),
            'title': catData!.title.toString(),
          });
          // debugPrint("<<<<<<<<<<fetch Sub Categories>>>>>>>>>>");
          // SubController.to.fetchSubCategories(catData!.id.toString());
        } else if (catData?.numberOfCourses != 0) {
          Navigator.of(context).pushNamed(
            CoursesScreen.routeName,
            arguments: {
              'category_id': int.parse(catData!.id.toString()),
              'seacrh_query': null,
              'type': CoursesPageData.Category,
            },
          );
        }
      },
      child: Card(
        // color: RandomClass.randomColor,
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only( bottom: 15),
                child: Text(
                  "${index! + 1}.",
                  style: const  TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                    // color: RandomClass.randomTextColor(RandomClass.randomColor),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Align(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        HtmlUnescape().convert(catData?.title ?? ""),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kToastTextColor
                          // color: RandomClass.randomTextColor(
                          //   RandomClass.randomColor,
                          // ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${catData?.numberOfSubCategories ?? 0} الكورسات الفرعية',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${catData?.numberOfCourses ?? 0} الكورسات',
                        style:
                            const TextStyle(
                              color:    kToastTextColor
                            
                              // color: 
                              // RandomClass.randomSubtitleColor
                              ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ],
              ),
             const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: iCardColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 2),
                    child: ImageIcon(
                      const AssetImage("assets/images/long_arrow_right.png"),
                      color: kPrimaryColor.withOpacity(0.7),
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/* 
class MyCustomWidget extends StatelessWidget {
  const MyCustomWidget({super.key, this.catData, this.index});
  
  final CategoryPlatformData? catData;
  final int? index;
  @override
  Widget build(BuildContext context) {
    return FlutterSlimyCard(
      topCardHeight: 160,
      bottomCardHeight: 120,
      topCardWidget: SubCategoryListItem(catData: catData, index: index),
      bottomCardWidget: bottomCardWidget(),
    );
  }

  // This widget will be passed as Top Card's Widget.
  Widget topCardWidget() {
    return Text(
      'customize as you wish.',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(.85),
      ),
    );
  }

  // This widget will be passed as Bottom Card's Widget.
  Widget bottomCardWidget() {
    return Text(
      'customize as you wish.',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(.85),
      ),
    );
  }
}
 */

class MyCustomWidget extends StatefulWidget {
  const MyCustomWidget(
      {super.key, this.catData, this.index, required this.courses});

  final CategoryPlatformData? catData;
  final List<Course> courses;
  final int? index;

  @override
  MyCustomWidgetState createState() => MyCustomWidgetState();
}

class MyCustomWidgetState extends State<MyCustomWidget> {
  bool isTapped = true;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubCategoryListItem(catData: widget.catData, index: widget.index),
        if (widget.courses.isNotEmpty)
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn,
            height: widget.courses.isEmpty ? 0 : 260,
            // width: isExpanded ? 385 : 390,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            // padding: const EdgeInsets.all(10),
            child: HorizontalListBuilder(
              itemBuilder: (ctx, index) {
                return CourseGrid(course: widget.courses[index]);
              },
              itemCount: widget.courses.length,
            ),
          )
      ],
    );
  }
}

class HorizontalListBuilder extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing, runSpacing;
  final EdgeInsetsDirectional padding;
  final ScrollPhysics? physics;
  final bool reverse;
  final ScrollController? controller;
  final Axis scrollType;
  final List<Widget>? list;

  final WrapAlignment wrapAlignment;
  final WrapCrossAlignment crossAxisAlignment;

  const HorizontalListBuilder({
    required this.itemCount,
    required this.itemBuilder,
    this.scrollType = Axis.horizontal,
    this.spacing = 8,
    this.runSpacing = 8,
    this.padding = const EdgeInsetsDirectional.all(0),
    this.physics,
    this.controller,
    this.reverse = false,
    this.wrapAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    super.key,
    this.list,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      padding: padding,
      scrollDirection: scrollType,
      reverse: reverse,
      controller: controller,
      child: Wrap(
        spacing: spacing,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        direction: scrollType,
        runAlignment: wrapAlignment,
        crossAxisAlignment: crossAxisAlignment,
        runSpacing: runSpacing,
        children: list ??
            List.generate(
              itemCount,
              (index) => itemBuilder(context, index),
            ),
      ),
    );
  }
}
