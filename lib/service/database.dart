import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addPlaceDetails(Map<String, dynamic> todoinfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Todo_Tasks')
        .doc(id)
        .set(todoinfoMap);
  }
  
  Future<Stream<QuerySnapshot>> getTodoList() async{
    return await FirebaseFirestore.instance.collection("Todo_Tasks").snapshots();
  }

  Future updateDetails(String id, Map<String, dynamic> updateinfoMap) async {
    return await FirebaseFirestore.instance.collection("Todo_Tasks").doc(id).update(updateinfoMap);
  }

  Future deleteDetails(String id) async {
    return await FirebaseFirestore.instance.collection("Todo_Tasks").doc(id).delete();
  }
}
