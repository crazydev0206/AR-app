import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imperatorinteractive/example/localandwebobjectsexample.dart';
import 'package:imperatorinteractive/page/camera_page.dart';
import 'package:imperatorinteractive/page/splash_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  AudioPlayer player = AudioPlayer();
  bool _zoom = false;
  double _opacity = 0;
  late Animation<Offset> animation;
  late Animation<Offset> animationBottom;
  late AnimationController animationController;

  @override
  void initState() {
    _zoom = false;
    loadVideoPlayer();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animation = Tween<Offset>(
            begin: Offset.zero, end: Offset(0, -1.5)) //negative to go upwards
        .animate(animationController);

    animationBottom = Tween<Offset>(
            begin: Offset.zero, end: Offset(0, 1.5)) //negative to go upwards
        .animate(animationController);
    super.initState();
  }

  loadVideoPlayer() {
    String audioasset = "audio/MainMenuMusic.mp3";
    player.play(AssetSource(audioasset));

    _controller =
        VideoPlayerController.asset('assets/videos/Video2_MainMenu.mp4');

    _controller.addListener(() {
      if (_zoom) {
        setState(() {});
      }
    });
    _controller.initialize().then((value) {
      _controller.setLooping(true);
      _controller.play();
      setState(() {
        _opacity = 1;
        //animationController.forward();
      });
    });
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.black,
      /*  appBar: AppBar(
        backgroundColor: Colors.black,

        title: Container(
            height: 100,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArApp()),
                );
                setState(() {});
              },
              child: Image.asset('assets/images/Titles1.jpeg'),
            )),
      ),*/
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
              child: GestureDetector(
                  onTap: () {
                    //Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      Future.delayed(Duration(seconds: 1), () {
                        menuZoom();
                        player.stop();
                      });
                      _zoom = true;

                      //});
                    });
                  },
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.

                    child: VideoPlayer(_controller),
                  ))

              // } else {
              //   // If the VideoPlayerController is still initializing, show a
              //   // loading spinner.
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }

              ),
          Align(
              alignment: Alignment.topCenter,
              child: SlideTransition(
                  position: animation,
                  child: AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(seconds: 0),
                      child: Image.asset('assets/images/Titles1.jpeg')))),
          Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                  position: animationBottom,
                  child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(seconds: 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _launchURL();
                        });
                      },
                      child: Image.asset('assets/images/Button_Website.jpeg'),
                    ),
                  )))
        ],
      ),

      /*bottomNavigationBar:
          BottomAppBar(),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  menuZoom() {
    _controller =
        VideoPlayerController.asset('assets/videos/Video3_MainMenuZoom.mp4');
    // Initialize the controller and store the Future for later use.
    _controller.initialize().then((value) {
      _controller.setLooping(false);
      _controller.play();
      setState(() {
        _opacity = 0;
      });
    });
    _controller.addListener(() {
      setState(() {
        animationController.forward();
        if (_controller.value.position == _controller.value.duration) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => LocalAndWebObjectsWidget()),
              (e) => false);

          //_createRoute();
        }
      });
    });
  }
}

void _launchURL() async {
  const url = 'https://www.imperatorinteractive.com';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
    print("TEST CLICK");
  } else {
    throw 'Could not launch $url';
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
