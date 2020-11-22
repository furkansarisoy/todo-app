import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/auth.dart';
import 'package:todo_app/utils/decoration.dart';
import 'package:todo_app/utils/validation.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _showErrorSnack(error) {
    final snackBar = SnackBar(
      content: Text(error),
      backgroundColor: Colors.red,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
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
                  _signUpButton(),
                  _signIn(),
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
          hintText: 'Şifre belirleyiniz'),
    );
  }

  Widget _signUpButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width * 0.40,
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            context
                .read<AuthenticationService>()
                .signUp(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                )
                .then((value) => {Navigator.pop(context)})
                .catchError((error) {
              _showErrorSnack(error);
            });
          }
        },
        elevation: 2.0,
        padding: EdgeInsets.all(20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Theme.of(context).primaryColor,
        child: Text(
          "Kayıt Ol",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _signIn() {
    return Container(
        child: RichText(
            text: TextSpan(
                text: "Hesabınız var mı ? ",
                style: TextStyle(color: Colors.grey),
                children: [
          TextSpan(
              text: "Giriş Yap",
              style: TextStyle(color: Colors.black),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                })
        ])));
  }
}
