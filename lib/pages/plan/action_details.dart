import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionDetailsPage extends StatefulWidget {
  ActionDetailsPage({Key key, this.actionData}) : super(key: key);
  final actionData;
  @override
  _ActionDetailsPageState createState() => _ActionDetailsPageState();
}

_launchURL(url) async {
  // const url = 'https://static1.keepcdn.com/chaos/0728/B058C062_main_s.mp4';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _ActionDetailsPageState extends State<ActionDetailsPage> {
  @override
  Widget build(BuildContext context) {
    print( widget.actionData);
    var actionData = widget.actionData;
    return Scaffold(
        appBar: AppBar(
          title: Text('动作详情'),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0), //容器外填充
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      width: 80,
                      child: Text(
                        '动作名：',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          height: 1.2,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      )),
                  Text(
                    '跑步',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                      width: 80,
                      child: Text(
                        '动作类型：',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      )),
                  Text(
                    '按时间和距离计数',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    child: Text(
                      '动作图：',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
              // Image(image: AssetImage('assets/run.png')),
              Image(image: NetworkImage(actionData['ActionImgURL'])),
              Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    child: Text(
                      '动作视频：',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      '查看',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        // fontSize: 16.0,
                        // fontWeight: FontWeight.w400,
                        // decoration: TextDecoration.none,
                      ),
                    ),
                    onPressed: () {
                      _launchURL(actionData['ActionVideoURL']);
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    child: Text(
                      '动作描述：',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '慢跑（英语：Jogging或称Footing），亦称为缓步、缓跑或缓步跑，是一种中等强度的有氧运动，目的在以较慢或中等的节奏来跑完一段相对较长的距离，以达到热身或锻炼的目的。',
                      // softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    child: Text(
                      '更多知识：',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      '查看',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        // fontSize: 16.0,
                        // fontWeight: FontWeight.w400,
                        // decoration: TextDecoration.none,
                      ),
                    ),
                    onPressed: () {
                      _launchURL(actionData['ActionMoreURL']);
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
