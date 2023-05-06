import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String text,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<List<File>> pickImages() async{
  List<File> images=[];
  try{
    var result= await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true
    );
    if(result!=null && result.files.isNotEmpty){
      for (var element in result.files) {
        if(element.path!=null){
          images.add(File(element.path!));
        }
      }
    }
  }catch(e){
    debugPrint(e.toString());
  }
  return images;
}
