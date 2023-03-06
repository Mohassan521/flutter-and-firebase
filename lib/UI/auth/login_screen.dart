import 'package:app_part/UI/auth/login_with_phone.dart';
import 'package:app_part/UI/auth/sign_up.dart';
import 'package:app_part/UI/forgot_password.dart';
import 'package:app_part/UI/posts/post_screen.dart';
import 'package:app_part/utils/utils.dart';
import 'package:app_part/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  final _auth = FirebaseAuth.instance;

  //when this screen will disappear, it will release all the information present in the memory
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });

    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      Utils().registerMessage('Login successfull');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PostScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Login Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              hintText: 'Email or Phone',
                              prefixIcon: Icon(Icons.email)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.password)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
                const SizedBox(height: 30),
                RoundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
                Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                  }, 
                  child: Text('Forgot Password?')
                  )
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Dont have an account"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: Text('Sign Up'))
                  ],
                ),
                const SizedBox(
                  height: 30,
                )
              ]),
        ));
  }
}
