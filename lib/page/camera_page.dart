import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:flutter/services.dart';
import 'package:imperatorinteractive/example/localandwebobjectsexample.dart';
import 'package:imperatorinteractive/page/home_page.dart';

class ArApp extends StatefulWidget {
  @override
  _ArAppState createState() => _ArAppState();
}

class _ArAppState extends State<ArApp> {
  String _platformVersion = 'Unknown';
  static const String _title = 'AR Plugin Demo';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await ArFlutterPlugin.platformVersion;
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: new AssetImage('assets/images/Titles2.jpeg'),
                fit: BoxFit.fitWidth,

              ),
            ),
          ),
          title: const Text(""),
        ),
        body: Column(children: [
          Text('Running on: $_platformVersion\n'),
          Expanded(
            child: ExampleList(),
          ),
        ]),
        bottomNavigationBar: BottomAppBar(
            child: Container(
                child: GestureDetector(
                  onTap: () {

                    setState(() {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => HomePage()), (e) => false);
                    });
                  },
                  child: Image.asset('assets/images/Button_Back.jpeg'),
                ))),
      ),
    );
  }
}

class ExampleList extends StatelessWidget {
  ExampleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final examples = [
      /*Example(
          'Debug Options',
          'Visualize feature points, planes and world coordinate system',
              () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => DebugOptionsWidget()))),*/
      Example(
          'Local & Online Objects',
          'Place 3D objects from Flutter assets and the web into the scene',
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LocalAndWebObjectsWidget()))),
      /*Example(
          'Anchors & Objects on Planes',
          'Place 3D objects on detected planes using anchors',
              () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ObjectsOnPlanesWidget()))),
      Example(
          'Object Transformation Gestures',
          'Rotate and Pan Objects',
              () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ObjectGesturesWidget()))),
      Example(
          'Screenshots',
          'Place 3D objects on planes and take screenshots',
              () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScreenshotWidget()))),
      Example(
          'Cloud Anchors',
          'Place and retrieve 3D objects using the Google Cloud Anchor API',
              () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => CloudAnchorWidget()))),
      Example(
          'External Model Management',
          'Similar to Cloud Anchors example, but uses external database to choose from available 3D models',
              () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExternalModelManagementWidget())))*/
    ];
    return ListView(
      children:
          examples.map((example) => ExampleCard(example: example)).toList(),
    );
  }
}

class ExampleCard extends StatelessWidget {
  ExampleCard({Key? key, required this.example}) : super(key: key);
  final Example example;

  @override
  build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          example.onTap();
        },
        child: ListTile(
          title: Text(example.name),
          subtitle: Text(example.description),
        ),
      ),
    );
  }
}

class Example {
  const Example(this.name, this.description, this.onTap);
  final String name;
  final String description;
  final Function onTap;
}
