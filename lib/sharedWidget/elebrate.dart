// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';
import '../admin/viewEvents.dart';

class Elaborate extends StatefulWidget {
  Event data;
  Elaborate(this.data);
  @override
  State<Elaborate> createState() => _ElaborateState();
}

class _ElaborateState extends State<Elaborate> {
  late Map val;
  late TextToSpeech tts;

  @override
  void initState() {
    super.initState();
    tts = TextToSpeech();
    tts.setLanguage('en-US');
    if (widget.data.desc.isNotEmpty) {
      String text = widget.data.desc;
      tts.speak(text);
    }
  }

  @override
  void dispose() {
    super.dispose();
    tts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(widget.data.name),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 150,
                child: Image.network(
                  "https://abai-194101.000webhostapp.com/mall_of_deals/${widget.data.url}",
                  fit: BoxFit.fitWidth,
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
              Container(
                margin: const EdgeInsets.all(10),
                child: Text(
                  "Event Name : ${widget.data.name}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Text(
                  "Descrition : ${widget.data.desc}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
