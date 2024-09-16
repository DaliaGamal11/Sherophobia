import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadTab extends StatefulWidget {
  const UploadTab({Key? key, required this.userName, required this.bio}) : super(key: key);
  static const String routeName = 'Screen1';
  final String userName;
  final String bio;

  @override
  State<UploadTab> createState() => _UploadTabState();
}

class _UploadTabState extends State<UploadTab> {
  double _uploadProgress = 0.0;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future<void> storeDownloadUrl(String downloadURL) async {
    try {
      await FirebaseFirestore.instance.collection('users Files').doc(widget.userName).set({
        'downloadURL': downloadURL,
      });
    } catch (e) {
      print("Error storing download URL: $e");
    }
  }

  void showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  Future<void> uploadFile(String folder) async {
    if (pickedFile == null) {
      showSnackBar("No file selected", Colors.red);
      return;
    }

    final path = '$folder/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    uploadTask!.snapshotEvents.listen((TaskSnapshot snapshot) {
      setState(() {
        _uploadProgress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      });
    });

    try {
      await uploadTask!.whenComplete(() async {
        final urlDownload = await ref.getDownloadURL();
        await storeDownloadUrl(urlDownload);
        showSnackBar("Uploaded Successfully", Colors.green);
      });
    } catch (e) {
      print("Upload error: $e");
      showSnackBar("Upload Failed", Colors.red);
    }
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  bool _isImageFile(String path) {
    final List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    String extension = path.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(72, 132, 151, 1),
        title: Row(
          children: [
            Text(
              "Sherophopia",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            Spacer(),
            Image(image: AssetImage('assets/images/psychology.png'),height: 40,width: 40,)
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            if (pickedFile != null)
              Container(
                color: Color.fromRGBO(72, 132, 151, 1),
                child: Center(
                  child: _isImageFile(pickedFile!.path!)
                      ? Image.file(
                    File(pickedFile!.path!),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Text('Display File: ${pickedFile!.name}'),
                ),
              ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(backgroundColor:MaterialStatePropertyAll(Color.fromRGBO(72, 132, 151, 1),)),
              onPressed: selectFile,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_box_outlined,size: 50,),
                  SizedBox(width: 8),
                  Text('Select File',style:TextStyle(fontSize: 20),),
                ],
              ),
            ),
            SizedBox(height: 24),
            LinearPercentIndicator(
              animation: true,
              lineHeight: 30,
              percent: _uploadProgress / 100,
              center: Text(
                "${_uploadProgress.toStringAsFixed(2)}%",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
              progressColor: Colors.green,
              backgroundColor: Colors.grey,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ButtonStyle(backgroundColor:MaterialStatePropertyAll(Color.fromRGBO(72, 132, 151, 1),)),
              onPressed: () {
                uploadFile(widget.userName);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.upload_sharp,size: 50,),
                  SizedBox(width: 8),
                  Text('Upload File',style: TextStyle(fontSize: 20),),
                ],
              ),
            ),
            SizedBox(height: 40,),
            Image(image: AssetImage('assets/images/Files sent.gif'))
          ],
        ),
      ),
    );
  }
}
