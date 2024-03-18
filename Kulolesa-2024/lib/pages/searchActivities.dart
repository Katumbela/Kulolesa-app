import 'package:flutter/material.dart';

class PesquisarActividades extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 393,
          height: 852,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 20,
                top: 59,
                child: Container(
                  width: 24,
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(children: [Icon(Icons.arrow_back_sharp)]),
                ),
              ),
              Positioned(
                left: 60,
                top: 56,
                child: Text(
                  'Experências',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    height: 0,
                    letterSpacing: 0.85,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 109,
                child: Container(
                  width: 353,
                  height: 54,
                  decoration: ShapeDecoration(
                    color: Color(0x47E1E1E1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 180,
                child: Container(
                  width: 353,
                  height: 54,
                  decoration: ShapeDecoration(
                    color: Color(0x47E1E1E1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 76,
                top: 124,
                child: Text(
                  'Onde ?',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5400000214576721),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    height: 0,
                    letterSpacing: 0.85,
                  ),
                ),
              ),
              Positioned(
                left: 76,
                top: 195,
                child: Text(
                  'qua. 25 out. 18:00',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5400000214576721),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    height: 0,
                    letterSpacing: 0.85,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 307,
                child: Container(
                  width: 353,
                  height: 56,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 126,
                top: 326,
                child: Text(
                  'Pesquisar carros',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    height: 0,
                    letterSpacing: 0.85,
                  ),
                ),
              ),
              Positioned(
                left: 157,
                top: 421,
                child: Container(
                  width: 79,
                  height: 11,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 11,
                        height: 11,
                        decoration: ShapeDecoration(
                          color: Color(0xFFD9D9D9),
                          shape: OvalBorder(),
                        ),
                      ),
                      Container(
                        width: 11,
                        height: 11,
                        decoration: ShapeDecoration(
                          color: Color(0xA5E7E7E7),
                          shape: OvalBorder(),
                        ),
                      ),
                      Container(
                        width: 11,
                        height: 11,
                        decoration: ShapeDecoration(
                          color: Color(0x9BE7E7E7),
                          shape: OvalBorder(),
                        ),
                      ),
                      Container(
                        width: 11,
                        height: 11,
                        decoration: ShapeDecoration(
                          color: Color(0x99E7E7E7),
                          shape: OvalBorder(),
                        ),
                      ),
                      Container(
                        width: 11,
                        height: 11,
                        decoration: ShapeDecoration(
                          color: Color(0x99E7E7E7),
                          shape: OvalBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
