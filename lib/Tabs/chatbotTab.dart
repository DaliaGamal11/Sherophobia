import 'package:flutter/material.dart';
import 'package:sherophopia/Tabs/ChatScreen.dart';

class ChatBotTab extends StatefulWidget {
  const ChatBotTab({super.key});

  @override
  State<ChatBotTab> createState() => _ChatBotTabState();
}

class _ChatBotTabState extends State<ChatBotTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor:Color.fromRGBO(72, 132, 151, 1),
        title: Row(
          children: [
            Text("Chatbot"),
            Spacer(),
            Image(image: AssetImage('assets/images/psychology.png'),height: 40,width: 40,)
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height:100,),
          Text("Welcome to our Chat "),
          Text("Let’s Start our talk ",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()),
            );          setState(() {
            });

          }, style: ButtonStyle(
              backgroundColor:
          MaterialStatePropertyAll(Color.fromRGBO(72, 132, 151, 1))),
              child: Text("Start",style: TextStyle(fontSize: 30),)),
          SizedBox(
            height: 50,
          ),
          Image(image: AssetImage("assets/images/chat.png"),width: double.infinity,fit:BoxFit.fill,)

        ],
      )
    );
  }
}
