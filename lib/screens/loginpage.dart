import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/forgetPassword.dart';
import 'package:todo_app/screens/signup.dart';
import 'package:todo_app/services/auth.dart';
import 'package:todo_app/utils/decoration.dart';
import 'package:todo_app/utils/validation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _showSnack(error) {
    final snackBar = SnackBar(
      content: Text(error),
      backgroundColor: Colors.red,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 100),
          physics: ScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("todo'",
                      style: GoogleFonts.secularOne(
                        color: Theme.of(context).primaryColor,
                        fontSize: 60,
                      )),
                  Container(
                      margin: EdgeInsets.all(6),
                      padding: EdgeInsets.only(top: 6, bottom: 6),
                      alignment: Alignment.center,
                      decoration: kBoxDecorationStyle(),
                      child: Column(
                        children: [
                          _mailTextField(),
                          Divider(),
                          _passTextField()
                        ],
                      )),
                  _passForget(),
                  _loginButton(),
                  _singUp(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _mailTextField() {
    return TextFormField(
      validator: (value) {
        if (!validateEmail(value)) {
          return 'Lütfen geçerli bir e-mail adresi giriniz';
        }
        return null;
      },
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.blueGrey),
      decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(14.0),
          prefixIcon: Icon(
            Icons.alternate_email,
            color: Colors.grey,
          ),
          hintText: 'E-Mail'),
    );
  }

  Widget _passTextField() {
    return TextFormField(
      validator: (value) {
        if (value.length < 6) {
          return 'Şifreniz 6 karakterden büyük olmalıdır';
        }
        return null;
      },
      controller: _passwordController,
      obscureText: true,
      style: TextStyle(
        color: Colors.blueGrey,
      ),
      decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(14.0),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
          hintText: 'Şifre'),
    );
  }

  Widget _passForget() {
    return Container(
        alignment: Alignment.centerRight,
        child: FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ForgetPassword()));
            },
            child: Text(
              "şifremi unuttum",
              style: TextStyle(color: Colors.grey),
            )));
  }

  Widget _loginButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width * 0.40,
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            context
                .read<AuthenticationService>()
                .signIn(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim())
                .catchError((error) {
              _showSnack(error);
            });
          }
        },
        elevation: 2.0,
        padding: EdgeInsets.all(20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Theme.of(context).primaryColor,
        child: Text(
          "Giriş Yap",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _singUp() {
    return Container(
        child: RichText(
            text: TextSpan(
                text: "Hesabın yok mu ? ",
                style: TextStyle(color: Colors.grey),
                children: [
          TextSpan(
              text: "Kayıt Ol",
              style: TextStyle(color: Colors.black),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ));
                })
        ])));
  }
}
