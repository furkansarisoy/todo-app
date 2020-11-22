import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/auth.dart';
import 'package:todo_app/utils/decoration.dart';
import 'package:todo_app/utils/validation.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

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
          padding: EdgeInsets.only(top: 150),
          physics: ScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 32.0),
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
                        ],
                      )),
                  _submit(),
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
          hintText: 'Kayıtlı olan e-mail adresinizi giriniz.'),
    );
  }

  Widget _submit() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width * 0.40,
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            context
                .read<AuthenticationService>()
                .resetPassword(email: _emailController.text.trim())
                .then((value) {
              Navigator.pop(context);
            }).catchError((error) {
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
          "Şifremi Sıfırla",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
