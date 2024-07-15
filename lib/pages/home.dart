import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/pages/todo.dart';
import 'package:todo/service/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? todoStream;

  TextEditingController taskController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  getontheload() async{
    todoStream = await  DatabaseMethods().getTodoList();
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getontheload();
    super.initState();
  }

  Widget taskDetails() {
    return StreamBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Task : ${ds["Task"]}",
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    taskController.text = ds["Task"];
                                    descriptionController.text = ds["Description"];
                                    EditTaskDetails(ds["Id"]);
                                  },
                                    child: const Icon(Icons.edit,color: Colors.orange,)),
                                const SizedBox(width: 5,),
                                GestureDetector(
                                  onTap: () async{
                                    await DatabaseMethods().deleteDetails(ds["Id"]);
                                  },
                                    child: const Icon(Icons.delete,color: Colors.orange,)),
                              ],
                            ),
                            Text(
                              "Description : ${ds["Description"]}",
                              style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : CircularProgressIndicator();
      },
      stream: todoStream,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Todo_Page()));
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "TO",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              " - ",
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
        margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            Expanded(child: taskDetails()),
          ],
        ),
      ),
    );
  }

  Future EditTaskDetails(String id) => showDialog(context: context, builder: (context)=> AlertDialog(
    elevation: 4,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.cancel),
            ),
            const SizedBox(width: 60,),
            const Text(
              "Edit",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Task",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),

        const Text("Task",
          style: TextStyle(
            color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0,
          ),),
        Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10)
          ),
          child: TextField(
            controller: taskController,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        const SizedBox(height: 20,),
        const Text("Description",
          style: TextStyle(
            color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0,
          ),),
        const SizedBox(height: 10,),
        Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10)
          ),
          child:  TextField(
            controller: descriptionController,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),

        const SizedBox(height: 30,),

        Center(
          child: ElevatedButton(onPressed: () async{
            Map<String,dynamic> updateinfoMap={
              "Task" : taskController.text,
              "Description" : descriptionController.text,
            };
            await DatabaseMethods().updateDetails(id, updateinfoMap).then((value) {
              Navigator.pop(context);
              Fluttertoast.showToast(
                  msg: "Task has been updated Successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            });
          }, child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Make Changes",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold,),
            ),
          ),),
        )
      ],
    ),
  ));
}
