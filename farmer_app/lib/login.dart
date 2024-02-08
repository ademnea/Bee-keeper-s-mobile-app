import 'package:farmer_app/home.dart';
import 'package:farmer_app/splashscreen.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

final TextEditingController usernamecontroller = TextEditingController();
final TextEditingController passwordcontroller = TextEditingController();

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
                    //controller: _acctController,
                    decoration: InputDecoration(
                      labelText: 'Username',
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
                    //controller: _acctController,
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
                    height: 20,
                  ),

                  SizedBox(
                    width: 200, // Specify the desired width here
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ),
                        );
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
