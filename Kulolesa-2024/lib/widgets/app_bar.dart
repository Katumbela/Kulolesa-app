import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
   String titulo;

  CustomAppBar({super.key, required this.titulo});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context); // Voltar para a tela anterior
        },
      ),
      centerTitle: true,
      title: Text(titulo, style: const TextStyle(
        fontWeight: FontWeight.bold,

      ),),
    );
  }
}
