import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'config.dart';


Future<bool> checkNetworkConnection(BuildContext context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    showErrorDialog(context, 'No network connection');
    return false;
  }
  return true;
}

Future<bool> checkDatabaseDriver(BuildContext context) async {
  if (!(await checkNetworkConnection(context))) return false;

  //print('Checking database driver...');
  try {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/database/check-driver')
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      //print('Database driver check successful');
      return json.decode(response.body);
    } else {
      //print('Database driver check failed with status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    //print('Error checking database driver: $e');
    return false;
  }
}

Future<bool> checkDatabaseConnection(BuildContext context) async {
  if (!(await checkNetworkConnection(context))) return false;

  //print('Checking database connection...');
  try {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/database/check-connection')
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      //print('Database connection check successful');
      return json.decode(response.body);
    } else {
      //print('Database connection check failed with status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    //print('Error checking database connection: $e');
    return false;
  }
}

Future<bool> checkDatabase(BuildContext context) async {
  final driverLoaded = await checkDatabaseDriver(context);
  if (!driverLoaded) {
    //print('Database driver check failed');
    return false;
  }

  final connectionCreated = await checkDatabaseConnection(context);
  if (!connectionCreated) {
    //print('Database connection check failed');
    return false;
  }

  return true;
}

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          width: double.infinity,
          height: 100,
          color: Colors.white,
          child: Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
        ),
      );
    },
  );
}