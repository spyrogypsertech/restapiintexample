import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapiex/main.dart';
import 'package:rapiex/model/employee.dart';
import 'package:http/http.dart' as http;

class EmployeeListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: FutureBuilder(
        future: fetchEmployees(), // Fetch employee data from API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Display employee data in cards
            List<Employee>? employees = snapshot.data;
            return 
           ListView.builder(
  itemCount: employees!.length,
  itemBuilder: (context, index) {
    Employee employee = employees[index];
    if (employee.name != "null" && employee.designation != "null") {
      return Card(
        child: ListTile(
          title: Text(employee.name),
          subtitle: Text(employee.designation),
        ),
      );
    } else {
      // Return an empty container if either name or designation is null
      return Container();
    }
  },
);
          }
        },
      ),
    );
  }

  Future<List<Employee>> fetchEmployees() async {
    final response = await http
        .get(Uri.parse('https://retoolapi.dev/H2F0Ui/getemployedetail'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      return responseData.map((data) => Employee.fromJson(data)).toList();
    } else {
      printError(info: "error");
      throw Exception('Failed to fetch employees');
    }
  }
}
