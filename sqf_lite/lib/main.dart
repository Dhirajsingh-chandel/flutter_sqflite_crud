import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:search_demo/producte%20page.dart';
import 'db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Data ListView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Demo',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<User> userList = <User>[];

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshUserList();
  }

  void refreshUserList() async {
    var users = await databaseHelper.getUsers();
    setState(() {
      userList = users;
    });
  }

  void addUser() async {
    User user = User(name: nameController.text, email: emailController.text);
    await databaseHelper.saveUser(user);
    print(databaseHelper.db);
    nameController.clear();
    emailController.clear();
    refreshUserList();
  }

  void updateUser(int id, String name, String email) async {
    User user = User(id: id, name: name, email: email);
    await databaseHelper.updateUser(user);
    refreshUserList();
  }

  void deleteUser(int id) async {
    await databaseHelper.deleteUser(id);
    refreshUserList();
  }

  void editUser(BuildContext context, User user) async {
    nameController.text = user.name!;
    emailController.text = user.email!;
  }



  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter CRUD with Sqflite'),
        ),
        body: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(userList[index].name.toString()),
              subtitle: Text(userList[index].email.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async{

                  editUser(context, userList[index]);

                  await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Edit User'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(hintText: 'Enter Name'),
                          ),
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(hintText: 'Enter Email'),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            nameController.clear();
                            emailController.clear();
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            updateUser(userList[index].id as int, nameController.text, emailController.text);
                            nameController.clear();
                            emailController.clear();
                            Navigator.pop(context);
                          },
                          child: const Text('Update'),
                        ),
                      ],
                    );
                  },
                  );

                },
              ),
              onTap: () {
                setState(() {
                  deleteUser(userList[index].id as int);
                  print(userList[index].id as int);
                });
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Add User'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(hintText: 'Enter Name'),
                        ),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(hintText: 'Enter Email'),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          nameController.clear();
                          emailController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                        addUser();
                        Navigator.pop(context);
                      },
                        child:  const Text("add"),
                      )
                    ]);
              });
        }));
  }
}
