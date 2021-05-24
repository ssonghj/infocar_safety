import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'alarm_config.dart';
import 'mainmenu.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';


class Data {
  final int status;

  Data(this.status);

  static Data fromJson(Map<String, String> map) {}
}

class drivestyle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Generated App',
      theme: new ThemeData(
        primaryColor: const Color(0xff030F2A),
        accentColor: const Color(0xff030F2A),
        canvasColor: const Color(0xff030F2A),
      ),
      home: new drivestylePage(),
    );
  }
}

class drivestylePage extends StatefulWidget {
  drivestylePage({Key key}) : super(key: key);

  @override
  _drivestylePage createState() => new _drivestylePage();
}

class _drivestylePage extends State<drivestylePage> {
  var is_Check = is_Checked;
  var sound = is_Checked2;
  var vibration = is_Checked3;
  var isPressed = false;
  var position = wd;
  List<Data> list_data;

  @override
  void initState() { //json을 받아오기 위한 초기화
    // TODO: implement initState
    super.initState();
    list_data = List();

    readData();
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache player = AudioCache();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('운전스타일'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => mainmenu()));
          },
        ),
      ),
      body: new GestureDetector(
        child: new Container(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new SizedBox(
                    height: 230, child: Image.asset('images/image1.jpg')),
                new SizedBox(
                    height: 87, child: Image.asset('images/image2.jpg')),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          margin: EdgeInsets.all(5),
                          child: new Text(
                            "통계그래프",
                            style: new TextStyle(
                                fontSize: 12.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w200,
                                fontFamily: "Roboto"),
                          )),
                      new Container(
                        margin: EdgeInsets.all(5),
                        child: new Text(
                          "경고위치",
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: const Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto"),
                        ),
                      ),
                      new ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.blueAccent;
                                return null; // Use the component's default.
                              },
                            ),
                          ) ,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => alarm_config()));
                          },
                          child: new Text(
                            "알림설정",
                            style: new TextStyle(
                                fontSize: 12.0,
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w200,
                                fontFamily: "Roboto"),
                          )),
                    ]),
                new SizedBox(
                    height: 235, child: Image.asset('images/image3.jpg'))
              ]),
          padding: const EdgeInsets.all(0.0),
          alignment: Alignment.center,
        ),
        onTap: () {
          var padding = const EdgeInsets.only(top: 100.0);
          if (position.compareTo('상단') == 0) {
            padding = const EdgeInsets.only(top: 100.0);
          } else if (position.compareTo('중앙') == 0) {
            padding = const EdgeInsets.only(top: 270.0);
          } else if (position.compareTo('하단') == 0) {
            padding = const EdgeInsets.only(top: 500.0);
          }

          if (is_Check == true) {
            for (final item in list_data)
              if (item.status == 1) {
                print("급감속 주의-----------------------");

                //List<String> caution = ['급가속 주의', '급감속 주의', '급회전 주의'];
                //int random = Random().nextInt(3);
                if (sound == true) {
                  player.play('../audio/alert.wav');
                }
                if (vibration == true) {
                  Vibration.vibrate(duration: 3000, pattern: [500, 1000, 2000]);
                }
                showDialog(
                    context: context,
                    //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.pop(context);
                      });

                      return SingleChildScrollView(
                          child: Padding(
                              padding: padding,
                              child: AlertDialog(
                                // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                //Dialog Main Title
                                title: Column(
                                  children: <Widget>[
                                    new Text("급감속 주의"),
                                  ],
                                ),
                                actions: <Widget>[],
                              )));
                    });//show dialog end
              } //if item.status==1 end
          }//if is_Check end
        }, //on tap end
      ),
    );
  }

  readData() async {
    await DefaultAssetBundle.of(context)
        .loadString("assets/result.json")
        .then((s) {
      setState(() {
        var response = json.decode(s);
        List<dynamic> list_status = response["status"];
        // List<dynamic> list_english = response['result']['status'];

        for (int i = 0; i < list_status.length; i++) {
          list_data.add(Data(list_status[i]));
        }
      });
    }).catchError((error) {
      print(error);
    });
  }
}
