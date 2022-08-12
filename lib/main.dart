import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webw_task/cubit/myapp_cubit.dart';
import 'package:webw_task/presentation/details_screen.dart';
import 'package:webw_task/presentation/signup_screen.dart';
import 'package:webw_task/presentation/start_shipment_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: BlocProvider(
        create: (context) => MyappCubit(),
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BlocProvider(
                  create: (context) => MyappCubit(),
                  child: const DetailsScreen());
            }
            return BlocProvider(
              create: (context) => MyappCubit(),
              child: const SignupScreen(),
            );
          },
        ),
      ),
    );
  }
}
