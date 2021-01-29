import 'dart:async';
import 'package:awscloud_tweets/import.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '@AWSCLOUD Tweets',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(0, 172, 238, 1),
        accentColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Timer tempo;

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this
    );
    animation = Tween<double>(begin: 0, end: 100).animate(controller)..addListener(() {
      setState(() {
      });
    });
    controller.repeat();
    tempo = new Timer(Duration(seconds: 4), () async {
      await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => IntroducaoScreen(erro: false)), (route) => false);
    });
    super.initState();
  }

  @override
  void dispose() {
    tempo.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: theme.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/twitter.png', fit: BoxFit.cover, height: animation.value, width: animation.value),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.01),
                child: Text(
                  'AWS Tweets',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
