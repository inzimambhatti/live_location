import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:live_location/app/modules/home/views/components/tom_tom_map.dart';

import '../controllers/home_controller.dart';
import 'components/mymap.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Location Tracker'),
        actions: [
          IconButton(onPressed: () async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection = instance.collection('location');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
    batch.delete(doc.reference);
    }
    await batch.commit();
    Get.snackbar(

        "Deleted", "location history removed",
    );
          }, icon: Icon(CupertinoIcons.arrow_2_circlepath))
        ],
        centerTitle: true,
      ),
      body: GetBuilder<HomeController>(
        builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                ElevatedButton(onPressed: (){controller.getLocation();}, child: Text("Add Location")),
                ElevatedButton(onPressed: (){controller.listenLocation();}, child: Text("Enable Live Location")),
                ElevatedButton(onPressed: (){controller.stopListening();}, child: Text("Stop Location")),
                Expanded(
                    child: StreamBuilder(
                      stream:
                      FirebaseFirestore.instance.collection('location').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title:
                                Text(snapshot.data!.docs[index]['name'].toString()),
                                subtitle: Row(
                                  children: [
                                    Text(snapshot.data!.docs[index]['latitude']
                                        .toString()),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(snapshot.data!.docs[index]['longitude']
                                        .toString()),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.directions),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            TomTomMap(snapshot.data!.docs[index].id)));
                                  },
                                ),
                              );
                            });
                      },
                    )),
              ],
            ),
          );
        }
      ),
    );
  }
}
