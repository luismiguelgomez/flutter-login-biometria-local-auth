import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../model/contact.dart';
import '../persistence/db_helper.dart';
import 'contact_list.dart';
import '../model/contact_card_screen.dart'; // Asegúrate de que este import sea correcto

class NewContact extends StatelessWidget {
  const NewContact({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          primary: Colors.blueAccent,
          onPrimary: Colors.white,
          background: Colors.blueAccent,
          onBackground: Colors.white,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: Colors.blueAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      home: const NewContactWidget(title: 'Simple Agenda'),
    );
  }
}

class NewContactWidget extends StatefulWidget {
  const NewContactWidget({super.key, required this.title});

  final String title;

  @override
  State<NewContactWidget> createState() => _NewContactWidgetState();
}

class _NewContactWidgetState extends State<NewContactWidget> {
  Logger logger = Logger();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> addContactHandler() async {
    Contact ctct = Contact(
      id: 0,
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
    );

    var snackBar = const SnackBar(
      content: Text('Contacto registrado exitosamente.'),
    );

    ContactProvider conProv = ContactProvider();
    await conProv.open("ContactsDB");
    conProv.insert(ctct).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactCardScreen(contact: ctct),
        ),
      );
    });

    conProv.close();
  }

  void viewContactListHandler() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 250,
              child: TextField(
                controller: nameController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            const VerticalDivider(),
            SizedBox(
              width: 250,
              child: TextField(
                controller: phoneController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone',
                ),
              ),
            ),
            const VerticalDivider(),
            SizedBox(
              width: 250,
              child: TextField(
                controller: emailController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'eMail',
                ),
              ),
            ),
            const VerticalDivider(),
            TextButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.green),
              ),
              onPressed: addContactHandler,
              child: const Text('Save contact'),
            ),
            TextButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.green),
              ),
              onPressed: addContactHandler,
              child: const Text('Contact QR'),
            ),
            const VerticalDivider(),
            TextButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.green),
              ),
              onPressed: viewContactListHandler,
              child: const Text('View Contact List'),
            ),
            const VerticalDivider(),
            TextButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(255, 241, 241, 241)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactCardScreen(
                      contact: Contact(
                        id: 0,
                        name: nameController.text,
                        phone: phoneController.text,
                        email: emailController.text,
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Scan Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
