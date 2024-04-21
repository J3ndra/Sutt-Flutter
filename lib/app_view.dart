import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sutt/blocs/authentication/authentication_bloc.dart';
import 'package:sutt/blocs/sign_in/sign_in_bloc.dart';
import 'package:sutt/blocs/user/user_bloc.dart';
import 'package:sutt/screens/screens.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sutt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SignInBloc(
                      myUserRepository:
                          context.read<AuthenticationBloc>().userRepository),
                ),
                BlocProvider(
                  create: (context) => UserBloc(
                      myUserRepository:
                          context.read<AuthenticationBloc>().userRepository)
                    ..add(
                      GetUser(
                        context.read<AuthenticationBloc>().state.user!.uid,
                      ),
                    ),
                ),
              ],
              child: const HomeScreen(),
            );
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
