// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';

import 'package:three_m_physics/models/common_functions.dart';
import 'package:three_m_physics/models/course.dart';
import 'package:three_m_physics/models/course_detail.dart';
import 'package:three_m_physics/providers/shared_pref_helper.dart';
import 'package:three_m_physics/widgets/custom_text.dart';
import 'package:three_m_physics/widgets/lesson_list_item.dart';
import 'package:three_m_physics/widgets/star_display_widget.dart';
import 'package:three_m_physics/widgets/tab_view_details.dart';
import 'package:three_m_physics/widgets/util.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:share/share.dart';
import '../constants.dart';
import '../widgets/app_bar_two.dart';
import '../providers/courses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/from_network.dart';
import '../widgets/from_vimeo_id.dart';
import '../widgets/from_youtube.dart';
import 'package:http/http.dart' as http;

import 'my_course_detail_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  static const routeName = '/course-details';
  const CourseDetailScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController purchaseCtrl = TextEditingController();
  bool _isInit = true;
  bool _isAuth = false;
  bool _isLoading = false;
  String? _authToken;
  CourseDetail? loadedCourseDetail;
  Course? loadedCourse;
  late int courseId;
  int? selected;

  @override
  void didChangeDependencies() async 
  {
    courseId = int.parse(ModalRoute.of(context)!.settings.arguments.toString());
    if (_isInit) {
      var token = await SharedPreferenceHelper().getAuthToken();
      setState(() {
        _isLoading = true;
        // _authToken = Provider.of<Auth>(context, listen: false).token;
        if (token != null && token.isNotEmpty) {
          _isAuth = true;
        } else {
          _isAuth = false;
        }
      });

      loadedCourse =
          Provider.of<Courses>(context, listen: false).findById(courseId);

      Provider.of<Courses>(context, listen: false)
          .fetchCourseDetailById(courseId)
          .then((v) {
        if (v != null) {
          loadedCourseDetail = v;
          if(v.isPurchased)
          {
            
              Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return MyCourseDetailScreen(
                                              courseId: courseId,
                                              len: 1,
                                              enableDripContent: "0",
                                            );
                                          },
                                        ),
                                      );
            // Navigator.pushReplacement(context, newRoute);
          }
        }
        // loadedCourseDetail =
        //     Provider.of<Courses>(context, listen: false).getCourseDetail;
        // ignore: unused_local_variable
        // loadedCourse =
        //     Provider.of<Courses>(context, listen: false).findById(courseId);
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  /* void _launchURL(String url) async => await canLaunch(url)
      ? await launch(url, forceSafariVC: false)
      : throw 'Could not launch $url';
 */
  Future<Course?> purchaseCourse({
    required int courseId,
    required String couponCode,
  }) async {
    if (couponCode == "") return null;
    Get.back();
    final authToken = await SharedPreferenceHelper().getAuthToken();
    final activeLink = BASE_URL.contains("nata3lm.com")
        ? "activate_course_via_whatsapp"
        : "activate_course_via_purchase_code";

    var url = '$BASE_URL/api/$activeLink?auth_token=$authToken';
    // debugPrint("couponCode >>>>> $couponCode \n course_id: $courseId \n$url");
    try {
      final response = await http.post(Uri.parse(url), body: {
        "course_id": "$courseId",
        "code": couponCode,
      });
      final responseData = json.decode(response.body);
      // debugPrint("responseData  >>>>> $responseData");
      if (!responseData.containsKey("course")) {
        Get.snackbar(
          "Error",
          "${responseData['msg']}",
          backgroundColor: Colors.red.shade100,
        );
        return null;
      } else {
        Get.snackbar(
          "Success",
          "${responseData['msg']}",
          backgroundColor: kGreenColor,
        );
        Provider.of<Courses>(context, listen: false)
            .fetchCourseDetailById(courseId)
            .then((v) {
          if (v != null) {
            loadedCourseDetail = v;
          }
        });
        Course course = Course.fromJson(responseData["course"]);
        return course;
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarTwo(),
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: kPrimaryColor.withOpacity(0.7),
              ),
            )
          : Consumer<Courses>(
              builder: (context, courses, child) {
                // final loadedCourseDetail = courses.getCourseDetail;
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Stack(
                          fit: StackFit.loose,
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: 
                          [
                            InkWell(
                              onTap: (){
                                        if (loadedCourse?.courseOverviewProvider ==
                                      'vimeo') {
                                    String vimeoVideoId = loadedCourse!
                                        .courseOverviewUrl
                                        .split('/')
                                        .last;
                                    // _showVimeoModal(context, vimeoVideoId);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PlayVideoFromVimeoId(
                                          courseId: loadedCourse!.id,
                                          vimeoVideoId: vimeoVideoId,
                                        ),
                                      ),
                                    );
                                  } else if (loadedCourse
                                          ?.courseOverviewProvider ==
                                      'html5') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PlayVideoFromNetwork(
                                          courseId: loadedCourse!.id,
                                          videoUrl:
                                              loadedCourse!.courseOverviewUrl,
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (loadedCourse?.courseOverviewProvider ==
                                        "") {
                                      CommonFunctions.showSuccessToast(
                                          'Video url not provided');
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PlayVideoFromYoutube(
                                            courseId: loadedCourse!.id,
                                            videoUrl: loadedCourse
                                                    ?.courseOverviewUrl ??
                                                "",
                                          ),
                                        ),
                                      );
                                    }
                                  }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height / 3.3,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.6),
                                        BlendMode.dstATop,
                                      ),
                                      image: NetworkImage(
                                        loadedCourse?.thumbnail ?? "",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                           
                            // ClipOval(
                            //   child: InkWell(
                            //     onTap: () 
                            //     {
                          
                            //     },
                            //     child: Container(
                            //       width: 45,
                            //       height: 45,
                            //       decoration: 
                            //       const BoxDecoration(
                            //         color: Colors.white,
                            //         boxShadow: 
                            //           [
                            //             kDefaultShadow
                            //           ],
                            //       ),

                            //       child: Padding(
                            //         padding: const EdgeInsets.all(5.0),
                            //         child: Image.asset(
                            //           'assets/images/play.png',
                            //           fit: BoxFit.contain,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          
                          
                          
                            Positioned(
                              bottom: -15,
                              right: 20,
                              child: SizedBox(
                                height: 45,
                                width: 45,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      debugPrint(
                                        courses.isWishlisted.toString(),
                                      );
                                      if (_isAuth) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              buildPopupDialogWishList(
                                            context,
                                            courses.isWishlisted,
                                            // loadedCourseDetail?.isWishlisted,
                                            loadedCourse?.id,
                                          ),
                                        );
                                      } else {
                                        CommonFunctions.showSuccessToast(
                                            'Please login first');
                                      }
                                    },
                                    tooltip: 'Wishlist',
                                    backgroundColor: kPrimaryColor,
                                    child: Icon(
                                      courses.isWishlisted == true
                                          // loadedCourseDetail?.isWishlisted == true
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: loadedCourse?.title,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ),
                            const Expanded(flex: 1, child: Text('')),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 10,
                              ),
                              child: StarDisplayWidget(
                                value: loadedCourse?.rating ?? 0,
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                '( ${loadedCourse?.rating}.0 )',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: kTextColor,
                                ),
                              ),
                            ),
                            CustomText(
                              text:
                                  '${loadedCourse?.totalNumberRating}+ تقيم الكورس',
                              fontSize: 11,
                              colors: kTextColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            right: 15, left: 15, top: 0, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: CustomText(
                                text: loadedCourse?.price.toString(),
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                colors: kTextColor,
                              ),
                            ),
                            // IconButton(
                            //   icon: const Icon(
                            //     Icons.share,
                            //     color: kSecondaryColor,
                            //   ),
                            //   tooltip: 'Share',
                            //   onPressed: () {
                            //     Share.share(
                            //       loadedCourse!.shareableLink.toString(),
                            //     );
                            //   },
                            // ),
                            /* if (BASE_URL == "https://nata3lm.com")
                            const IstractorePhone(), */
                            Column(
                              children: [
                            //      courses.isLoading? const Center(child: CircularProgressIndicator.adaptive(),): MaterialButton(
                            //   onPressed: () async
                            //   {
                            //     courses.getInestractorPhone(courseId, context);
                            //   },
                            //   color: Colors.green,
                            //   textColor: Colors.white,
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 20, vertical: 10),
                            //   splashColor: Colors.blueAccent,
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(7.0),
                            //     // side: BorderSide(color: kBlueColor),
                            //   ),
                            //   child: const  Text(
                            //     "Buy on Whats App",
                            //     style: const TextStyle(
                            //         fontWeight: FontWeight.w400, fontSize: 16),
                            //   ),
                            // ),
                                MaterialButton(
                                  onPressed: () async {
                                    _authToken = await SharedPreferenceHelper()
                                        .getAuthToken();
                                    if (loadedCourseDetail?.isPurchased == false) 
                                    {
                                      if (_authToken != null) {
                                        if (loadedCourse?.isFreeCourse == '1') 
                                        {
                                          // final _url = BASE_URL + '/api/enroll_free_course?course_id=$courseId&auth_token=$_authToken';
                                          Provider.of<Courses>(context,
                                                  listen: false)
                                              .getEnrolled(courseId)
                                              .then(
                                                (_) => 
                                                CommonFunctions
                                                    .showSuccessToast(
                                                  'Enrolled Successfully',
                                                ),
                                              );
                                        } else {
                                          setState(() {
                                            purchaseCtrl.text = "";
                                          });
                                          Get.dialog(
                                            Dialog(
                                              backgroundColor:
                                                  Theme.of(context).cardColor,
                                              child: Container(
                                                height: 250,
                                                padding: const 
                                                        EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color:
                                                      Theme.of(context).cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const 
                                                    Text(
                                                      "ضع رمز الشراء الخاص بك",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20,),

                                                    TextFormField(
                                                      controller: purchaseCtrl,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration: InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 4,
                                                                horizontal: 10),
                                                        hintText: "اكتب الكود",
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15),
                                                          borderSide: BorderSide(
                                                            color: Theme.of(context)
                                                                .primaryColor,
                                                            width: .75,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15),
                                                          borderSide: BorderSide(
                                                            color: Theme.of(context)
                                                                .primaryColor, //widget.borderColor,
                                                            width: .75,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    MaterialButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _isLoading = true;
                                                        });
                                                        purchaseCourse(
                                                          courseId: courseId,
                                                          couponCode:
                                                              //  "45028610748"
                                                              // "35083437523"
                                                              // "48249807794"
                                                              // "45028610748"
                                                              // "87256812974"
                                                              // "35083437523"
                                                              purchaseCtrl.text
                                                                  .trim(),
                                                        ).then((value) {
                                                          if (value != null) {
                                                            loadedCourse = value;
                                                          }
                                                          setState(() {
                                                            _isLoading = false;
                                                          });
                                                        });
                                                      },
                                                      color: kPrimaryColor,
                                                      textColor: Colors.white,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 10),
                                                      splashColor:
                                                          Colors.blueAccent,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                7.0),
                                                        // side: BorderSide(color: kBlueColor),
                                                      ),
                                                      child: const Text(
                                                        "يشتري",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                /*                                       final url =
                                              '$BASE_URL/api/web_redirect_to_buy_course/$_authToken/$courseId/academybycreativeitem';
                                          _launchURL(url);
                                 */
                                        }
                                      } else {
                                        CommonFunctions.showSuccessToast(
                                          'Please login first',
                                        );
                                      }
                                    } else {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return MyCourseDetailScreen(
                                              courseId: courseId,
                                              len: 1,
                                              enableDripContent: "1",
                                            );
                                          },
                                        ),
                                      );
                                      /* Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MyCoursesScreen(
                                            setSafeArya: true,
                                          ),
                                        ),
                                      ); */
                                    }
                                  },
                                  color: loadedCourseDetail?.isPurchased == true
                                      ? kGreenPurchaseColor
                                      : kPrimaryColor,
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  splashColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    // side: BorderSide(color: kBlueColor),
                                  ),
                                  child: Text(
                                    loadedCourseDetail?.isPurchased == true
                                        ? 'ابدا الان'
                                        : loadedCourse?.isFreeCourse == '1'
                                            ? 'حصول علي الكورس'
                                            : 'أشتري الان',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 10),
                            //   child: Card(
                            //     elevation: 0,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //     child: Column(
                            //       children: [
                            //         SizedBox(
                            //           width: double.infinity,
                            //           child: TabBar(
                            //             controller: _tabController,
                            //             indicatorSize: TabBarIndicatorSize.tab,
                            //             indicator: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(10),
                            //                 color: kPrimaryColor),
                            //             unselectedLabelColor: kTextColor,
                            //             padding: const EdgeInsets.all(10),
                            //             labelColor: Colors.white,
                            //             tabs: const <Widget>[
                            //               Tab(
                            //                 child: Text(
                            //                   "Includes",
                            //                   style: TextStyle(
                            //                     fontWeight: FontWeight.bold,
                            //                     fontSize: 11,
                            //                   ),
                            //                 ),
                            //               ),
                            //               Tab(
                            //                 child: Align(
                            //                   alignment: Alignment.center,
                            //                   child: Text(
                            //                     "Outcomes",
                            //                     style: TextStyle(
                            //                       fontWeight: FontWeight.bold,
                            //                       fontSize: 11,
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //               Tab(
                            //                 child: Align(
                            //                   alignment: Alignment.center,
                            //                   child: Text(
                            //                     "Requirements",
                            //                     style: TextStyle(
                            //                       fontWeight: FontWeight.bold,
                            //                       fontSize: 10,
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         Container(
                            //           width: double.infinity,
                            //           height: 300,
                            //           padding: const EdgeInsets.only(
                            //               right: 10,
                            //               left: 10,
                            //               top: 0,
                            //               bottom: 10),
                            //           child: TabBarView(
                            //             controller: _tabController,
                            //             children: [
                            //               TabViewDetails(
                            //                 titleText: 'What is Included',
                            //                 listText: loadedCourseDetail
                            //                         ?.courseIncludes ??
                            //                     [],
                            //               ),
                            //               TabViewDetails(
                            //                 titleText: 'What you will learn',
                            //                 listText: loadedCourseDetail
                            //                         ?.courseOutcomes ??
                            //                     [],
                            //               ),
                            //               TabViewDetails(
                            //                 titleText: 'Course Requirements',
                            //                 listText: loadedCourseDetail
                            //                         ?.courseRequirements ??
                            //                     [],
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            if (loadedCourseDetail != null) ...[
                              if (loadedCourseDetail!.mSection.isNotEmpty) ...[
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10),
                                  child: CustomText(
                                    text: 'المنهج الدراسي الكورس',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    colors: kDarkGreyColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: ListView.builder(
                                    key: Key(
                                        'builder ${selected.toString()}'), //attention
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        loadedCourseDetail?.mSection.length,
                                    itemBuilder: (ctx, index) {
                                      final section =
                                          loadedCourseDetail?.mSection[index];
                                      return Card(
                                        elevation: 0.3,
                                        child: ExpansionTile(
                                          key:
                                              Key(index.toString()), //attention
                                          initiallyExpanded: index == selected,
                                          onExpansionChanged: ((newState) {
                                            if (newState) {
                                              setState(() {
                                                selected = index;
                                              });
                                            } else {
                                              setState(() {
                                                selected = -1;
                                              });
                                            }
                                          }), //attention
                                          title: 
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (section != null) ...[
                                                Align(
                                                
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 5.0,
                                                    ),
                                                    child: CustomText(
                                                      text: HtmlUnescape()
                                                          .convert(
                                                        section.title
                                                            .toString(),
                                                      ),
                                                      colors: kDarkGreyColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kTimeBackColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 5.0,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: CustomText(
                                                            text: section
                                                                ?.totalDuration,
                                                            fontSize: 10,
                                                            colors: kTimeColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              kLessonBackColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 5.0,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  kLessonBackColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3),
                                                            ),
                                                            child: CustomText(
                                                              text:
                                                                  '${section?.mLesson.length} حصص',
                                                              fontSize: 10,
                                                              colors:
                                                                  kDarkGreyColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Expanded(
                                                      flex: 2,
                                                      child: Text(""),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          children: [
                                            if (section != null) ...[
                                              if (section
                                                  .mLesson.isNotEmpty) ...[
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (ctx, index) {
                                                    return LessonListItem(
                                                      lesson: section
                                                          .mLesson[index],
                                                      courseId: int.parse(
                                                          loadedCourseDetail!
                                                              .courseId),
                                                    );
                                                  },
                                                  itemCount:
                                                      section.mLesson.length,
                                                ),
                                              ]
                                            ]
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ]
                            ]
                          ],
                        ),
                     
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class IstractorePhone extends StatefulWidget {
  const IstractorePhone({super.key});

  @override
  State<IstractorePhone> createState() => _IstractorePhoneState();
}

class _IstractorePhoneState extends State<IstractorePhone> {
  @override
  void initState() {
    super.initState();
  }

  getInsrPhone() {}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: () {},
        child: Image.asset(
          'assets/images/whatsapp.png',
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
      ),
      /*  FadeInImage.assetNetwork(
        placeholder: 'assets/images/whatsapp.gif',
        image: 'null',
        fadeInCurve: Curves.fastOutSlowIn,
        height: 70,
        width: 70,
        fit: BoxFit.cover,
      ), */
    );
  }
}
