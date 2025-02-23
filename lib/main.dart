import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> getData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2/crudFlutter/getData.php'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) ?? [];
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Store"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          } else {
            return ItemList(list: snapshot.data!);
          }
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List<dynamic> list;

  const ItemList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(list[i]["item_name"] ?? "No name"),
          subtitle: Text("Price: ${list[i]["price"]}"),
        );
      },
    );
  }
}
