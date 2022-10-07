import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
class TomTomMap extends StatefulWidget {
  final String user_id;
  const TomTomMap(this.user_id);

  @override
  State<TomTomMap> createState() => _TomTomMapState();
}

class _TomTomMapState extends State<TomTomMap> {
  final loc.Location location = loc.Location();
  bool _added = false;
  final String apiKey = "KXUGANPlq4FvKPDI6Rm0FeJ1ggfX3AxV";
  final tomtomHQ = LatLng(30.1633252, 72.4515188);
var mapController=MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('location').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (_added) {
               // controller.moveAndRotate(LatLng(_latitude, _longitude), zoom, degree)
                mymap(snapshot);
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return Stack(
                children: <Widget>[
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(center: tomtomHQ, zoom:10.0,
                      onMapCreated: (MapController controller) async {
                        setState(() {
                          mapController = controller;
                          _added = true;
                        });

                      },),
                    layers: [
                      TileLayerOptions(
                        urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
                            "{z}/{x}/{y}.png?key={apiKey}",
                        additionalOptions: {"apiKey": apiKey},
                      ),
                      MarkerLayerOptions(
                        markers: [
                          new Marker(
                            width: 80.0,
                            height: 80.0,
                            point: new LatLng( snapshot.data!.docs.singleWhere(
                                    (element) => element.id == widget.user_id)['latitude'],
                              snapshot.data!.docs.singleWhere(
                                      (element) => element.id == widget.user_id)['longitude'],),
                            builder: (BuildContext context) => const Icon(
                                Icons.location_on,
                                size: 60.0,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],

                  ),
                  Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.bottomLeft,
                      child: Image.asset("images/tt_logo.png"))
                ],
              );
            },
          ),
        ));
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
   mapController
        .moveAndRotate(
        LatLng(
          snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
          snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
        ),
        14.47,12);

  }

}