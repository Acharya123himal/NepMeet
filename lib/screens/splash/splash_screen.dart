import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepmeet/blocs/blocs.dart';
import 'package:nepmeet/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print(state);
          if (state.status == AuthStatus.unauthenticated) {
            //open login screen
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          } else if (state.status == AuthStatus.authenticated) {
            //open navigation screen
            
            Navigator.of(context).pushNamed(NavScreen.routeName);
          }
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
