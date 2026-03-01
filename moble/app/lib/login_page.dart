import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'homepage.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  final formKey = GlobalKey<FormState>();
  final e = TextEditingController();
  final p = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> login() async{
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final url = Uri.parse("http//192.168.5.1:5000/api/mobile/login");

    try{
      final response = await http.post(
        url, headers: {"Content-Type": "application/json"},
        body: jsonEncode({ 
          "email": e.text,
          "password": p.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']){
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (_) => homepage(user: data['user']),
          ),
          );
      } else{
        setState(() {
          errorMessage = data['message'];
        });
      }
    } catch (e){
      setState((){
        errorMessage = "Cannot connect to server";
      });
    }
  }

@override
Widget build(BuildContext content){
  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.account_circle, size: 80, color: Colors.greenAccent),
              const SizedBox(height: 24),
              Text(
                "Welcome Back",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: e,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value){
                  if (value == null || value.isEmpty)
                    return 'Please enter your email';
                  if (!value.contains('@'))
                    return 'Please enter a valid email';
                    return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: p,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outlined),
                ),
                validator: (value){
                  if (value == null || value.isEmpty)
                    return 'Please enter your password';
                    return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: FilledButton(
                  onPressed: isLoading ? null : login,
                  child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: TextStyle(color: Colors.grey.shade600)),
                  TextButton(
                    onPressed: (){
                      Navigator.push(
                        context, MaterialPageRoute(builder:(context) => SignupPage()),
                    );
                    },
                    child: const Text("Sign up"),
                  ),
              ],),
              
            ],),))
      ),),
  );
}

}

class SignupPage extends StatefulWidget{
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => SignupPageState();
  
}
class SignupPageState extends State<SignupPage>{
  final formKey = GlobalKey<FormState>();
  final e = TextEditingController();
  final p = TextEditingController();
  final cp = TextEditingController();
  String? selectedDept;

  final List<String> departments = ['CITE', 'FINANCE', 'GSD'];

  bool isLoading = false;

  void signup() async{
    if (formKey.currentState!.validate()){
      setState(() => isLoading = true);

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created! Please login.")),
        );
        Navigator.pop(context); // back to login
      }
    }
  }

  @override
  Widget build(BuildContext Context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Create Account", style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: Colors.black87,
                ),
                ),
                const SizedBox(height: 8),
                Text("Join The campany workspace", style: TextStyle( color:Colors.grey.shade600),),

                  const SizedBox(height: 16),
                  TextFormField(
                    controller: e,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) => !v!.contains('@') ? 'Invalid email' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedDept,
                    decoration: const InputDecoration(
                      labelText: "Department",
                      prefixIcon: Icon(Icons.business_outlined),
                    ),
                    items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (val) => setState(() => selectedDept = val),
                    validator: (v) => v == null ? 'Select a department' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: p,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_outlined),
                    ),
                    validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: cp,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (v) => v != p.text ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: isLoading ? null : signup,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Sign Up", style: TextStyle(fontSize: 16)),
                    ),
                  ),

              ],)
          ),
        ),
      ),
      ),
      );
  }

}

