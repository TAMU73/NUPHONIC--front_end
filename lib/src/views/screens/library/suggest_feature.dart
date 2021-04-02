import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/suggest_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class SuggestFeature extends StatefulWidget {
  @override
  _SuggestFeatureState createState() => _SuggestFeatureState();
}

class _SuggestFeatureState extends State<SuggestFeature> {
  SharedPrefService _sharedPrefService = SharedPrefService();
  SuggestService _suggestService = SuggestService();
  CustomSnackBar _customSnackBar = CustomSnackBar();
  TextEditingController featureNameController = TextEditingController();
  TextEditingController featureDescriptionController = TextEditingController();

  String featureName = "";
  String featureDescription = "";

  bool isLoading = false;

  Future<void> suggestFeature(String featureName, String featureDescription) async {
    setState(() {
      isLoading = true;
    });
    String userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result =
    await _suggestService.suggestFeature(featureName, featureDescription, userID);
    setState(() {
      isLoading = false;
    });
    if (result == null) {
      _customSnackBar.buildSnackBar("Network Error", false);
    } else {
      _customSnackBar
          .buildSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        setState(() {
          this.featureName = "";
          this.featureDescription = "";
        });
        featureNameController.clear();
        featureDescriptionController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomAppBar(
                  label: 'Suggest Feature',
                  leadIconPath: 'assets/icons/back_icon.svg',
                  onIconTap: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  controller: featureNameController,
                  labelName: 'Feature Name',
                  hint: 'Name of the feature',
                  onChanged: (val) {
                    setState(() {
                      featureName = val;
                    });
                  },
                ),
                SizedBox(height: 15),
                CustomTextField(
                  controller: featureDescriptionController,
                  labelName: 'Feature Description',
                  hint: 'Add description here...',
                  maxLines: 100,
                  height: 100,
                  onChanged: (val) {
                    setState(() {
                      featureDescription = val;
                    });
                  },
                ),
                SizedBox(height: 30),
                CustomButton(
                  labelName: 'SUGGEST',
                  isLoading: isLoading,
                  onPressed: featureName != "" && featureDescription != ""
                      ? () {
                    suggestFeature(featureName, featureDescription);
                  }
                      : null,
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
