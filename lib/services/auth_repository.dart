import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> signinAnon() async {
    try {
      await _firebaseAuth.signInAnonymously();
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .set({
        'userId': _firebaseAuth.currentUser!.uid,
      });

      print(_firebaseAuth.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message.toString());
    }
  }

  Future<void> addNameAndPhoneNumber(
      String name, String number, String date) async {
    try {
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update({
        'name': name,
        'phoneNumber': number,
        'date': date,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addShipment(
      String shipmentId, double longtitude, double latitude) async {
    try {
      await _firestore.collection('shipment').add({
        'userId': _firebaseAuth.currentUser!.uid,
        'shipmentId': shipmentId,
        'longtitude': longtitude,
        'latitude': latitude,
        'timestamp': DateTime.now(),
      });

      print(_firebaseAuth.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message.toString());
    }
  }

  Future<void> updateShipmentLocation(
      StreamSubscription<LocationData>? locationSubscription,
      Location location,
      String documentId) async {
    locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      locationSubscription!.cancel();
      locationSubscription = null;
    }).listen((LocationData currentLocation) async {
      await _firestore.collection('shipment').doc(documentId).update({
        'longtitude': currentLocation.longitude,
        'latitude': currentLocation.latitude,
      });
    });
  }

  Future returnCurrentUser() async {
    return _firebaseAuth.currentUser!.uid;
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
