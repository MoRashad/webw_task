import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webw_task/cubit/myapp_cubit.dart';
import 'package:webw_task/presentation/map_screen.dart';

class AllShipmentScreen extends StatefulWidget {
  const AllShipmentScreen({Key? key}) : super(key: key);

  @override
  State<AllShipmentScreen> createState() => _AllShipmentScreenState();
}

class _AllShipmentScreenState extends State<AllShipmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            title: const Text(
              'all shipments',
              style: TextStyle(color: Colors.black),
            )),
        body: StreamBuilder(
          stream: BlocProvider.of<MyappCubit>(context).shipmentStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              );
            }

            return ListView(
              children:
                  snapshot.data!.docs.map<Widget>((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: () {
                      if (data['userId'] ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        BlocProvider.of<MyappCubit>(context)
                            .updateShipmentLocation(document.id);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => MyappCubit(),
                            child: MapsScreen(
                              documentId: document.id,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        title: Text('Shipment id:  ${data['shipmentId']}'),
                        subtitle: Text(
                          data['timestamp']
                              .toDate()
                              .toString()
                              .substring(0, 16),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_sharp),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ));
  }
}
