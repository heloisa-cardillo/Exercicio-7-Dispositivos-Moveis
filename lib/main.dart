import 'package:exercicio_7/telas/tela_compromissos.dart';
import 'package:flutter/material.dart';

const Color azul = Color(0xFF2A49EB);
const Color azulClaro = Color(0xFF3366F0);
const Color fundo = Color(0xFFF5F7FA);
const Color textoEscuro = Color(0xFF1F2937);
const Color texto = Color(0xFF374151);

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Compromissos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: azul, primary: azul),
        scaffoldBackgroundColor: fundo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: textoEscuro,
          surfaceTintColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textoEscuro,
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: textoEscuro,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: texto,
          ),
          bodyMedium: TextStyle(fontSize: 14, color: texto),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 3,
          shadowColor: const Color(0x14000000),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundBuilder: (context, estados, child) {
              final desativado = estados.contains(WidgetState.disabled);

              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: desativado ? const Color(0xFFB4BFF5) : null,
                  gradient: desativado
                      ? null
                      : const LinearGradient(
                          colors: [azul, azulClaro],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                ),
                child: child,
              );
            },
          ),
        ),
      ),
      home: const TelaCompromissos(),
    );
  }
}