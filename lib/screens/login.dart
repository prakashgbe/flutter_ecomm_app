import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/components/custom_button.dart';
import '/components/custom_text_input.dart';
import '/utils/application_state.dart';
import '/utils/common.dart';
import '/utils/custom_theme.dart';
import '/utils/login_data.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loadingButton = false;

  final List locale = [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'Español', 'locale': Locale('es', 'US')},
    {'name': '中國人', 'locale': Locale('zh', 'CN')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  buildLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Choose Your Language'),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text(locale[index]['name']),
                        onTap: () {
                          print(locale[index]['name']);
                          updateLanguage(locale[index]['locale']);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.red,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  Map<String, String> data = {};

  _LoginScreenState() {
    data = LoginData.signIn;
  }

  void switchLogin() {
    setState(() {
      if (mapEquals(data, LoginData.signUp)) {
        data = LoginData.signIn;
      } else {
        data = LoginData.signUp;
      }
    });
  }

  void hindi() {
    Get.updateLocale(Locale('hi', 'IN'));
  }

  void english() {
    Get.updateLocale(Locale('en', 'US'));
  }

  loginError(FirebaseAuthException e) {
    log("error");
    if (e.message != '') {
      setState(() {
        _loadingButton = false;
      });
      CommonUtil.showAlert(
          context, 'Error processing your request', e.message.toString());
    }
  }

  void loginButtonPressed() {
    setState(() {
      _loadingButton = true;
    });
    ApplicationState applicationState =
        Provider.of<ApplicationState>(context, listen: false);
    if (mapEquals(data, LoginData.signUp)) {
      applicationState.signUp(
          _emailController.text, _passwordController.text, loginError);
    } else {
      applicationState.signIn(
          _emailController.text, _passwordController.text, loginError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0, bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/Wilsonart.png',
                      fit: BoxFit.contain,
                      height: 100,
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                                  onPressed: () {
                    buildLanguageDialog(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(190, 222, 7, 7), // Background color
                                  ),
                                  child: Text('changelang'.tr)),
                  ),

                  /*
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      data["heading"] as String,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Text(data["subHeading"] as String,
                      style: Theme.of(context).textTheme.bodySmall)
                  */


                ],
              ),
            ),
            model(data, _emailController, _passwordController),
         
            if (mapEquals(data, LoginData.signIn))
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  child: TextButton(
                    onPressed: switchLogin,
                    child: Text(
                      'signuptext'.tr,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              ],
            ),
            if (mapEquals(data, LoginData.signUp))
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  child: TextButton(
                    onPressed: switchLogin,
                    child: Text(
                      'signintext'.tr,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              ],
            ),
            if (mapEquals(data, LoginData.signIn))
              Center(
                  child: SizedBox(
                      width: 200,
                      child: CustomButton(
                          text: 'signup'.tr,
                          onPress: switchLogin,
                          loading: _loadingButton))),
            if (mapEquals(data, LoginData.signUp))
              Center(
                  child: SizedBox(
                      width: 200,
                      child: CustomButton(
                          text: 'signin'.tr,
                          onPress: switchLogin,
                          loading: _loadingButton))),
         
            
          ],
        ),
      ),
    );
  }

  model(Map<String, String> data, TextEditingController emailController,
      TextEditingController passwordController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 56),
      decoration: CustomTheme.getCardDecoration(),
      child: Column(
        children: [
          CustomTextInput(
              label: 'youremailaddress'.tr,
              placeholder: 'emailformat'.tr,
              icon: Icons.person_outline,
              textEditingController: _emailController),
          CustomTextInput(
              label: 'password'.tr,
              placeholder: 'password'.tr,
              icon: Icons.lock_outlined,
              password: true,
              textEditingController: _passwordController),
          if (mapEquals(data, LoginData.signIn))    
          CustomButton(
              text: 'signin'.tr,
              onPress: loginButtonPressed,
              loading: _loadingButton),
          if (mapEquals(data, LoginData.signUp))    
          CustomButton(
              text: 'signup'.tr,
              onPress: loginButtonPressed,
              loading: _loadingButton)
        ],
      ),
    );
  }
}
