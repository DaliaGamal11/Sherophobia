import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class QuoteSection extends StatefulWidget {
  @override
  _QuoteSectionState createState() => _QuoteSectionState();
}

class _QuoteSectionState extends State<QuoteSection> {
  String _quote = 'Everything will be okay';

  Future<void> _getRandomQuote() async {
    final response = await http.get(Uri.parse('https://api.quotable.io/random'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _quote = data['content'];
      });
    } else {
      setState(() {
        _quote = 'Failed to load a quote';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getRandomQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(72, 132, 151, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Quotes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          Text(_quote, style: TextStyle(fontSize: 14, color: Colors.white)),
          SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(onPressed: () async {
                final result = await Share.shareWithResult(_quote);

                if (result.status == ShareResultStatus.success) {
                  Fluttertoast.showToast(msg: 'Your Quote Shared successfully');
                }
                else{
                  Fluttertoast.showToast(msg:'Failed to share your Quote');

                }
              }, style: ElevatedButton.styleFrom(
                primary: Colors.white, // Button color
                onPrimary: Color.fromRGBO(72, 132, 151, 1), // Text color
              ),
                child: Icon(Icons.share),),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: _getRandomQuote,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Button color
                    onPrimary: Color.fromRGBO(72, 132, 151, 1), // Text color
                  ),
                  child: Icon(Icons.refresh_rounded),
                ),
              ),
              Spacer(),
              ElevatedButton(onPressed: () async{
                await Clipboard.setData(ClipboardData(text: _quote));
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
    );
  }
}
