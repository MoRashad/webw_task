import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webw_task/cubit/myapp_cubit.dart';
import 'package:webw_task/presentation/details_screen.dart';
import 'package:webw_task/presentation/widgets/botton_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Sign in',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocListener<MyappCubit, MyappState>(
          listener: (context, state) {
            if (state is UserAuthinticated) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => MyappCubit(),
                            child: const DetailsScreen(),
                          )));
            }
          },
          child: MybottonWidget(
              title: 'SignIn Anonumosly',
              onTap: () {
                BlocProvider.of<MyappCubit>(context).signIn();
              })),
    );
  }
}
