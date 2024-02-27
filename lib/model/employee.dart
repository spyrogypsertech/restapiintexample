// employee_model.dart

class Employee {
 
  final String name;
  final String rating;
  final String company;
  final String interests;
  final String viewMore;
  final String designation;
  final String companyLogo;
  final String jobDescription;

  Employee({
   
    required this.name,
    required this.rating,
    required this.company,
    required this.interests,
    required this.viewMore,
    required this.designation,
    required this.companyLogo,
    required this.jobDescription,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
     // id: json['id'],
      name: json['name'].toString(),
      rating: json['rating'].toString(),
      company: json['company'].toString(),
      interests: json['interests'].toString(),
      viewMore: json['view_more'].toString(),
      designation: json['designation'].toString(),
      companyLogo: json['company_logo'].toString(),
      jobDescription: json['job_description'].toString(),
    );
  }
}
