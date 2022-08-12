import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webw_task/cubit/myapp_cubit.dart';

// ignore: must_be_immutable
class MapsScreen extends StatefulWidget {
  MapsScreen({required this.documentId, Key? key}) : super(key: key);
  String documentId;
  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController _controller;
  bool added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            BlocProvider.of<MyappCubit>(context).stopUpdatingLocation;
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.documentId,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: StreamBuilder(
        stream: BlocProvider.of<MyappCubit>(context).shipmentStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (added) {
            moveMapWithshipment(snapshot);
            // BlocProvider.of<MyappCubit>(context)
            //     .updateShipmentLocation(widget.documentId);
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          print(snapshot.data!.docs.singleWhere(
              (element) => element.id == widget.documentId)['longtitude']);
          return GoogleMap(
            mapType: MapType.normal,
            markers: {
              Marker(
                position: LatLng(
                  snapshot.data!.docs.singleWhere(
                      (element) => element.id == widget.documentId)['latitude'],
                  snapshot.data!.docs.singleWhere((element) =>
                      element.id == widget.documentId)['longtitude'],
                ),
                markerId: const MarkerId('id'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueMagenta),
              )
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.documentId)['latitude'],
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.documentId)['longtitude'],
              ),
              zoom: 14.5,
            ),
            onMapCreated: (controller) {
              setState(() {
                _controller = controller;
                added = true;
              });
            },
          );
        },
      ),
    );
  }

  Future<void> moveMapWithshipment(
      AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            snapshot.data!.docs.singleWhere(
                (element) => element.id == widget.documentId)['latitude'],
            snapshot.data!.docs.singleWhere(
                (element) => element.id == widget.documentId)['longtitude'],
          ),
          zoom: 17,
        ),
      ),
    );
  }
}
