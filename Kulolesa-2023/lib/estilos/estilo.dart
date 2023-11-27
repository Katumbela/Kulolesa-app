import 'package:flutter/material.dart';

class EstiloApp {
  static const Color primaryColor = Color(0xff1d77ff);
  static const Color secondaryColor = Color(0xFF59a9ff);
  static const Color qcolor = Color(0xFFffd587);
  static const Color tcolor = Color(0xFFffa90b);
  static const Color ccolor = Color(0xFF005ab4);

  static final ButtonStyle botaoElevado = ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  // Estilo para TextField
  static InputDecoration estiloTextField({
    String? label,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }

  // Estilo para textos
  static const TextStyle estiloTexto = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  // Estilo para imagens
  static final BoxDecoration estiloImagem = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    boxShadow: const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 5,
        offset: Offset(0, 2),
      ),
    ],
  );
}
