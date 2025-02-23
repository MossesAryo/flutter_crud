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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> fetchData() async {
    const String url = 'http://10.0.2.2/crudFlutter/getData.php';
    
    try {
      final response = await http.get(Uri.parse(url));

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
      appBar: AppBar(title: const Text("My Store")),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty)
                ? const Center(child: Text("No data available"))
                : ItemList(items: snapshot.data!),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List<dynamic> items;

  const ItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item["item_name"] ?? "No name"),
          subtitle: Text("Price: ${item["price"]}"),
        );
      },
    );
  }
}
