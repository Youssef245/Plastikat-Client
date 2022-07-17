import 'package:flutter/material.dart';

class PlastikatBar extends StatelessWidget implements PreferredSizeWidget {
  Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);

  PlastikatBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Plastikat',
        style: TextStyle(
          color: plastikatGreen,
          fontSize: 36,
          fontWeight: FontWeight.w600,
          fontFamily: 'Comfortaa',
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: plastikatGreen),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60.0);
}
