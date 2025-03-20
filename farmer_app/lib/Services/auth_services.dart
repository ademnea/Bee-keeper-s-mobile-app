import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:HPGM/navbar.dart';

class AuthService {
  static String _token = '';

  static Future<void> logmein(BuildContext context, String email, String password) async {
    var headers = {'Accept': 'application/json'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://196.43.168.57/api/v1/login'));
    request.fields.addAll({'email': email, 'password': password});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseData = jsonDecode(responseBody);
      _token = responseData['token'];

      Fluttertoast.showToast(
        msg: "Successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => navbar(
            token: _token,
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Wrong Credentials!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Future<void> launchSupportUrl() async {
    final Uri url = Uri.parse('http://wa.me/+256755088321');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
