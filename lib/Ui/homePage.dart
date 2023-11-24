import 'dart:math';

import 'package:crud_app_sqlite/model/toDoModel.dart';
import 'package:crud_app_sqlite/sqlite/databaseHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  int? _id;

  bool isLoading = false;

  Random _random = Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "Enter Title", border: OutlineInputBorder()),
              controller: _titleController,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: "Enter Title", border: OutlineInputBorder()),
              controller: _descriptionController,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child:isLoading?CircularProgressIndicator(): ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal),
                      onPressed: () async{
                        setState(() {
                          isLoading=true;
                        });
                        //PASSING INPUT TO TODO_MODEL
                        final todo = TodoModel(
                          id: _random.nextInt(100),
                          title: _titleController.text,
                          description: _descriptionController.text,
                        );
                        await DataBaseHelper.instant.addTodos(todo);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: const Text("ADD",style: TextStyle(color: Colors.white))),
                ),
               
                Expanded(
                  child: isLoading? CircularProgressIndicator(): ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal),
                      onPressed: ()async {
                        setState(() {
                          isLoading = true;
                        });
                      final todo=TodoModel(
                        id: _id,
                        title: _titleController.text,
                        description:_descriptionController.text
                      );
                        await DataBaseHelper.instant.updateTodo(todo);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: const Text("UPADTE",style: TextStyle(color: Colors.white),)),
                ),
                
              ],
            ),
            Divider(thickness: 3,),


            Expanded(child: FutureBuilder(
              future: DataBaseHelper.instant.getTodos(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {

                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                return snapshot.data!.isEmpty? Text("No data found"):ListView(
                  children: snapshot.data!.map((TodoModel todo){
                        return ListTile(
                          leading: IconButton(icon: Icon(Icons.edit),onPressed: (){
                            setState(() {
                              _id = todo.id!;
                              _titleController.text = todo.title!;
                              _descriptionController.text = todo.description!;
                            });
                          },),
                          title: Text(todo.title!),
                          subtitle: Text(todo.description!),
                          trailing:isLoading? CircularProgressIndicator(): IconButton(icon: Icon(Icons.delete),onPressed: (){
                            setState(() {
                              isLoading = true;
                            });
                            DataBaseHelper.instant.deleteTodos(todo.id);
                            setState(() {
                              isLoading = false;
                            });
                          },),
                        );
                  }).toList(),
                );
              },
            ),),
          ],
        ),
      ),
    );
  }
}
