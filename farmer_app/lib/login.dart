import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:farmer_app/navbar.dart';
import 'package:farmer_app/splashscreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

final TextEditingController usernamecontroller = TextEditingController();
final TextEditingController passwordcontroller = TextEditingController();
var mytoken = '';

Future<void> Logmein(BuildContext context) async {
  var headers = {'Accept': 'application/json'};
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://www.ademnea.net/api/v1/login'));
  request.fields.addAll(
      {'email': usernamecontroller.text, 'password': passwordcontroller.text});

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    // Extract the token from the response
    String responseBody = await response.stream.bytesToString();
    Map<String, dynamic> responseData = jsonDecode(responseBody);
    String token = responseData['token'];

    // Save the token for later use
    saveToken(token);

    // Print success message
    // print(token);

    Fluttertoast.showToast(
        msg: "Successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    // Log the farmer in
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => navbar(
          token: mytoken,
        ),
      ),
    );
  } else {
    // Print "unauthorized"
    // print("Wrong credentials!");

    Fluttertoast.showToast(
        msg: "Wrong Credentials!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

void saveToken(String token) {
  // For simplicity, let's store it in a global variable
  mytoken = token;
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    height: 100,
                  ),
                  //image starts here
                  Container(
                    //color: Colors.white,
                    child: Center(
                      child: Image.asset(
                        'lib/images/log-1.png',
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ),
                  Container(
                    height: 25,
                  ),

                  TextField(
                    controller: usernamecontroller,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      fillColor: Colors.brown.shade100, // Background color
                      filled:
                          true, // Set to true to fill the background with the specified color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide.none, // No border for the outline
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(
                            left: 16), // Add left padding to the prefix icon
                        child: Icon(Icons.person), // Placeholder icon
                      ),
                    ),
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // Increase the height of the text field
                    ),
                  ),
                  Container(
                    height: 20,
                  ),

                  TextField(
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      fillColor: Colors.brown.shade100, // Background color
                      filled:
                          true, // Set to true to fill the background with the specified color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide.none, // No border for the outline
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(
                            left: 16), // Add left padding to the prefix icon
                        child: Icon(Icons.lock), // Placeholder icon
                      ),
                    ),
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // Increase the height of the text field
                    ),
                  ),
                  Container(
                    height: 10,
                  ),

                  Row(
                    children: [
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Splashscreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 206, 109, 40),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    height: 10,
                  ),
                  SizedBox(
                    width: 200, // Specify the desired width here
                    child: ElevatedButton(
                      onPressed: () {
                        Logmein(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 206, 109, 40), // RGB color
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 20,
                  ),
                  //bottom navigation.
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Have no account?"),
                        const SizedBox(
                            width: 1), // Add some space between the texts
                        TextButton(
                          onPressed: () {
                            // Handle sign-in button press
                          },
                          child: const Text(
                            "contact support team to register",
                            style: TextStyle(
                              color: Colors
                                  .black, // Change color to blue for a link-like appearance
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //closes the column
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
