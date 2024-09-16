import 'package:flutter/material.dart';
import 'package:sherophopia/Models/ListTitleModel.dart';

class ListTitle extends StatelessWidget {
  final ListTitleModel model;
  ListTitle({required this.model});


  @override
  Widget build(BuildContext context) {
    return  ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(model.imagePath)),
      title: Text(model.title),
      subtitle: Text(model.description),
      trailing: Checkbox(value: false, onChanged: (bool? value) {}),
    );
  }
}
