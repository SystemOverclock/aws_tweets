import 'package:flutter/material.dart';
import 'package:awscloud_tweets/import.dart';

class IntroducaoScreen extends StatefulWidget {
  final bool erro;

  const IntroducaoScreen({Key key, this.erro}) : super(key: key);

  @override
  _IntroducaoScreenState createState() => _IntroducaoScreenState();
}

class _IntroducaoScreenState extends State<IntroducaoScreen> {

  @override
  void initState() {
    if(widget.erro){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Erro ao localizar o usuário', style: TextStyle(color: Colors.black)), backgroundColor: Colors.red));
    }
    super.initState();
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
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Seja bem-vindo ao conteúdo de Tweets',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.02),
                child: BtnTweets(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
