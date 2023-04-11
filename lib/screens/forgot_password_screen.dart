import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  static const id = 'forgot_password_screen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
                controller: _emailController,
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 40),
                    maximumSize: const Size(200, 40)),
                onPressed: () async {
                  _formKey.currentState!.validate();

                  var snackbar = SnackBar(
                    content: Text('Check your email'),
                    backgroundColor: Colors.green,
                    duration: Duration(microseconds: 400),
                  );

                  var snackbar2 = SnackBar(
                    content: Text('Something went wrong :('),
                    backgroundColor: Colors.red,
                    duration: Duration(microseconds: 400),
                  );

                  auth
                      .sendPasswordResetEmail(
                          email: _emailController.text.trim())
                      .then((value) =>
                          ScaffoldMessenger.of(context).showSnackBar(snackbar))
                      .onError((error, stackTrace) =>
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackbar2));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.mail_outline),
                    SizedBox(width: 10),
                    Text("Reset Password")
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
