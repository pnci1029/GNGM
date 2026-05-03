class RegisterRequestDto {
  final String email;
  final String password;
  final String name;
  final String? phone;

  const RegisterRequestDto({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      if (phone != null) 'phone': phone,
    };
  }
}