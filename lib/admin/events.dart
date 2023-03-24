// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, depend_on_referenced_packages, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/data.dart';

class Events extends StatefulWidget {
  final Data obj;
  const Events(this.obj);
  @override
  State<Events> createState() => _ProductsAddState();
}

class _ProductsAddState extends State<Events> {
  final _url = FocusNode(),
      _describe = FocusNode(),
      _glob = GlobalKey<FormState>();
  late File uploadimage = File(""); //variable for choosed file
  late Data obj;
  late String name = "", desc = "", measure = "Painting";

  @override
  void initState() {
    super.initState();
    obj = widget.obj;
  }

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> chooseImage() async {
    var choosedimage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = File(choosedimage!.path.toString());
    });
  }

  void display(context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Text(
            msg,
          ),
        ),
      ),
    );
  }

  Future<List> uploadImage(context) async {
    //show your own loading or progressing code here

    String uri =
        "https://abai-194101.000webhostapp.com/mall_of_deals/uploadEventImage.php";

    try {
      List<int> imageBytes = uploadimage.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      //convert file image to Base64 encoding
      var response = await http.post(Uri.parse(uri), body: {
        'image': baseimage,
      });
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body); //decode json data
        if (jsondata["error"]) {
          //check error sent from server
          return [false, jsondata["msg"]];
          //if error return from server, show message from server
        } else {
          return [true, jsondata["msg"]];
        }
      } else {
        return [false, "Error during connection to server"];
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    } catch (e) {
      return [false, "Error during converting to Base64"];
      //there is error during converting file image to base64 encoding.
    }
  }

  Future<void> uploadContent(BuildContext c) async {
    bool val = _glob.currentState!.validate();
    if (!val || uploadimage.path == "") {
      display(context, "Pick Image and fill details.");
      return;
    }
    _glob.currentState?.save();
    late bool res;
    //new add
    display(context, "Please wait image uploading...");
    List resp = await uploadImage(context);
    if (resp[0]) {
      var doc = obj.firestore.collection("Events").doc();
      doc.set({
        "id": DateTime.now(),
        "name": name,
        "description": desc,
        "imgurl": resp[1],
      });
      res = true;
    }
    if (res) {
      display(context, "Data added.");
      Navigator.of(context).pop();
    } else {
      display(context, "Data not added.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Events",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            onPressed: () {
              uploadContent(context);
            },
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _glob,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                maxLength: 30,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
                initialValue: name,
                onChanged: (_) {
                  name = _.toString();
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_describe);
                },
                onSaved: (_) {
                  name = _.toString();
                },
                validator: (str) {
                  if (str == null || str.isEmpty) {
                    return "Please mention name ";
                  } else if (str.length > 30) {
                    return "Enter name below 20 characters";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                maxLength: 250,
                focusNode: _describe,
                maxLines: 2,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
                initialValue: desc,
                onChanged: (_) {
                  desc = _.toString();
                },
                onFieldSubmitted: (_) {
                  // FocusScope.of(context).requestFocus(_measure);
                },
                onSaved: (_) {
                  desc = _.toString();
                },
                validator: (str) {
                  if (str == null || str.isEmpty) {
                    return "Please mention name ";
                  } else if (str.length > 250) {
                    return "Enter name below 150 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),

              //show image here after choosing image
              Container(
                  margin: const EdgeInsets.all(5),
                  height: 150,
                  width: 150,
                  child: Image.file(
                    uploadimage,
                    errorBuilder: (context, error, stackTrace) => Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Choose Image to Upload",
                      ),
                    ),
                    fit: BoxFit.contain,
                  ) //load image from file
                  ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {
                    chooseImage(); // call choose image function
                  },
                  icon: const Icon(Icons.folder_open),
                  label: const Text("CHOOSE IMAGE"),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                        ),
                        onPressed: () {
                          _glob.currentState?.reset();
                        },
                        icon: const Icon(Icons.clear, color: Colors.red),
                        label: const Text('Clear'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                        ),
                        onPressed: () {
                          uploadContent(context);
                        },
                        icon: Icon(
                          Icons.done_outlined,
                          color: Colors.green[800],
                        ),
                        label: const Text('Submit'),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
