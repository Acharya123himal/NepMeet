import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepmeet/repositories/repositories.dart';
import 'cubit/signup_cubit.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = '/signup';
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignUpCubit>(
          create: (_) =>
              SignUpCubit(authRepository: context.read<AuthRepository>()),
          child: SignUpScreen()),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state.status == SignUpStatus.error) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Error"),
                  content: Text(
                    state.failure.message,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Instagram',
                        style: TextStyle(
                          fontFamily: 'Billabong',
                          fontSize: 50.0,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 10.0,
                              ),
                              child: TextFormField(
                                decoration:
                                    InputDecoration(hintText: 'Username'),
                                onChanged: (value) => context
                                    .read<SignUpCubit>()
                                    .usernameChanged(value),
                                validator: (value) => value.trim().isEmpty
                                    ? 'Please enter a valid username.'
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 10.0,
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(hintText: 'Email'),
                                onChanged: (value) => context
                                    .read<SignUpCubit>()
                                    .emailChanged(value),
                                validator: (input) => !input.contains('@')
                                    ? 'Please enter a valid email'
                                    : null,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 10.0,
                              ),
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Password'),
                                onChanged: (value) => context
                                    .read<SignUpCubit>()
                                    .passwordChanged(value),
                                validator: (input) => input.length < 8
                                    ? 'Must be at least 8 characters'
                                    : null,
                                obscureText: true,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              width: 250.0,
                              child: ElevatedButton(
                                onPressed: () => _submitForm(
                                  context,
                                  state.status == SignUpStatus.submitting,
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  padding: EdgeInsets.all(10.0),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              width: 250.0,
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  "Return to Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent,
                                  padding: EdgeInsets.all(10.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<SignUpCubit>().signUpWithCredentials();
    }
  }
}
