import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rapiex/widgets/allemployees.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Employee App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http
        .get(Uri.parse('https://retoolapi.dev/H2F0Ui/getemployedetail'));
    final responseData = json.decode(response.body) as List<dynamic>;
    print(responseData);
    final userData = responseData.firstWhere(
      (data) =>
          data['name'] == nameController.text &&
          data['name'] == passwordController.text,
      orElse: () => null,
    );
    if (userData != null) {
      final box = GetStorage();
      box.write('name', userData['name']);
      box.write('designation', userData['designation']);
      box.write('id', userData['id']);
      box.write('company', userData['company']);
      Get.off(HomePage());
    } else {
      Get.snackbar('Error', 'No user found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name')),
            TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('Login')),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final box = GetStorage();

  void _logout() {
    box.erase();
    Get.offAll(LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Home'),
          actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Employee',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Name: ${box.read<String>('name')}'),
            Text('Designation: ${box.read<String>('designation')}'),
            ElevatedButton(
              onPressed: () => Get.to(DetailPage()),
              child: Text('View Employee Details'),
            ),
            ElevatedButton(
              onPressed: () => Get.to(EmployeeListPage()), // Navigate to EmployeeListPage
              child: Text('Show All Employees'), // Button to navigate
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Detail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${box.read<String>('name')}'),
            Text('Designation: ${box.read<String>('designation')}'),
            
            Text('Company: ${box.read<String>('company')}'),
          ],
        ),
      ),
    );
  }
}
