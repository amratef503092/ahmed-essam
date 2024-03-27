// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:three_m_physics/models/common_functions.dart';
import 'package:three_m_physics/models/country.dart';
import 'package:three_m_physics/models/update_user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../widgets/coubtry_drob_down_menu.dart';
import 'auth_screen.dart';
import 'verification_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

/* 
Future<UpdateUserModel> signUp(
    String firstName, String lastName, String email, String password) async {
  const String apiUrl = "$BASE_URL/api/signup";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password,
  });

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    throw Exception('Failed to load data');
  }
}
 */
class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> get _currentCountryCode async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        String countryCode = placemarks.first.isoCountryCode ?? "+20";
        return countryCode;
      } else {
        return '+20';
      }
    } catch (e) {
      // debugPrint('Error getting current location: $e');
      return '+20';
    }
  }

  List<Countries> _countryItems = [];
  List<Countries> get countryItems => [..._countryItems];

  Future<String> get _getCurrentCountryCode async {
    String selectedCode = "+20";
    String isoCode = await _currentCountryCode;
    var url = '$BASE_URL/api/countries';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return selectedCode;
      }
      _countryItems = CountryModel.fromJson(extractedData).countries;
      for (var iso in _countryItems) {
        if (iso.code == isoCode) {
          selectedCode = iso.code!;
        }
      }
      return selectedCode;
    } catch (error) {
      return selectedCode;
    }
  }

  Future<UpdateUserModel> signUp(
    String firstName,
    String lastName,
    String email,
    String password,
    String ?countryId,
  ) async {
    String selectedCode = await _getCurrentCountryCode;
     String apiUrl = "$BASE_URL/api/signup";

    /* print(
      " data is  ${'first_name' + " firstName \n"
          'last_name' + " lastName \n"
          'email' + " email \n"
          'country_id' + " selectedCode \n"
          'password' + " password \n"
          'phone' + " ${_phoneController.text} \n"
          'address' + " ${_addressController.text} \n"
          'age' + " ${_ageController.text} \n"}",
    ); */
    final response = await http.post(Uri.parse(apiUrl), body: {
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'email': email.trim(),
      'country_id': countryId?? selectedCode.trim(),
      'password': password.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'age': _ageController.text.trim(),
          

    });

     print("response.bod >>>>>>>>>> ${response.body}");
 
    if (response.statusCode == 200 &&
        json.decode(response.body)["status"] == 200) {
      final String responseString = response.body;

      return updateUserModelFromJson(responseString);
    } else {
      CommonFunctions.showErrorDialog(
        json.decode(response.body)["errors"],
        context,
      );
      // debugPrint(">>>>>>>>>>>>>${response.body}");
      throw Exception('Failed to load data');
    }
  }

  bool hidePassword = true;
  bool _isLoading = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  int? idCountry;

  Future<void> _submit() async {
    if (!globalFormKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    globalFormKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    try {
      final UpdateUserModel user = await 
      signUp(
          _firstNameController.text,
          _lastNameController.text,
          _emailController.text,
          _passwordController.text,
          idCountry.toString(),
          );

      if (user.emailVerification == 'enable') {
        if (user.message ==
            "You have already signed up. Please check your inbox to verify your email address") {
          Navigator.of(context).pushNamed(VerificationScreen.routeName,
              arguments: _emailController.text);
          CommonFunctions.showSuccessToast(user.message.toString());
        } else {
          Navigator.of(context).pushNamed(VerificationScreen.routeName,
              arguments: _emailController.text);
          CommonFunctions.showSuccessToast(user.message.toString());
        }
      } else {
        Navigator.of(context).pushNamed(AuthScreen.routeName);
        CommonFunctions.showSuccessToast('Signup Successful');
      }
    } catch (error) {
      // const errorMsg = 'Could not register!';
      // print(error);
      // CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      filled: true,
      prefixIcon: Icon(
        iconData,
        color: kTextLowBlackColor,
      ),
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
      hintText: hintext,
      fillColor: kBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        key: scaffoldKey,
        elevation: 0,
        iconTheme: const IconThemeData(color: kSelectItemColor),
        backgroundColor: kBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Form(
                key: globalFormKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: kBackgroundColor,
                          child: Image.asset(
                            'assets/images/do_login.png',
                            height: 65,
                          ),
                        ),
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 17.0, bottom: 5.0),
                            child: Text(
                              'الاسم الأول',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
                          child: TextFormField(
                            style: const TextStyle(fontSize: 14),
                            decoration:
                                getInputDecoration(
                              'الاسم الأول',
                                Icons.person),
                            keyboardType: TextInputType.name,
                            autofillHints: const [AutofillHints.name],
                            controller: _firstNameController,
                            // ignore: missing_return
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'First name cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // _authData['email'] = value.toString();
                              _firstNameController.text = value as String;
                            },
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 17.0, bottom: 5.0),
                            child: Text(
                              'اسم العائلة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
                          child: TextFormField(
                            style: const TextStyle(fontSize: 14),
                            decoration: getInputDecoration(
                              'اسم العائلة',
                              Icons.person,
                            ),
                            keyboardType: TextInputType.name,
                            autofillHints: const [AutofillHints.middleName],
                            controller: _lastNameController,
                            // ignore: missing_return
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'اسم العائلة لا يمكن أن يكون فارغًا';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              // _authData['email'] = value.toString();
                              _lastNameController.text = value as String;
                            },
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 17.0, bottom: 5.0),
                            child: Text(
                              'البريد الإلكتروني',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
                          child: TextFormField(
                            style: const TextStyle(fontSize: 14),
                            decoration: getInputDecoration(
                              'البريد الإلكتروني',
                              Icons.email_outlined,
                            ),
                            controller: _emailController,
                            autofillHints: const [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                            validator: (input) =>
                                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                        .hasMatch(input!)
                                    ? "أدخل بريدًا إلكترونيًا صالحًا"
                                    : null,
                            onSaved: (value) {
                              // _authData['email'] = value.toString();
                              _emailController.text = value as String;
                            },
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 17.0, bottom: 5.0),
                            child: Text(
                              'رقم الهاتف',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
                          child: TextFormField(
                            style: const TextStyle(fontSize: 14),
                            decoration:
                                getInputDecoration(
                              'رقم الهاتف',
                                Icons.phone),
                            controller: _phoneController,
                            autofillHints: const [
                              AutofillHints.telephoneNumber
                            ],
                            keyboardType: TextInputType.phone,
                            validator: (input) =>
                                (input ?? "").toString().trim().isEmpty
                                    ? "رقم الهاتف الخاص بك يجب أن يكون صالحًا"
                                    : null,
                            onSaved: (value) {
                              // _authData['email'] = value.toString();
                              _phoneController.text = value.toString();
                            },
                          ),
                        ),
                     
                   
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 17.0, bottom: 5.0),
                            child: Text(
                              'الرقم السري',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 0.0, right: 15.0, bottom: 4.0),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.text,
                            controller: _passwordController,
                            autofillHints: const [AutofillHints.newPassword],
                            onSaved: (input) {
                              // _authData['password'] = input.toString();
                              _passwordController.text = input as String;
                            },
                            validator: (input) => input!.length < 3
                                ? "برجاء إدخال كلمة مرور صالحة"
                                : null,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: const TextStyle(
                                  color: Colors.black54, fontSize: 14),
                              hintText: "الرقم السري",
                              fillColor: kBackgroundColor,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 15),
                              prefixIcon: const Icon(
                                Icons.lock_outlined,
                                color: kTextLowBlackColor,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                color: kTextLowBlackColor,
                                icon: Icon(hidePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                              ),
                            ),
                          ),
                        ),
                         
                                                const SizedBox(height: 10,),

                        SizedBox(
                          width: double.infinity,
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive())
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15,
                                      top: 10,
                                      bottom: 10),
                                  child: MaterialButton(
                                    elevation: 0,
                                    onPressed: _submit,
                                    color: kPrimaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(10),
                                      // side: const BorderSide(color: kPrimaryColor),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'تسجيل الدخول',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'لديك حساب؟',
                    style: TextStyle(
                      color: kTextLowBlackColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AuthScreen.routeName);
                    },
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
