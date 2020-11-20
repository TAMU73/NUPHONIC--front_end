import 'package:get/get.dart';
import 'package:nuphonic_front_end/models/onboarding_model.dart';

class OnBoardingController extends GetxController {

  var sliders = List<OnBoardingModel>().obs;
  var currentIndex = 0.obs;
  int get length => sliders.length;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchData();
  }

  void fetchData() {
    var values = [
      OnBoardingModel(
          imagePath: "assets/logos/app_logo_mini.svg",
          title: "Welcome to",
          appName: "NUPHONIC",
          subTitle: "ANYTIME, ANYWHERE"),
      OnBoardingModel(
          imagePath: "assets/illustrations/music_environment.svg",
          title: "Listen any song",
          subTitle: "Find your favourite music and enjoy without paying"),
      OnBoardingModel(
          imagePath: "assets/illustrations/upload.svg",
          title: "Upload your song",
          subTitle: "Make your own music and upload without paying"),
      OnBoardingModel(
          imagePath: "assets/illustrations/support_bucket.svg",
          title: "Support any artist",
          subTitle: "Find your favourite artist and support them financially"),
    ];
    // ignore: deprecated_member_use, invalid_use_of_protected_member
    sliders.value = values;
  }

}