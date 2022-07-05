import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:uuid/uuid.dart';

class Home_page extends StatefulWidget {
  Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  dynamic imageLink;
  CollectionReference imagerefcol =
      FirebaseFirestore.instance.collection('images');
  ImagePicker _imagePicker = ImagePicker();
  var uuid = Uuid();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 23),
            // color: Colors.green,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Edit Avatar',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Color.fromARGB(255, 8, 90, 214)) ),
                      child: Text("Add an Image"),
                      onPressed: () {
                        getimage();
                        //       imagerefcol.add({'image':imageLink}).then((value) => print("object"));
                      }),
                ],
              ),
            ),
          ),
          // Container(
          //   child: ElevatedButton(child: Text("data"),onPressed: (){
          //       imagerefcol.add({'image':imageLink}).then((value) => print("object"));
          //   }),
          // )
        ],
      ),
    );
  }

  Future<void> getimage() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);

      final imageref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child(image!.name);

      final metaData = firebase_storage.SettableMetadata(
        contentType: image.mimeType,
        customMetadata: {'picked-file-path': image.path},
      );

      await imageref.putFile(io.File(image.path), metaData);

      imageLink = await imageref.getDownloadURL();
      imagerefcol.add({'image': imageLink}).then((value) => print("Finished Upload"));
      
    } catch (e) {
      print('-----------------');
      print(e);
    }
    return;
  }
}
