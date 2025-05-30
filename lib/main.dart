import 'package:flutter/material.dart';
import 'package:tap2025/screens/challenge_screen.dart';
import 'package:tap2025/screens/dashboard_screen.dart';
import 'package:tap2025/screens/detail_popular_movie.dart';
import 'package:tap2025/screens/login_screen.dart';
import 'package:tap2025/utils/global_values.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ValueListenableBuilder(
      valueListenable: GlobalValues.themeMode,
      builder: (context, value, widget) {
        return MaterialApp(
          theme: value == 1 ? ThemeData.light() : ThemeData.dark(),
          home: const LoginScreen(),
          routes: {
            "/dash" : (context) => const DashboardScreen(),
            "/reto" : (context) => const ChallengeScreen(),
            "/api" : (context) => const ChallengeScreen(),
            "/detail" : (context) => const DetailPopularMovie()
          },
        );
      }
    );
  }
}

/*
Anotaciones 02.mayo.2025 (Mi cumpleaños <3)
Parámetros nombrados: son una característica que permite especificar valores para parámetros de funciones, procedimientos o consultas 
de manera explícita, utilizando sus nombres en lugar de depender exclusivamente de su orden. Esto mejora la claridad del código y 
facilita la lectura, especialmente cuando hay múltiples parámetros.
Parámetros posicionales: son aquellos cuyo valor se asigna en función de su posición dentro de una llamada a función, procedimiento o 
consulta. Es decir, el orden en el que pasas los argumentos es crucial para que se interpreten correctamente. No se pueden mover, pues
llevan un orden.
Map en Java es una estructura de datos que funciona como un arreglo asociativo, lo que significa que almacena valores asociados a 
claves únicas. En lugar de acceder a elementos por posición, como en un arreglo tradicional, en un Map accedes a los valores utilizando 
una clave específica.


Anotaciones 14.mayo.2025
Generalmente los arreglos son indexados.

*/