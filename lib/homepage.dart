import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'formpage.dart';

class HomePage extends StatelessWidget {
  final CollectionReference data =
      FirebaseFirestore.instance.collection('items');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CRUD Firebase")),
      body: StreamBuilder<QuerySnapshot>(
        stream: data.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Data masih kosong"));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return ListTile(
              title: Text(doc['name'] ?? '-'),
              subtitle: Text(doc['desc'] ?? '-'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => data.doc(doc.id).delete(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FormPage(
                      id: doc.id,
                      name: doc['name'],
                      desc: doc['desc'],
                    ),
                  ),
                );
              },
            );
          }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormPage()),
          );
        },
      ),
    );
  }
}
