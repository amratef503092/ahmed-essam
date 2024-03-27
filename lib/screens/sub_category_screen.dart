import 'dart:async';
import 'package:three_m_physics/constants.dart';
import 'package:three_m_physics/models/all_platform_categpry.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart' hide MultipartFile, FormData, Response;
import 'package:three_m_physics/widgets/sub_category_list_item.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubCategoryScreen extends StatefulWidget {
  static const routeName = '/sub-cat';
  const SubCategoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    /* fetchSubCategories(categoryId).then((value) {
      setState(() {
        _isLoading = false;
      });
    }); */
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

  bool isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    /* setState(() {
      isLoading = true;
    });

    final routeArgs = Get.parameters;
    if (routeArgs.isNotEmpty) {
      SubController.to.categoryId =
          int.parse(routeArgs['category_id'].toString());
      SubController.to.title = routeArgs['title'].toString();
      // debugPrint(
      //     "categoryId  => ${SubController.to.categoryId} \n Title => ${SubController.to.title}");
    }
    // debugPrint("000000000000");
    SubController.to.fetchSubCategories().then((value) => setState(() {
          isLoading = false;
        })); */
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubController>(
      builder: (c) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(Get.parameters['title'] ?? "", maxLines: 2),
            titleTextStyle: const TextStyle(color: Colors.black, fontSize: 15),
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          backgroundColor: kBackgroundColor,
          body: SingleChildScrollView(child: view(c)),
        );
      },
    );
  }

  Widget view(SubController c) => switch (_connectionStatus) {
        ConnectivityResult.none => const NoInternetStateView(),
        _ => switch (c.isLoading || isLoading) {
            true => const LoadingStateView(),
            false => switch (c.subItems) {
                [] => const SizedBox.shrink(),
                _ => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'شاهد ${c.subItems.length} كورسات الفرعية',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (c.subItems.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: c.subItems.length,
                            itemBuilder: (ctx, i) {
                              return c.subItems[i].category == null
                                  ? const SizedBox.shrink()
                                  : MyCustomWidget(
                                      catData: c.subItems[i].category,
                                      index: i,
                                      courses: c.subItems[i].courses,
                                    );
                            },
                          ),
                      ],
                    ),
                  ),
              },
          },
      };
}

class LoadingStateView extends StatelessWidget {
  const LoadingStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .5,
      child: Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: kPrimaryColor.withOpacity(0.7),
        ),
      ),
    );
  }
}

class NoInternetStateView extends StatelessWidget {
  const NoInternetStateView({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}

class SubBinding extends Bindings {
  @override
  void dependencies() =>
      Get.lazyPut<SubController>(() => SubController(), fenix: true);
}

class SubController extends GetxController {
  SubController();
  static SubController get to => Get.find<SubController>();

  bool isLoading = true;
  int categoryId = 0;
  String title = "";

  @override
  void onInit() {
    super.onInit();

    final routeArgs = Get.parameters;
    if (routeArgs.isNotEmpty) {
      categoryId = int.parse(routeArgs['category_id'] ?? 0.toString());
      title = routeArgs['title'].toString();
      debugPrint("categoryId  => $categoryId \n Title => $title");
    }
    fetchSubCategories(categoryId.toString());
  }

  List<SubCategoriesPlatformModel> _subItems = [];
  List<SubCategoriesPlatformModel> get subItems => _subItems;

  Future<List<SubCategoriesPlatformModel>> fetchSubCategories(
      [String? catId]) async {
    if (catId != null) debugPrint(" <catId>  $catId ?? $categoryId");
    isLoading = true;
    _subItems = [];
    update();
    String url = '$BASE_URL/api/sub_categories/${catId ?? categoryId}';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return [];
      }
      // debugPrint(extractedData.length.toString());
      final List<SubCategoriesPlatformModel> loadedCategories = extractedData
          .map((e) => SubCategoriesPlatformModel.fromJson(e))
          .toList();

      _subItems = loadedCategories;
      update();
      debugPrint(" View <title>  ${_subItems.first.category?.title}");
      debugPrint(" View <2>  ${_subItems.length}");
      return loadedCategories;
    } catch (error) {
      isLoading = false;
      update();
      // debugPrint(" Error <<>>>  $error");
      return [];
    } finally {
      isLoading = false;
      update();
    }
  }
}

/* 
class SubCategoryScreen extends StatefulWidget {
  static const routeName = '/sub-cat';
  const SubCategoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // var _isLoading = false;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final categoryId = routeArgs['category_id'] as int;
    final title = routeArgs['title'];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(title, maxLines: 2),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 15),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: Provider.of<Categories>(context, listen: false)
              .fetchSubCategories(categoryId),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * .5,
                child: Center(
                  child: CircularProgressIndicator.adaptive(backgroundColor:  kPrimaryColor.withOpacity(0.7),)
                ),
              );
            } else {
              if (dataSnapshot.error != null) {
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
                    : const Center(
                        child: Text('Error Occured'),
                        // child: Text(dataSnapshot.error.toString()),
                      );
              } else {
                return Consumer<Categories>(
                  builder: (context, myCourseData, child) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Showing ${myCourseData.subItems.length} Sub-Categories',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: myCourseData.subItems.length,
                          itemBuilder: (ctx, index) {
                            return SubCategoryListItem(
                              id: myCourseData.subItems[index].id,
                              title: myCourseData.subItems[index].title,
                              parent: myCourseData.subItems[index].parent,
                              numberOfCourses:
                                  myCourseData.subItems[index].numberOfCourses,
                              index: index,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
 */