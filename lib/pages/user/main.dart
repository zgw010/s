import 'package:flutter/material.dart';
import '../../model.dart';
import './login.dart';
import './register.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  deleteUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userInfo', '{}');
    context.read<UserInfoModel>().updateUserInfo('{}');
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0), //容器外填充
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20.0), //容器外填充
            child: Text(
              '用户信息',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                height: 1.2,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                  width: 80,
                  child: Text(
                    '用户名：',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      height: 1.2,
                      fontWeight: FontWeight.w400,
                      // fontFamily: "Courier",
                      // background: new Paint()..color = Colors.white,
                      decoration: TextDecoration.none,
                      // decorationStyle: TextDecorationStyle.dashed
                    ),
                  )),
              Text(
                context.watch<UserInfoModel>().userInfo['UserName'] ?? '',
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
                    '生日：',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  )),
              Text(
                context.watch<UserInfoModel>().userInfo['UserDateOfBirth'] ??
                    '',
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
                    '身高：',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  )),
              Text(
                context.watch<UserInfoModel>().userInfo['UserHeight'] ?? '',
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
                  '体重',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Text(
                context.watch<UserInfoModel>().userInfo['UserWeight'] ?? '',
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
                  '性别：',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Text(
                context.watch<UserInfoModel>().userInfo['UserSex'] ?? '',
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
                  '目标：',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Text(
                context.watch<UserInfoModel>().userInfo['UserAims'] ?? '',
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
                  '个人简介：',
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
                  context.watch<UserInfoModel>().userInfo['UserDetails'] ?? '',
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
          ButtonBar(
            children: <Widget>[
              !(context.watch<UserInfoModel>().userInfo['UserName'] == '' ||
                      context.watch<UserInfoModel>().userInfo['UserName'] ==
                          null)
                  ? FlatButton(
                      textColor: Colors.red,
                      child: Text('退出'),
                      onPressed: () {
                        deleteUserInfo();
                      },
                    )
                  : Text(''),
              !(context.watch<UserInfoModel>().userInfo['UserName'] == '' ||
                      context.watch<UserInfoModel>().userInfo['UserName'] ==
                          null)
                  ? FlatButton(
                      child: Text('编辑'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Register(type: 'edit')),
                        );
                      },
                    )
                  : Text(''),
              context.watch<UserInfoModel>().userInfo['UserName'] == '' ||
                      context.watch<UserInfoModel>().userInfo['UserName'] ==
                          null
                  ? FlatButton(
                      child: Text('登录'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => LoginPage()),
                        );
                      },
                    )
                  : Text(''),
            ],
          ),
        ],
      ),
    );
  }
}
