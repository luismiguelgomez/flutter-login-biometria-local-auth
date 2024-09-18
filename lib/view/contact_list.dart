import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../model/contact.dart'; // Asegúrate de que esta ruta sea correcta
import '../persistence/db_helper.dart';
import '../persistence/backend_helper.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
          onPrimary: Colors.white,
          secondary: Colors.deepPurpleAccent,
          onSecondary: Colors.white,
        ),
        useMaterial3: true,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          bodyLarge: TextStyle(color: Colors.deepPurple[700]),
          bodyMedium: TextStyle(color: Colors.deepPurpleAccent),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.all(16),
          style: ListTileStyle.list,
        ),
      ),
      home: const ContactListWidget(title: 'Contact List'),
    );
  }
}

class ContactListWidget extends StatefulWidget {
  const ContactListWidget({super.key, required this.title});

  final String title;

  @override
  State<ContactListWidget> createState() => _ContactListWidgetState();
}

class _ContactListWidgetState extends State<ContactListWidget> {
  Logger logger = Logger();
  List<Contact>? contacts = []; // Asegúrate de que el tipo Contact esté definido

  Future<void> loadAllContacts() async {
    ContactProvider conProv = ContactProvider();
    await conProv.open("ContactsDB");

    // Obtener todos los contactos como una lista de dinámicos
    List<dynamic> contactList = await conProv.getAllContacts() ?? [];

    // Convertir la lista de dinámicos a una lista de Map<String, Object?>
    List<Map<String, Object?>> contactMaps = contactList.cast<Map<String, Object?>>();

    // Convertir cada mapa en un objeto Contact
    contacts = contactMaps.map((map) => Contact.fromMap(map)).cast<Contact>().toList();
    
    await conProv.close();

    logger.i("LOAD CONTACTS FINISH.");

    setState(() {});
  }

  Future<void> backupContacts() async {
    var snackBar = const SnackBar(
      content: Text('Contacts backed up successfully.'),
    );
    BackendHelper.sendData(json.encode(contacts)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  void initState() {
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
          ),
        ],
      ),
      body: contacts!.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: contacts?.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      contacts![index].name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      '${contacts![index].phone}\n${contacts![index].email}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
