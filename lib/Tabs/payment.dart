import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentTab extends StatefulWidget {
static String routeName="payment";

  @override
  State<PaymentTab> createState() => _PaymentTabState();
}

class _PaymentTabState extends State<PaymentTab> {
  @override
  var link="https://ipn.eg/S/salma.eldein/instapay/6LZgxB";
  var number='01014569029';

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pay For Sessions ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
            SizedBox(height: 40,),
            Text("Using Qr Code of Instapay ",style: TextStyle(fontSize: 20)),
            Image(image: AssetImage('assets/images/pay.png'),height: 400,width: 400,),
            SizedBox(height: 25,),
            Text("Using Direct Link of Instapay",style: TextStyle(fontSize: 20),),
            GestureDetector(
              onTap: () {
                  _launchURL(link);
              },
              child: Text(
                link ?? 'No meeting link provided',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 25,),
            Card(
              color: Color.fromRGBO(72, 132, 151, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15,),
                  Text("Vodafone Cash",style: TextStyle(color: Colors.white,fontSize: 20),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/images/vodafone.png'),height: 60,width: 60,),
                      SizedBox(width: 20,),
                      Text('+201014569029',style:TextStyle(color: Colors.white),),
                      SizedBox(width: 20,),
                      ElevatedButton(onPressed: () async{
                        await Clipboard.setData(ClipboardData(text: number));
                        Fluttertoast.showToast(msg: "Copied Successfully");

                      }, style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Button color
                        onPrimary: Color.fromRGBO(72, 132, 151, 1), // Text color
                      ),
                        child: Icon(Icons.copy),),
                    ],
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
