import 'package:flutter/material.dart';
import 'package:imperatorinteractive/page/splash_page.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late VideoPlayerController _controller;

  late Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  loadVideoPlayer() {
    _controller =
        VideoPlayerController.asset('assets/videos/Video2_MainMenu.mp4');
    _controller.setLooping(true);
    _controller.addListener(() {
      setState(() {});
    });
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      setState(() {
        _controller.play();
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
        body: FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
        // If the VideoPlayerController has finished initialization, use
        // the data it provides to limit the aspect ratio of the video.

        return GestureDetector(
            onTap: () {
              print(_counter);
              if (_counter == 2) {
                //menuZoom();
              } else {
                print("PLAY VIDEO");
              }
            },
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.

                child: VideoPlayer(_controller),
              ),
            ));
        // } else {
        //   // If the VideoPlayerController is still initializing, show a
        //   // loading spinner.
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
      },
    ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  void videoMenu() {
    // Implement your calls inside these conditions' bodies :
    // if (_controller.value.position ==
    //     const Duration(seconds: 0, minutes: 0, hours: 0)) {}
    //
  }

  void menuZoom() {
    if (_controller.value.position == _controller.value.duration) {
      _controller =
          VideoPlayerController.asset('assets/videos/Video3_MainMenuZoom.mp4');
      // Initialize the controller and store the Future for later use.
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.play();
      _controller.setLooping(false);
      // _controller.addListener(toMain);
      _counter = 2;
    }
  }

  @override
  void toMain() {
    if (_controller.value.position == _controller.value.duration) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const MainPage()),
      // );
    }
  }
}
