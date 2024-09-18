import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../persistence/db_helper.dart';
import '../persistence/backend_helper.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ContactListWidget(title: 'Simple Agenda'),
    );
  }
}

class ContactListWidget extends StatefulWidget {
  const ContactListWidget({super.key, required this.title});

  final String title;

  @override
  State<ContactListWidget> createState() {
    return _ContactListWidgetState();
  }
}

class _ContactListWidgetState extends State<ContactListWidget> {
  Logger logger = Logger();
  List? contacts = [];

  Future<void> loadAllContacts() async {
    ContactProvider conProv = ContactProvider();
    await conProv.open("ContactsDB");
    contacts = (await conProv.getAllContacts())!;
    await conProv.close();

    logger.i("LOAD CONTACTS FINISH.");

    setState(() {});
  }

  Future<void> backupContacts() async {
    var snackBar = const SnackBar(
      content: Text('Contacto registrado exitosamente.'),
    );
    BackendHelper.sendData(json.encode(contacts)).then((value) => {
          ScaffoldMessenger.of(context).showSnackBar(snackBar),
        });
  }

  @override
  initState() {
    super.initState();
    loadAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == '1') {
                backupContacts();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: '1',
                child: Text('Backup Contacts'),
              ),
              const PopupMenuItem(
                value: '2',
                child: Text('Recover Contacts'),
              ),
            ],
          )
        ],
      ),
      body: contacts!.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: contacts?.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${contacts?[index].toString()}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
