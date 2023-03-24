// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/data.dart';

class YellowBanner extends StatefulWidget {
  //setting page which has log out and user info editing options
  Data a;
  YellowBanner(this.a);
  @override
  State<YellowBanner> createState() => _YellowBannerState();
}

class _YellowBannerState extends State<YellowBanner> {
  String name = "Welcome";
  String total = "0";
  int cost = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.yellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double left = size.width * 0.17;
    var a = widget.a;
    name = (a.name.isNotEmpty) ? a.name ?? name : name;
    return Container(
      height: size.height * 0.23,
      width: double.infinity,
      color: Colors.yellow,
      child: Padding(
        padding: EdgeInsets.only(
          left: left * 0.6,
          right: left * 0.6,
          top: left,
          bottom: left * 0.5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * 0.5,
                        child: const Text(
                          "Settings",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: size.width * 0.3,
                        child: Text(
                          "Hi | $name",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        //pass
                      },
                    ),
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

class Setting extends StatefulWidget {
  Data obj;
  Setting(this.obj);
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          YellowBanner(widget.obj),
          Container(
            margin: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              onPressed: () {
                // widget.obj.clear();
              },
              child: const Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }
}
