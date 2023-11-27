import 'package:flutter/material.dart';
import 'package:kulolesa/pages/perfil/paginas_meus_servicos/acomodacao.dart';
import 'package:kulolesa/pages/perfil/paginas_meus_servicos/actividades.dart';
import 'package:kulolesa/pages/perfil/paginas_meus_servicos/transportes.dart';
import 'package:kulolesa/widgets/app_bar.dart';

class PaginasMeusServicos extends StatefulWidget {
  @override
  _PaginasMeusServicosState createState() => _PaginasMeusServicosState();
}

class _PaginasMeusServicosState extends State<PaginasMeusServicos> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    TransportesPage(),
    AcomodacaoPage(),
    AtividadePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: 'Meus Serviços'),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Transportes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Acomodação',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity),
            label: 'Atividades',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
