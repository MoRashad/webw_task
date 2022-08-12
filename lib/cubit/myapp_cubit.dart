import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:webw_task/services/auth_repository.dart';

part 'myapp_state.dart';

class MyappCubit extends Cubit<MyappState> {
  MyappCubit() : super(MyappInitial());

  final AuthRepository authRepository = AuthRepository();
  final Stream<QuerySnapshot> shipmentStream = FirebaseFirestore.instance
      .collection('shipment')
      .orderBy('timestamp', descending: true)
      .snapshots();

  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  late LocationData locationData;
  StreamSubscription<LocationData>? locationSubscription;

  late final userId;
  void signIn() async {
    emit(Loading());
    try {
      await authRepository.signinAnon();
      userId = authRepository.returnCurrentUser();
      emit(UserAuthinticated());
    } catch (e) {
      throw Exception(e);
    }
  }

  void addNameAndPhoneNumber(String name, String number, String date) async {
    emit(Loading());
    try {
      authRepository.addNameAndPhoneNumber(name, number, date);
      emit(DetailAddedToDatabase());
    } catch (e) {
      throw Exception(e);
    }
  }

  void addShipment(
      String shipmentId, double longtitude, double latitude) async {
    emit(Loading());
    try {
      await authRepository.addShipment(shipmentId, longtitude, latitude);
      emit(ShipmentAddedToDatabase());
    } catch (e) {
      throw Exception(e);
    }
  }

  void signOut() async {
    emit(Loading());
    try {
      await authRepository.signOut();
      emit(UserSignedOut());
    } catch (e) {
      throw Exception(e);
    }
  }

  void getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return Future.error('Location services are disabled.');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Location permissions are denied');
      }
    }

    locationData = await location.getLocation();

    emit(AppGetCurrentLocation());
  }

  void updateShipmentLocation(String documentId) async {
    try {
      await authRepository.updateShipmentLocation(
          locationSubscription, location, documentId);
    } catch (e) {
      throw Exception(e);
    }
  }

  void stopUpdatingLocation() {
    locationSubscription!.cancel();
    locationSubscription = null;
  }
}
