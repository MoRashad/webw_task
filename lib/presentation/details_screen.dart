import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webw_task/cubit/myapp_cubit.dart';
import 'package:webw_task/presentation/start_shipment_screen.dart';
import 'package:webw_task/presentation/widgets/botton_widget.dart';
import 'package:webw_task/presentation/widgets/textfield_widget.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<MyappCubit>(context).addNameAndPhoneNumber(
          nameController.text.trim(),
          phoneController.text,
          DateTime.now().toString());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => MyappCubit(),
            child: const StartShipmentScreen(),
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('processing data'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextFieldWidget(
                titlecontroller: nameController,
              ),
              const SizedBox(height: 25),
              const Text(
                'Phone number',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextFieldWidget(
                titlecontroller: phoneController,
                isNumbers: true,
              ),
              const Spacer(),
              MybottonWidget(title: 'Submit', onTap: validateAndSubmit),
            ],
          ),
        ),
      ),
    );
  }
}
