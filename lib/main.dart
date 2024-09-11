import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  // Verificar si el dispositivo tiene biometría disponible
  Future<void> _checkBiometrics() async {
    try {
      _canCheckBiometrics = await auth.canCheckBiometrics;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  // Método para autenticar al usuario
  Future<void> _authenticate() async {
    try {
      _isAuthenticated = await auth.authenticate(
        localizedReason: 'Por favor, autentícate para acceder',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
      setState(() {});
      // Si la autenticación es exitosa, espera 5 segundos y navega a la pantalla de éxito
      if (_isAuthenticated) {
        Future.delayed(Duration(seconds: 5), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SuccessScreen()),
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Agregamos el AppBar para mostrar el título en la parte superior
      appBar: AppBar(
        title: Text('LuisMi App Login'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          // Fondo degradado
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blueAccent.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Contenido principal
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icono de autenticación
                      Icon(
                        Icons.fingerprint,
                        size: 100,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(height: 20),
                      // Mensaje de estado
                      Text(
                        _isAuthenticated
                            ? 'Autenticación exitosa'
                            : 'Por favor, inicia sesión',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isAuthenticated
                              ? Colors.green
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Botón de inicio de sesión
                      ElevatedButton(
                        onPressed: _canCheckBiometrics ? _authenticate : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Pantalla de éxito que se muestra después de la autenticación
class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Text(
          'Autenticación Exitosa',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}