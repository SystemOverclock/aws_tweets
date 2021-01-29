import 'dart:convert';
import 'dart:io';
import 'package:awscloud_tweets/import.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ListarTweetsScreen extends StatefulWidget {
  final String account;
  final String bearer;

  const ListarTweetsScreen({Key key, this.account, this.bearer}) : super(key: key);

  @override
  _ListarTweetsScreenState createState() => _ListarTweetsScreenState();
}

class _ListarTweetsScreenState extends State<ListarTweetsScreen> {
  TextEditingController controller = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectDate;
  TimeOfDay selectTime;
  List tweets = [];
  String nxtpage = '';
  String nome = '';
  List<Widget> posts = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    FocusScopeNode currentFocus = FocusScope.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          color: theme.primaryColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Material(
                  elevation: 3,
                  color: theme.primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: size.height * 0.054,
                      ),
                      Text(
                        '@' + widget.account + ' Tweets',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.02, bottom: size.height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: size.width * 0.02, right: size.width * 0.04),
                              child: Container(
                                width: size.width * 0.7,
                                height: size.height * 0.08,
                                padding: EdgeInsets.only(left: size.width * 0.02, right: size.width * 0.02),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: 'Buscar por...',
                                      border: InputBorder.none,
                                      filled: false
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: controller,
                                  onEditingComplete: () async {
                                    posts = [];
                                    await _init(txt: controller.text);
                                    currentFocus.unfocus();
                                  },
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: size.width * 0.02),
                                child: Container(
                                  height: size.height * 0.08,
                                  width: size.width * 0.15,
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
                                    color: theme.accentColor,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Center(
                                          child: Icon(Icons.calendar_today, color: Colors.black)
                                      ),
                                      onTap: () async {
                                        posts = [];
                                        await _selectDate(context);
                                        await _selectTime(context);
                                        await _init(txt: controller.text, datetime: DateFormat('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'').format(DateTime(selectDate.year, selectDate.month, selectDate.day, selectTime.hour, selectTime.minute)));
                                      },
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                posts.length > 0 ? SingleChildScrollView(
                  child: Container(
                    height: size.height * 0.79,
                    width: size.width,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await _init(txt: controller.text, datetime: (selectDate != null ? DateFormat('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'').format(DateTime(selectDate.year, selectDate.month, selectDate.day, selectTime.hour, selectTime.minute)) : DateTime.now()), refresh: true);
                      },
                      child: ListView(
                        padding: EdgeInsets.all(10),
                        children: posts,
                      ),
                    ),
                  ),
                ) : Padding(
                  padding: EdgeInsets.only(top: size.height * 0.1),
                  child: Container(width: 50, height: 50, child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _init({String txt, String datetime, bool refresh = false}) async {
    await http.get('https://api.twitter.com/2/users/by?usernames=awscloud&tweet.fields=author_id', headers: {HttpHeaders.authorizationHeader: 'Bearer ' + widget.bearer}).then((value) {
      Map data = jsonDecode(value.body);
      if(data.containsKey('errors')){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => IntroducaoScreen(erro: true)), (route) => false);
      }else{
        data.forEach((key, value) {
          if(key == 'data'){
            List info = value;
            info.forEach((element) {
              Map moreinfo = element;
              moreinfo.forEach((key, value) {
                if(key == 'name'){
                  nome = value;
                }
              });
            });
          }
        });
      }
    });

    await http.get('https://api.twitter.com/2/tweets/search/recent?query=from:' + widget.account + (txt != null ? ' ' + txt : '') + '&tweet.fields=created_at,public_metrics,author_id&user.fields=created_at,name,username&max_results=15' + (datetime != null ? '&end_time=' + datetime : '') + (refresh ? '&next_token=' + nxtpage : ''), headers: {HttpHeaders.authorizationHeader: 'Bearer ' + widget.bearer}).then((value) {
      Map data = jsonDecode(value.body);
      data.forEach((key, value) {
        if(key == 'data'){
          tweets = value;
        }else if(key == 'meta'){
          Map info = value;
          info.forEach((key, value) {
            if(key == 'next_token'){
              nxtpage = value;
            }
          });
        }
      });
      tweets.forEach((element) {
        Map info = element;
        String id = '';
        String post = '';
        int retweets = 0;
        int likes = 0;
        DateTime postdate = DateTime.now();
        info.forEach((key, value) {
          if(key == 'id'){
            id = value;
          }else if(key == 'text'){
            post = value;
          }else if(key == 'created_at'){
            postdate = DateTime.tryParse(value);
          }else if(key == 'public_metrics'){
            Map moreinfo = value;
            moreinfo.forEach((key, value) {
              if(key == 'retweet_count'){
                retweets = value;
              }else if(key == 'like_count'){
                likes = value;
              }
            });
          }
        });
        posts.add(CartaoTweet(id: id, nome: nome, user: widget.account, likes: likes, post: post, postdate: postdate, retweets: retweets));
      });
    });
    if(refresh){
      refresh = !refresh;
    }
    setState(() {
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: new DateTime.now().subtract(Duration(days: 7)), lastDate: new DateTime.now());
    if (picked != null && picked != selectedDate) selectDate = picked; print(selectDate);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime = picked; print(selectTime.format(context));
  }
}
