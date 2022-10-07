import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:location/location.dart'as loc;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
class HomeController extends GetxController {
  //TODO: Implement HomeController
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc("user 1").set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': 'TEST USER'
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
    Get.snackbar(

      "Success", "Location added",backgroundColor: Colors.teal
    );
  }
  Future<void> listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();

        _locationSubscription = null;
      update();
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc("user 1").set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': 'TEST USER'
      }, SetOptions(merge: true));
    });
    update();
    Get.snackbar(

        "Success", "You will be tracked now",backgroundColor: Colors.teal
    );
  }

  stopListening() {
    _locationSubscription?.cancel();

      _locationSubscription = null;
    Get.snackbar(
        "Success", "Live tracking is off",backgroundColor: Colors.teal
    );
   update();

  }

  requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

















  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {

    super.onClose();
  }


}
