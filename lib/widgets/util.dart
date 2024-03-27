import 'package:three_m_physics/models/common_functions.dart';
import 'package:three_m_physics/providers/courses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

buildPopupDialog(BuildContext context, items) {
  return AlertDialog(
    title: const Text('Notifying'),
    content: const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Do you wish to remove this course?'),
      ],
    ),
    actions: <Widget>[
      MaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text(
          'No',
          style: TextStyle(color: Colors.red),
        ),
      ),
      MaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
          Provider.of<Courses>(context, listen: false)
              .toggleWishlist(items, true)
              .then((_) =>
                  CommonFunctions.showSuccessToast('Removed from wishlist.'));
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text(
          'Yes',
          style: TextStyle(color: Colors.green),
        ),
      ),
    ],
  );
}

buildPopupDialogWishList(BuildContext context, bool isWishlisted, String? id) {
  return AlertDialog(
    title: const Text('Notifying'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Do you want ${isWishlisted ? "remove" : "to add"} it?'),
      ],
    ),
    actions: <Widget>[
      MaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text(
          'No',
          style: TextStyle(color: Colors.red),
        ),
      ),
      MaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
          var msg = "${isWishlisted ? 'Remove from' : 'Added to'} Wishlist";
          CommonFunctions.showSuccessToast(msg);
          Provider.of<Courses>(context, listen: false)
              .toggleWishlist(int.parse(id.toString()), false);
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text(
          'Yes',
          style: TextStyle(color: Colors.green),
        ),
      ),
    ],
  );
}
