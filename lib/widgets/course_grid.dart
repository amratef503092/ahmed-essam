import 'package:three_m_physics/models/course.dart';
import 'package:three_m_physics/widgets/custom_text.dart';

import '../screens/course_detail_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/star_display_widget.dart';

class CourseGrid extends StatelessWidget {
  final Course? course;

  const CourseGrid({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CourseDetailScreen.routeName, arguments: course?.id);
      },
      child: SizedBox(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/loading_animated.gif',
                          image: course!.thumbnail.toString(),
                          height: 130,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 5, right: 8, left: 8, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        child: Text(
                          course!.title.toString().length < 41
                              ? course!.title.toString()
                              : '${course?.title.toString().substring(0, 40)}...',
                          style: const TextStyle(
                              fontSize: 14, color: kTextLightColor),
                        ),
                      ),
                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(
                                course!.instructorImage.toString()),
                            backgroundColor: kLightBlueColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: CustomText(
                              text: course?.instructor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          StarDisplayWidget(
                            value: course!.rating,
                            filledStar: const Icon(
                              Icons.star,
                              color: kStarColor,
                              size: 18,
                            ),
                            unfilledStar: const Icon(
                              Icons.star_border,
                              color: kStarColor,
                              size: 18,
                            ),
                          ),
                          Text(
                            course!.price,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: kTextLightColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
