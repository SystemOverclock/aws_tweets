import 'package:flutter/material.dart';
import 'package:awscloud_tweets/import.dart';

class BtnTweets extends StatefulWidget {
  @override
  _BtnTweetsState createState() => _BtnTweetsState();
}

class _BtnTweetsState extends State<BtnTweets> {
  bool click = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.08,
      width: click ? size.width * 0.18 : size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(click ? 50 : 10),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              offset: Offset(3, 3),
              blurRadius: 3
          )
        ]
      ),
      child: Material(
        borderRadius: BorderRadius.circular(click ? 50 : 10),
        color: theme.accentColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(click ? 50 : 10),
          child: Center(
              child: click ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(theme.primaryColor)) : Text(
                'Listar Tweets',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black
                ),
              )
          ),
          onTap: () async {
            setState(() {
              click = !click;
            });
            await Navigator.push(context, MaterialPageRoute(builder: (context) => ListarTweetsScreen(account: 'awscloud', bearer: 'AAAAAAAAAAAAAAAAAAAAACXZMAEAAAAACPvFQKG1vvXC2PT4oqni7EbfsmU%3DeKjOjGHvuN96DNtziy03KrF6pQdw7z4UiDJ7JW5U7LmhxUA5xu')));
            //TODO: alterar o bearer key e caso queira mudar a conta buscada.
            setState(() {
              click = !click;
            });
          },
        ),
      ),
    );
  }
}