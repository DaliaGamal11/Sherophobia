import 'package:flutter/material.dart';

import '../Models/BuildImageModel.dart';

class BuildImage extends StatelessWidget {
  final BuildImageModel model;

  BuildImage({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(model.imagePath)),
            Text(model.title,style: TextStyle(
              color: Color.fromRGBO(72, 132, 151, 1),
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(model.description,style:TextStyle(
                  fontSize: 15
              ),textAlign: TextAlign.left,),
            )
          ]),
    );
  }
}
