import 'package:app_part/UI/auth/login_screen.dart';
import 'package:app_part/utils/utils.dart';
import 'package:app_part/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //it basically provides us APIs to connect to firebase, so here we created an instance of firebaseauth
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signup() {
    setState(() {
      loading = true;
    });

    auth.createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
            setState(() {
              loading = false;
            });
      Utils().registerMessage('Registration Successful');
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
        // used for > symbol shown in appbar by default
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: 'Name', prefixIcon: Icon(Icons.person)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.password_outlined)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'password is required';
                      }
                      return null;
                    },
                  ),
                ]),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                  title: 'Register',
                  loading: loading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      signup();
                    }
                  }),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text('Login'))
                ],
              )
            ]),
      ),
    );
  }
}
