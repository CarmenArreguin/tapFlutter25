import 'package:flutter/material.dart';
import 'package:tap2025/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo tipo póster
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://image.tmdb.org/t/p/w500/9cXy0z1jWjswCzDgKOQ0hFz84lT.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),

        //Capa oscura para mejorar contraste
        Container(
          color: Colors.black.withOpacity(0.6),
        ),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/avatar.jpg'),
              ),
              const SizedBox(height: 20),

              // Nombre
              const Text(
                'Carmen Arreguin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                'car252004@gmail.com',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),

              //Botón cerrar sesión
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                onPressed: () => _logout(context),
              )
            ],
          ),
        ),
      ],
    );
  }
}

