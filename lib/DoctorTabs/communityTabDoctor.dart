import 'package:flutter/material.dart';
import 'package:sherophopia/DoctorTabs/createComunity.dart';
import 'package:sherophopia/DoctorTabs/manageRequestScreen.dart';
import 'package:sherophopia/PatientTabs/joinComunity.dart';

class CommunityTabDoctor extends StatelessWidget {
  const CommunityTabDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 100,),
            Text("Welcome to our Community "),
            Text("Let’s Start our discussion ",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.pushNamed(context, CreateCommunityScreen.routeName);
                }, style: ButtonStyle(
                    backgroundColor:
                    MaterialStatePropertyAll(Color.fromRGBO(72, 132, 151, 1))),
                    child: Text("Create",style: TextStyle(fontSize: 20),)),
                SizedBox(width: 30,),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(72, 132, 151, 1),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, ManageRequestsScreen.routeName);
                  },
                  child: Text('Manage access',style: TextStyle(fontSize: 20),),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Image(image: AssetImage("assets/images/Community.png"),width: double.infinity,)

          ],
        )
    );
  }
}
