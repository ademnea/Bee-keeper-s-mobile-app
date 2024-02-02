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
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                  ),

                  //button starts here.
                  SizedBox(
                    width: 200, // Replace with your desired width
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your button onPressed logic here
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(61, 33, 13, 1),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the radius as needed
                          ),
                        ),
                      ),
                      child: const Text(
                        'GET STARTED',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
