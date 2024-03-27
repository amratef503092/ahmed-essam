import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:three_m_physics/providers/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../models/lesson.dart';
import '../pod_player_custom/pod_player.dart';
import '../providers/my_courses.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PlayVideoFromYoutube extends StatefulWidget {
  static const routeName = '/fromVimeoId';
  final String courseId;
  final String? lessonId;
  final String videoUrl;
  final Lesson? lesson;
  const PlayVideoFromYoutube({
    super.key,
    required this.courseId,
    this.lessonId,
    required this.videoUrl,
    this.lesson,
  });

  @override
  State<PlayVideoFromYoutube> createState() => _PlayVideoFromVimeoIdState();
}

class _PlayVideoFromVimeoIdState extends State<PlayVideoFromYoutube> {
  late final PodPlayerController controller;
  final videoTextFieldCtr = TextEditingController();

  Timer? timer;

  String? phoneNumberUser;
  @override
  void initState() {
    numberDisplay();
    // debugPrint("From Youtube videoUrl  is ${widget.videoUrl}");
    String url = widget.videoUrl;
    bool isYout = true;

    if (!(widget.videoUrl.contains("//youtu") ||
        widget.videoUrl.startsWith("https://www.youtube.com"))) {
      final RegExp regExp = RegExp(r'[-\w]{25,}');
      final Match? match = regExp.firstMatch(widget.videoUrl.toString());

      setState(() {
        url =
            'https://drive.google.com/uc?export=download&id=${match?.group(0)}';
        isYout = false;
      });
    }
    // debugPrint("From Youtube videoUrl  >> URL :$url \n IsYout :$isYout");
    controller = PodPlayerController(
      playVideoFrom:
          isYout ? PlayVideoFrom.youtube(url) : PlayVideoFrom.network(url),
      // podPlayerConfig: const PodPlayerConfig(
      //   videoQualityPriority: [720, 360],
      //   autoPlay: false,
      // ),
    )..initialise();
    super.initState();

    if (widget.lessonId != null) {
      timer = Timer.periodic(
          const Duration(seconds: 5), (Timer t) => updateWatchHistory());
    }
    getUserPhoneNumber();
  }

  void getUserPhoneNumber() async {
    phoneNumberUser = await SharedPreferenceHelper().getPhoneNumber();
  }

  Future<void> updateWatchHistory() async {
    if (controller.isVideoPlaying) {
      var token = await SharedPreferenceHelper().getAuthToken();
      dynamic url;
      if (token != null && token.isNotEmpty) {
        url = "$BASE_URL/api/update_watch_history/$token";
        // print(url);
        // print(controller.currentVideoPosition.inSeconds);
        try {
          final response = await http.post(
            Uri.parse(url),
            body: {
              'course_id': widget.courseId.toString(),
              'lesson_id': widget.lessonId.toString(),
              'current_duration':
                  controller.currentVideoPosition.inSeconds.toString(),
            },
          );

          final responseData = json.decode(response.body);
          // print(responseData);
          if (responseData == null) {
            return;
          } else {
            var isCompleted = responseData['is_completed'];
            if (isCompleted == 1) {
              // ignore: use_build_context_synchronously
              Provider.of<MyCourses>(context, listen: false)
                  .updateDripContendLesson(
                      int.parse(widget.courseId),
                      responseData['course_progress'],
                      responseData['number_of_completed_lessons']);
            }
          }
        } catch (error) {
          // print(error.toString());
          rethrow;
        }
      } else {
        return;
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    if (widget.lessonId != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  bool display = true;
  void numberDisplay() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      print(display);
      setState(() {
        display = !display;
        random();
      });
    });
  }

  int randomTop = Random().nextInt(100);
  int randomLeft = Random().nextInt(100);
  int randomRight = Random().nextInt(100);
  int randomBottom = Random().nextInt(100);
  bool randomPosition = false;
  bool randomPosition2 = true;
  void random() {
    randomTop = Random().nextInt(100);
    randomLeft = Random().nextInt(100);
    randomRight = Random().nextInt(100);
    randomBottom = Random().nextInt(100);
    randomPosition = Random().nextBool();
    randomPosition2 = Random().nextBool();
    print(randomPosition);
    print(randomPosition2);
  }

  bool showController = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                PodVideoPlayer(
                  // overlayBuilder: ( OverLayOptionsoptions)
                  // {

                  // },

                  controller: controller,
                  onToggleFullScreen: (isFullScreen) async {
                    if (isFullScreen) {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.landscapeLeft]);
                      return Future.value(true);
                    } else {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                      return Future.value(true);
                    }
                  },
                ),
                display
                    ? randomPosition
                        ? Positioned(
                            top: randomTop.toDouble(),
                            left: randomLeft.toDouble(),
                            child: Text(
                              phoneNumberUser ?? "",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : randomPosition2
                            ? Positioned(
                                top: randomTop.toDouble(),
                                right: randomRight.toDouble(),
                                child: Text(
                                  phoneNumberUser ?? "",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : randomPosition
                                ? Positioned(
                                    bottom: randomBottom.toDouble(),
                                    right: randomRight.toDouble(),
                                    child: Text(
                                      phoneNumberUser ?? "",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Positioned(
                                    bottom: randomBottom.toDouble(),
                                    left: randomRight.toDouble(),
                                    child: Text(
                                      phoneNumberUser ?? "",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                    : const SizedBox.shrink()
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            widget.lesson != null
                ? Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.lesson!.title!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "المهندس أحمد عصام",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "الوصف",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        HtmlWidget(
                          widget.lesson!.summary,
                          onTapUrl: (p0) async {
                            if (!await launchUrl(Uri.parse(p0),
                                mode: LaunchMode.externalApplication)) {
                              throw Exception('Could not launch $p0');
                            }
                            print('tapped $p0');

                            return true;
                          },
                          textStyle: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
