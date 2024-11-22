import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeScreen(),
    );
  }
}

class homeScreen extends StatelessWidget {
  Future fetchpost() async {
    final respons =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    if (respons.statusCode == 200) {
      return jsonDecode(respons.body);
    } else {
      throw Exception("Failed to load");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(
              child: Text(
            "Api calling",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
        body: FutureBuilder(
            future: fetchpost(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error "),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text("Not found "),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data![index];
                      return Card(
                        color: Colors.blue[50],
                        child: ListTile(
                            title: Text(post["title"]),
                            subtitle: Text(post["body"])),
                      );
                    });
              }
            }));
  }
}
