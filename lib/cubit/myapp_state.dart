part of 'myapp_cubit.dart';

@immutable
abstract class MyappState {}

class MyappInitial extends MyappState {}

class Loading extends MyappState {}

class UserAuthinticated extends MyappState {}

class UserSignedOut extends MyappState {}

class DetailAddedToDatabase extends MyappState {}

class ShipmentAddedToDatabase extends MyappState {}

class AppGetCurrentLocation extends MyappState {}
