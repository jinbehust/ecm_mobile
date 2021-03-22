import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/login_controllers.dart';
import 'home.dart';

// ignore: must_be_immutable
class LoginView extends GetView<LoginController> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginController loginController = LoginController();
  String token = '';
  final _formKey = GlobalKey<FormState>();

  Widget textField(
      TextEditingController controller, String label, bool obscure) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: TextFormField(
          controller: controller,
          obscureText: obscure,
          maxLength: 100,
          validator: (value) {
            if (value.isEmpty) {
              return 'Bắt buộc nhập $label';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none),
        ));
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thông báo"),
          content: Text("Đăng nhập không thành công"),
          actions: <Widget>[
            FlatButton(
              child: Text("Đóng"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _onPressed(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    loginController.doLogin(_usernameController.text, _passwordController.text);
    token = (prefs.getString('token') ?? "");

    if (_formKey.currentState.validate()) {
      if (token != '') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondRoute()),
        );
      } else {
        printInfo(info: "Fail login...");
        _showDialog(context);
      }
    }
  }

  Widget btnFeild(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: RaisedButton(
            onPressed: () {
              _onPressed(context);
            },
            color: Colors.blue,
            child: Text(
              'Đăng nhập',
              style:
                  TextStyle(color: Colors.white, backgroundColor: Colors.blue),
            )));
  }

  Widget header() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              "Đăng nhập",
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "EcoECM",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  Widget space(double height) {
    return SizedBox(
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [Colors.cyan[800], Colors.cyan[800], Colors.cyan[800]]),
          ),
          child: Column(
            children: <Widget>[
              space(80),
              header(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        space(40),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: <Widget>[
                              textField(
                                  _usernameController, "Tên đăng nhập", false),
                              const SizedBox(height: 10.0),
                              textField(_passwordController, "Mật khẩu", true),
                              btnFeild(context),
                            ],
                          ),
                        ),
                        space(40),
                        Text(
                          "Quên mật khẩu?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
