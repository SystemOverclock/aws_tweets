import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;
// import 'package:webview_flutter/webview_flutter.dart';

class CartaoTweet extends StatefulWidget {
  final String id;
  final String nome;
  final String user;
  final String post;
  final int retweets;
  final int likes;
  final DateTime postdate;
  final String attachments;

  const CartaoTweet({Key key, this.nome, this.user, this.post, this.retweets, this.likes, this.postdate, this.id, this.attachments}) : super(key: key);

  @override
  _CartaoTweetState createState() => _CartaoTweetState();
}

class _CartaoTweetState extends State<CartaoTweet> {
  // WebViewController controller;
  String _txt = '';

  String _parseHtmlString(String htmlString) {
    var text = html.Element.span()..appendHtml(htmlString);
    return text.innerText;
  }

  @override
  void initState() {
    _txt = _parseHtmlString(widget.post);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(3, 3),
              blurRadius: 3
            )
          ]
        ),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nome != '' ? widget.nome : '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.02),
                    child: Text(
                      widget.user != '' ? '@' + widget.user : '',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.04),
                    child: Text(
                      widget.post != '' ? _txt : '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  /*widget.attachments != null ? Padding(
                    padding: EdgeInsets.only(top: size.height * 0.02),
                    child: Container(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: WebView(
                          initialUrl: 'https://twitter.com/awscloud/status/' + widget.id + '/photo/1',
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (WebViewController webViewController) {
                            controller = webViewController;
                          },
                        ),
                      ),
                    ),
                  ) : Container(),*/
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.04),
                    child: Text(
                      widget.postdate != DateTime.now() ? DateFormat.jm().addPattern('  dd \'de\' MMM \'de\' yyyy').format(widget.postdate) : '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.retweets != 0 ? widget.retweets.toString() : '0',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: size.width * 0.01),
                          child: Text(
                            'Retweets',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: size.width * 0.08),
                          child: Text(
                            widget.likes != 0 ? widget.likes.toString() : '0',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: size.width * 0.01),
                          child: Text(
                            'Curtidas',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            onTap: () async {
              if(await canLaunch('https://twitter.com/' + widget.user + '/status/' + widget.id)){
                await launch('https://twitter.com/' + widget.user + '/status/' + widget.id);
              }else{
                print('Erro ao abrir o link');
              }
            },
          ),
        ),
      ),
    );
  }
}
