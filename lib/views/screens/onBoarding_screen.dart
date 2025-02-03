import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:muzn/app_localization.dart'; // Adjust the import path as needed
import 'package:muzn/views/screens/home_screen.dart';
import 'package:muzn/views/screens/login_screen.dart'; // Adjust the import path as needed

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: deviceHeight * 0.15,
        ),
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "onBoarding1_title".tr(context),
              body: "onBoarding1_text".tr(context),
              image: Center(
                child: Image.asset(
                  "assets/images/onboarding.png",
                  height: deviceHeight * 0.60,
                ),
              ),
            ),
            PageViewModel(
              title: "onBoarding2_title".tr(context),
              body: "onBoarding2_text".tr(context),
              image: Center(
                child: Image.asset(
                  "assets/images/onboarding.png",
                  height: deviceHeight * 0.60,
                ),
              ),
            ),
            PageViewModel(
              title: "onBoarding3_title".tr(context),
              body: "onBoarding3_text".tr(context),
              image: Center(
                child: Image.asset(
                  "assets/images/onboarding.png",
                  height: deviceHeight * 0.60,
                ),
              ),
            ),
          ],
          onDone: () async {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
          },
          onSkip: () async {
           Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
          },
          showSkipButton: true,
          skip: Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              "skip_button".tr(context),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          next: Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "next".tr(context),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.arrow_forward, color: Colors.white, size: 30),
              ],
            ),
          ),
          done: Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              "done_button".tr(context),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Colors.grey,
            activeSize: Size(22.0, 10.0),
            activeColor: Color(0xffda9f35),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );
  }
}


