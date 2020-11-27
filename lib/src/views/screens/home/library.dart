import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/main.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  SharedPrefService _sharedPrefService = SharedPrefService();

  bool isLoading = false;

  Future<void> _signOut() async {
    setState(() {
      isLoading = true;
    });
    await _sharedPrefService.save(id: 'user_id', data: null);
    await _sharedPrefService.save(id: 'first_name', data: null);
    Get.offAll(Main());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomAppBar(
                  label: 'Library',
                ),
                Container(
                  height: height - 100,
                  child: CustomButton(
                    labelName: 'SIGN OUT',
                    isLoading: isLoading,
                    onPressed: _signOut,
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
