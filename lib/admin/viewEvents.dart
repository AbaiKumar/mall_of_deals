// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, depend_on_referenced_packages, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import '../model/data.dart';
import '../sharedWidget/elebrate.dart';

class Event {
  final String url, desc, id, name;
  Event(this.url, this.desc, this.id, this.name);
}

class EventsDisplay extends StatefulWidget {
  final Data obj;
  const EventsDisplay(this.obj);
  @override
  State<EventsDisplay> createState() => _EventsDisplayState();
}

class _EventsDisplayState extends State<EventsDisplay> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    eventFetch();
  }

  Future eventFetch() async {
    events = [];
    var a = await widget.obj.firestore.collection("Events").get();
    for (var b in a.docs) {
      var c = b.data();
      events.add(
        Event(
          c["imgurl"].toString(),
          c["description"].toString(),
          c["id"].toString(),
          c["name"].toString(),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Events",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: RefreshIndicator(
        onRefresh: eventFetch,
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Elaborate(
                        events[index],
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Image.network(
                          "https://abai-194101.000webhostapp.com/mall_of_deals/${events[index].url}",
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: Text(
                          "Event Name : ${events[index].name}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
