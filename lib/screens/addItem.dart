import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  Future<void> addItem() async {
    const String url = 'http://10.0.2.2/crudFlutter/addData.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "item_name": nameController.text,
          "price": priceController.text,
          "stock": stockController.text
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        throw Exception("Failed to add item");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add Item"), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Item Name"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: "Stock"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addItem,
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
