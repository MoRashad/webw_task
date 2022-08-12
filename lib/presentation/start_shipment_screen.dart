import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:webw_task/cubit/myapp_cubit.dart';
import 'package:webw_task/presentation/all_shipments__screen.dart';
import 'package:webw_task/presentation/signup_screen.dart';
import 'package:webw_task/presentation/widgets/botton_widget.dart';
import 'package:webw_task/presentation/widgets/textfield_widget.dart';

class StartShipmentScreen extends StatefulWidget {
  const StartShipmentScreen({Key? key}) : super(key: key);

  @override
  State<StartShipmentScreen> createState() => _StartShipmentScreenState();
}

class _StartShipmentScreenState extends State<StartShipmentScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController shipmentController = TextEditingController();
  LocationData? currentLocation;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MyappCubit>(context).getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add Shipment',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              BlocProvider.of<MyappCubit>(context).signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => MyappCubit(),
                    child: const SignupScreen(),
                  ),
                ),
              );
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
      body: BlocConsumer<MyappCubit, MyappState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AppGetCurrentLocation ||
              state is ShipmentAddedToDatabase ||
              state is DetailAddedToDatabase ||
              state is UserSignedOut) {
            currentLocation = BlocProvider.of<MyappCubit>(context).locationData;
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shipment ID',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      titlecontroller: shipmentController,
                    ),
                    const Spacer(),
                    MybottonWidget(
                        title: 'Add Shipment',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<MyappCubit>(context).addShipment(
                              shipmentController.text,
                              currentLocation!.longitude!,
                              currentLocation!.latitude!,
                            );
                            shipmentController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Shipment Added'),
                              ),
                            );
                          }
                        }),
                    MybottonWidget(
                      title: 'View all shipments',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => MyappCubit(),
                            child: const AllShipmentScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
        },
      ),
    );
  }
}
