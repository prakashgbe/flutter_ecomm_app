import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '/components/custom_button.dart';
import '/utils/application_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loadingButon = false;

  void signOutButtonPressed() async {
    setState(() {
      _loadingButon = true;
    });
    Provider.of<ApplicationState>(context, listen: false).signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'hithere'.tr,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          CustomButton(
            text: 'signoutbutton'.tr,
            onPress: signOutButtonPressed,
            loading: _loadingButon,
          ),
        ],
      ),
    );
  }
}
