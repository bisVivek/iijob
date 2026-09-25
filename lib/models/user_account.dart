/// UserAccount Model for 11Jobs Authentication & Profile
class UserAccount {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String countryCode;
  final String password;
  bool isVerified;
  int assessmentScore;

  UserAccount({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.countryCode = "+1",
    required this.password,
    this.isVerified = false,
    this.assessmentScore = 0,
  });

  String get fullName => "$firstName $lastName".trim();
  String get fullPhoneNumber => "$countryCode $phone".trim();

  /// Convert UserAccount to a Hive-serializable Map
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'countryCode': countryCode,
      'password': password,
      'isVerified': isVerified,
      'assessmentScore': assessmentScore,
    };
  }

  /// Create UserAccount from a Map (retrieved from Hive)
  factory UserAccount.fromMap(Map<dynamic, dynamic> map) {
    return UserAccount(
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      countryCode: map['countryCode'] as String? ?? '+1',
      password: map['password'] as String? ?? '',
      isVerified: map['isVerified'] as bool? ?? false,
      assessmentScore: (map['assessmentScore'] as num?)?.toInt() ?? 0,
    );
  }

  UserAccount copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? countryCode,
    String? password,
    bool? isVerified,
    int? assessmentScore,
  }) {
    return UserAccount(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      password: password ?? this.password,
      isVerified: isVerified ?? this.isVerified,
      assessmentScore: assessmentScore ?? this.assessmentScore,
    );
  }
}
