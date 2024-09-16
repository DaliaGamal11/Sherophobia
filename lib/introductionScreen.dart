import 'package:flutter/material.dart';
import 'package:sherophopia/Models/BuildImageModel.dart';
import 'package:sherophopia/Widgets/buildImage.dart';
import 'package:sherophopia/login.dart';
import 'package:sherophopia/patientHome.dart';
import 'package:sherophopia/signUp.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatelessWidget {
  static const String routeName="IntroScreen";

  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController=PageController();
    BuildImageModel model =BuildImageModel(imagePath: "assets/images/Mental health-rafiki.png", title: "Welcome to Sherophopia!",
        description: """     Your journey to better mental health 
        starts here.""");
    BuildImageModel model2=BuildImageModel(imagePath: "assets/images/Mental health-amico.png"
        , title: "Discover Inner Peace", description: """       Find tools and resources 
        to help you manage stress and anxiety.""");
    BuildImageModel model3=BuildImageModel(imagePath: "assets/images/Group Chat-pana.png",
        title: "You're Not Alone", description: """       Connect with a supportive community and 
        mental health professionals.""");
    return Scaffold(
      body:Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: PageView(
            controller: pageController,
              children: [
                BuildImage(model: model),
                BuildImage(model: model2),
                BuildImage(model: model3)
              ],
          ),
        ),
      ),
      bottomSheet:Container(
        color: Color.fromRGBO(72, 132, 151, 1),
        padding: EdgeInsets.symmetric(horizontal: 80),
        height: 80,
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () {
              Navigator.pushReplacementNamed(context, SignUp.routeName);

            }, child:Text("Skip",style:TextStyle(
              color: Colors.white
            ),)),
            Center(
              child: SmoothPageIndicator(
                  controller: pageController
                  , count: 3,
                effect: WormEffect(
                dotColor: Colors.grey, // Inactive indicator color
                activeDotColor: Colors.white, // Active indicator color
              ),
              ),

            ),
            
            TextButton(onPressed: () {
              if (pageController.page == 2) {
                // Navigate to home screen if it's the last page
                Navigator.pushReplacementNamed(context, SignUp.routeName);
              } else {
                // Go to the next page
                pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }

            }, child:Text("Next",style:TextStyle(
                color: Colors.white
            ),)),

          ],
        ),
      ),
    );
  }
}
