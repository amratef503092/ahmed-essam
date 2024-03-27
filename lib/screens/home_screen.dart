// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:three_m_physics/models/all_platform_categpry.dart';
import 'package:three_m_physics/models/bundle.dart';
import 'package:three_m_physics/models/course.dart';
import 'package:three_m_physics/providers/bundles.dart';
import 'package:three_m_physics/widgets/bundle_grid.dart';
import '../widgets/category_list_item.dart';
import '../widgets/course_grid.dart';
import '../providers/courses.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'bundle_list_screen.dart';
import 'courses_screen.dart';
import '../models/common_functions.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  bool bundleStatus = false;
  List<Course> topCourses = [];
  List<Bundle> bundles = [];

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    addonStatus();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<void> addonStatus() async {
    var url = '$BASE_URL/api/addon_status?unique_identifier=course_bundle';
    final response = await http.get(Uri.parse(url));
    setState(() {
      bundleStatus = json.decode(response.body)['status'];
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Courses>(context).fetchTopCourses().then((_) {
        setState(() {
          _isLoading = false;
          topCourses = Provider.of<Courses>(context, listen: false).topItems;
        });
      });
      Provider.of<Courses>(context).filterCourses(selectedLanguage: "all" , selectedLevel: "all" , selectedCategory: "all" ,  selectedPrice: "all" , selectedRating: "all" ,);
      Provider.of<Bundles>(context).fetchBundle(true).then((_) {
        setState(() {
          bundles = Provider.of<Bundles>(context, listen: false).bundleItems;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> refreshList() async {
    try {
      setState(() {
        _isLoading = true;
      });
      // fetchCategories();
      await Provider.of<Courses>(context, listen: false).fetchTopCourses();

      setState(() {
        _isLoading = false;
        topCourses = Provider.of<Courses>(context, listen: false).topItems;
      });
    } catch (error) {
      const errorMsg = 'Could not refresh!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }

    return;
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

/*   List<CategoryPlatformData> _items = [];
  Future<void> fetchCategories() async {
    setState(() {
      _items = [];
    });
    var url = '$BASE_URL/api/categories';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        debugPrint("extractedData == null");
        return;
      }
      // print(extractedData);
      final List<CategoryPlatformData> loadedCategories = (extractedData)
          .map<CategoryPlatformData>((data) =>
              CategoryPlatformData.fromJson(data as Map<String, Object?>))
          .toList();
      debugPrint("loadedCategories.length ${loadedCategories.length}");
      debugPrint("item.length <<1>> ${_items.length}");
      setState(() {
        _items = loadedCategories;
      });
      debugPrint("item.length <<2>> ${_items.length}");
    } catch (error) {
      rethrow;
    }
  }
 */
  Widget view() {
    if (_connectionStatus == ConnectivityResult.none) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .15),
            Image.asset(
              "assets/images/no_connection.png",
              height: MediaQuery.of(context).size.height * .35,
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text('There is no Internet connection'),
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text('Please check your Internet connection'),
            ),
          ],
        ),
      );
    } else {
      if (_isLoading) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: Center(
              child: CircularProgressIndicator.adaptive(
            backgroundColor: kPrimaryColor.withOpacity(0.7),
          )),
        );
      } else {
        /* if (dataSnapshot.error != null) {
                //error
                return _connectionStatus == ConnectivityResult.none
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .15),
                            Image.asset(
                              "assets/images/no_connection.png",
                              height: MediaQuery.of(context).size.height * .35,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('There is no Internet connection'),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child:
                                  Text('Please check your Internet connection'),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        // child: Text('Error Occured'),
                        child: Text(dataSnapshot.error.toString()),
                      );
              } else  */
        {
          return Column(
            children: [
              if (topCourses.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'الكورسات المميزة',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            CoursesScreen.routeName,
                            arguments: {
                              'category_id': null,
                              'seacrh_query': null,
                              'type': CoursesPageData.All,
                            },
                          );
                        },
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          children: [
                            const Text('جميع الكورسات'),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: kPrimaryColor.withOpacity(0.7),
                              size: 18,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: kPrimaryColor.withOpacity(0.7),
                      ),
                    )
                  : topCourses.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.symmetric(vertical: 0.0),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 258.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) {
                              return CourseGrid(course: topCourses[index]);
                            },
                            itemCount: topCourses.length,
                          ),
                        )
                      : const SizedBox.shrink(),
              if (bundleStatus == true)
                Column(
                  children: [
                    if (bundles.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'حزم',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  BundleListScreen.routeName,
                                );
                              },
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                children: [
                                  const Text('جميع الحزم'),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: kPrimaryColor.withOpacity(0.7),
                                    size: 18,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    bundles.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 0.0),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: 240.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) {
                                return BundleGrid(
                                  id: bundles[index].id,
                                  title: bundles[index].title,
                                  banner:
                                      // ignore: prefer_interpolation_to_compose_strings
                                      '$BASE_URL/uploads/course_bundle/banner/' +
                                          (bundles[index].banner ?? ""),
                                  averageRating: bundles[index].averageRating,
                                  numberOfRatings:
                                      bundles[index].numberOfRatings,
                                  price: bundles[index].price,
                                );
                              },
                              itemCount: bundles.length,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'فئات الكورسات',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          CoursesScreen.routeName,
                          arguments: {
                            'category_id': null,
                            'seacrh_query': null,
                            'type': CoursesPageData.All,
                          },
                        );
                      },
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: [
                          const Text('جميع الكورسات'),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: kPrimaryColor.withOpacity(0.7),
                            size: 18,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const AllCategoryWidget(),
            ],
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshList,
      child: SingleChildScrollView(
        child: view(),
      ),
    );
  }
}

class AllCategoryWidget extends StatefulWidget {
  const AllCategoryWidget({super.key});

  @override
  State<AllCategoryWidget> createState() => _AllCategoryWidgetState();
}

class _AllCategoryWidgetState extends State<AllCategoryWidget> {
  bool loading = true;
  List<SubCategories> allCategories = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    fetchAllCategories().then((value) {
      setState(() {
        allCategories = value;
        loading = false;
      });
    });
  }

  Future<List<SubCategories>> fetchAllCategories() async {
    var url = '$BASE_URL/api/all_categories';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return [];
      }
      final List<SubCategories> loadedCategories =
          AllCategoriesPlatformModel.fromJson(extractedData).allCategories;

      return loadedCategories;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: loading
          ? SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: kPrimaryColor.withOpacity(0.7),
                ),
              ),
            )
          : allCategories.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return CategoryListItem(
                      parent:
                          int.parse(allCategories[index].category?.id ?? "0"),
                      title: allCategories[index].category?.title,
                      thumbnail: allCategories[index].category?.thumbnail,
                      numberOfSubCategories:
                          allCategories[index].subCategories.length,
                    );
                  },
                  itemCount: allCategories.length,
                ),
    );
  }
}
