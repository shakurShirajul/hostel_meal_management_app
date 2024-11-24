import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  // Text editing controllers for capturing user input
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // For tracking the selected user role (Student or Admin)
  String? userRole = 'Student'; // Default to 'Student'

  // Error messages
  String emailError = '';
  String passwordError = '';
  String generalError = ''; // To show general errors on top of the form

  // Validate email using a simple regex pattern
  bool validateEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  // Validate password (at least 6 characters, contains at least one number and one special character)
  bool validatePassword(String password) {
    return password.length >= 6 &&
        RegExp(r'[0-9]').hasMatch(password) &&  // At least one digit
        RegExp(r'[@$!%*?&]').hasMatch(password); // At least one special character
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(42.0, 0, 42.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Displaying any general errors at the top
              if (generalError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    generalError,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  filled: true,
                  fillColor: Color(0xFFF3F3F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  filled: true,
                  fillColor: Color(0xFFF3F3F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  errorText: emailError.isEmpty ? null : emailError,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Color(0xFFF3F3F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  errorText: passwordError.isEmpty ? null : passwordError,
                ),
              ),
              SizedBox(height: 16),
              // Radio buttons for Student or Admin
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Select Role",
                  //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Student',
                            groupValue: userRole,
                            onChanged: (String? value) {
                              setState(() {
                                userRole = value;
                              });
                            },
                          ),
                          Text("Student"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Admin',
                            groupValue: userRole,
                            onChanged: (String? value) {
                              setState(() {
                                userRole = value;
                              });
                            },
                          ),
                          Text("Hostel Admin"),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: size.width,
                child: ElevatedButton(
                  onPressed: () {
                    // Reset errors
                    setState(() {
                      emailError = '';
                      passwordError = '';
                      generalError = '';
                    });

                    // Get form values
                    String fullName = _fullNameController.text;
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    // Validate email
                    if (!validateEmail(email)) {
                      setState(() {
                        emailError = 'Please enter a valid email';
                      });
                    }

                    // Validate password
                    if (!validatePassword(password)) {
                      setState(() {
                        passwordError = 'At least 6 characters long \nAt least 1 special character \nAt least 1 numeric character';
                      });
                    }


                    // If validation passes, proceed with sign-up logic
                    print("Full Name: $fullName");
                    print("Email: $email");
                    print("Password: $password");
                    print("Role: $userRole");

                    // Handle the sign-up process here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7E9E2C),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Create Account",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
