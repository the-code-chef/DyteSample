import 'package:flutter/material.dart';
import 'package:dyte_client/dyte.dart';
import 'package:dyte_client/dyteMeeting.dart';
import 'package:dyte_client/dyteParticipant.dart';
import 'package:dyte_client/mobile_flutter.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(home: FirstRoute()));
}

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    String _platformVersion = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

    Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await MobileFlutter.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var rng = new Random();
    var i = rng.nextInt(100);
    return Scaffold(
      body: Row(
        // <Widget> is the type of items in the list.
        children: <Widget>[
          SizedBox(
              width: width,
              height: height,
              child: DyteMeeting(
                roomName: "hazel-mile",
                authToken: "",
                onInit: (DyteMeetingHandler meeting) async { 
                  meeting.events.on('meetingEnd', this, (a, b) {
                    print(i.toString() + "event-meetingEnd");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstRoute()),
                    );
                  });
                  meeting.events.on('meetingDisconnected', this, (a, b) {
                    print(i.toString() + "event-meetingDisconnected");
                  });
                  meeting.events.on('meetingJoin', this, (a, b) {
                    print(i.toString() + "event-meetingJoin");
                  });
                  meeting.events.on('meetingConnected', this, (a, b) {
                    print(i.toString() + "event-meetingConnected");
                  });
                  meeting.events.on('participantJoin', null, (a, b) {
                    DyteParticipant p = a.eventData as DyteParticipant;
                    print(p.name + "-" + p.picture + "-" + p.audioEnabled.toString());
                  });
                  meeting.events.on('participantLeave', null, (a, b) {
                    DyteParticipant p = a.eventData as DyteParticipant;
                    print(p.name + "-" + p.picture + "-" + p.audioEnabled.toString());
                  });
                },
              ))
        ],
      ),
    );
  }
}