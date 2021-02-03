import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/helpers/show_dialog.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/widgets/main_button.dart';

class RegisterPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(
                  title: 'Register',
                ),
                _Form(),
                Labels(
                  question: 'Already have an account?',
                  linkText: 'Login',
                  routeTo: 'login',
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Terms and conditions',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeHolder: 'Name',
            keyboardType: TextInputType.emailAddress,
            textController: nameController,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Password',
            textController: passwordController,
            isPassword: true,
          ),
          MainButton(
            text: 'Register',
            callback: authService.isAuthenticating
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final bool result = await authService.register(
                      nameController.text,
                      emailController.text,
                      passwordController.text,
                    );
                    if (result) {
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      showCustomDialog(
                          context, 'Register Error', authService.authError);
                    }
                  },
          )
        ],
      ),
    );
  }
}
