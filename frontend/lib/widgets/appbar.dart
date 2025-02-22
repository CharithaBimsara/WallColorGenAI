import 'package:flutter/material.dart';

class TransparentAppBarPage {
  static AppBar getAppBar(String title, GlobalKey<ScaffoldState> scaffoldKey) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, size: 30,),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
