import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/service/database.dart';
import 'package:random_string/random_string.dart';

class Todo_Page extends StatefulWidget {
  const Todo_Page({super.key});

  @override
  State<Todo_Page> createState() => _Todo_PageState();
}

class _Todo_PageState extends State<Todo_Page> {
  TextEditingController taskController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add Your ",
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "TO",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "DO",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, top: 30, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Task",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: taskController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Description",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String Id = randomAlphaNumeric(10);
                  Map<String, dynamic> todoinfoMap = {
                    "Task": taskController.text,
                    "Description": descriptionController.text,
                    "Id": Id,
                  };
                  await DatabaseMethods().addPlaceDetails(todoinfoMap, Id).then(
                      (value) => Fluttertoast.showToast(
                          msg: "Task has been  added Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0));
                  Navigator.pop(context);
                },
                child: const Text(
                  "Add Task",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, height: 3),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
