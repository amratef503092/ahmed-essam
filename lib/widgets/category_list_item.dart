import 'package:three_m_physics/screens/sub_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import 'random_calss.dart';

class CategoryListItem extends StatelessWidget {
  final int? parent;
  final String? title, thumbnail;
  final int? numberOfSubCategories;

  const CategoryListItem({
    super.key,
    required this.parent,
    required this.title,
    required this.thumbnail,
    required this.numberOfSubCategories,
  });

  @override
  Widget build(BuildContext context) {
    SubBinding().dependencies();
    return Directionality(
      textDirection: TextDirection.ltr, 
      child: InkWell(
        onTap: () {
          Get.toNamed(SubCategoryScreen.routeName, parameters: {
            'category_id': parent.toString(),
            'title': title.toString(),
          });
      
          // SubController.to.title = title ?? "";
          // SubController.to.update();
          // SubController.to.fetchSubCategories(parent.toString());
          /* Navigator.of(context).pushNamed(
            SubCategoryScreen.routeName,
            arguments: {
              'category_id': parent,
              'title': title,
            },
          ); */
        },
        child: Card(
          // color: RandomClass.randomColor,
                  color: kPrimaryColor,
      
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loading_animated.gif',
                        image: thumbnail.toString(),
                        fadeInCurve: Curves.fastOutSlowIn,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                    width: double.infinity,
                    // height: 80,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title ?? "",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kNoteColor
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '$numberOfSubCategories الاقسام الفرعية',
                            style:
                                TextStyle(color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: iCardColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 2,
                        ),
                        child: ImageIcon(
                          const AssetImage("assets/images/long_arrow_right.png"),
                          color: kPrimaryColor.withOpacity(0.7),
                          size: 40,
                        ),
                      ),
                    ),
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
