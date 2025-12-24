import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPage extends StatefulWidget {
  final String? id;
  final String? name;
  final String? desc;

  const FormPage({this.id, this.name, this.desc, super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  final CollectionReference data =
      FirebaseFirestore.instance.collection('items');

  @override
  void initState() {
    if (widget.id != null) {
      nameCtrl.text = widget.name!;
      descCtrl.text = widget.desc!;
    }
    super.initState();
  }

  void save() {
    if (widget.id == null) {
      data.add({
        'name': nameCtrl.text,
        'desc': descCtrl.text,
      });
    } else {
      data.doc(widget.id).update({
        'name': nameCtrl.text,
        'desc': descCtrl.text,
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Data")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: save,
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
