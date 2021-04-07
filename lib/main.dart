import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(
      MaterialApp(
        home: new Home(),
        debugShowCheckedModeBanner: false,
      ),
    );

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future getUserData() async {
    var respons = await http.get(
      Uri.https("jsonplaceholder.typicode.com", "users"),
    );
    var jsonData = jsonDecode(respons.body);
    List<User> users = [];
    for (var u in jsonData) {
      User user = User(u["name"], u["username"], u["email"]);
      users.add(user);
    }
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text("HTTP Requests"),
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text("Loading..."),
                    ),
                  );
                } else
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 13,
                        child: ListTile(
                          title: Text(snapshot.data[index].name),
                          subtitle: Text(snapshot.data[index].username),
                          trailing: Text(snapshot.data[index].email),
                        ),
                      );
                    },
                  );
              }),
        ),
      ),
    );
  }
}

class User {
  final String name, username, email;
  User(this.name, this.username, this.email);
}
