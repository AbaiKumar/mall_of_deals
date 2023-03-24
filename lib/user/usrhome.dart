// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mall/admin/viewEvents.dart';
import 'package:mall/user/viewProduct.dart';
import '../model/data.dart';
import 'package:provider/provider.dart';
import 'package:mall/sharedWidget/myicon.dart';

import '../sharedWidget/chat.dart';
import '../sharedWidget/settings.dart';

class Choice {
  const Choice({required this.title, required this.url});
  final String title, url;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Events', url: 'assets/icons/events.png'),
  Choice(title: 'Settings', url: 'assets/icons/settings.png'),
  Choice(title: 'Products', url: 'assets/icons/settings.png'),
];

class YellowBanner extends StatefulWidget {
  @override
  State<YellowBanner> createState() => _YellowBannerState();
}

class _YellowBannerState extends State<YellowBanner> {
  String name = "Welcome";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double left = size.width * 0.17;
    var a = Provider.of<Data>(context, listen: true);
    name = (a.name.isNotEmpty) ? a.name ?? name : name;
    return Container(
      height: size.height * 0.4,
      width: double.infinity,
      color: Colors.yellow,
      child: Padding(
        padding: EdgeInsets.only(
            left: left * 0.6, right: left * 0.6, top: left, bottom: left * 0.5),
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
                          "Dashboard",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: Text(
                          "Hi | $name",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  name != "Welcome"
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: MyIcon(
                            letter: name[0],
                          ),
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_2_outlined,
                            color: Colors.white,
                          ),
                        ),
                ],
              ),
            ),
            Container(
              height: size.height * 0.17,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.fill,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(size.width * 0.3),
                  ),
                  child: Image.network(
                    "https://abai-194101.000webhostapp.com/mall_of_deals/images/banner.jpeg",
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserHomeScreen extends StatefulWidget {
  @override
  State<UserHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<UserHomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> screens;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var a = Provider.of<Data>(context, listen: true);
    screens = [
      const Dashboard(),
      ChatUI(a),
      Container(),
      // LeaderboardScreen(a),
      Setting(a),
    ];
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.yellow,
      ),
    );
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_selectedIndex == 0) ? Colors.blue : Colors.black,
            ),
            label: "Events",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_rounded,
              color: (_selectedIndex == 1) ? Colors.blue : Colors.black,
            ),
            label: "Chat",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart_sharp,
              color: (_selectedIndex == 2) ? Colors.blue : Colors.black,
            ),
            label: "Leaderboard",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: (_selectedIndex == 4) ? Colors.blue : Colors.black,
            ),
            label: "Settings",
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        elevation: 5,
      ),
      body: screens[_selectedIndex],
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var a = Provider.of<Data>(context, listen: false);
    List<Widget> route = [
      EventsDisplay(a),
      Setting(a),
      CustMenu(a),
    ];

    return RefreshIndicator(
      onRefresh: () => a.getUsrData(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YellowBanner(),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: GridView.builder(
                itemCount: choices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          width: size.width * 0.3,
                          height: size.height * 0.15,
                          top: 0,
                          right: 0,
                          child: Opacity(
                            opacity: 0.5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(
                                    20,
                                  ),
                                ),
                                border: Border.all(
                                  color: Colors.yellow,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print(index);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => route[index],
                              ),
                            );
                          },
                          child: Card(
                            elevation: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  choices[index].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: ClipRRect(
                                      child: Image.asset(
                                        choices[index].url,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
