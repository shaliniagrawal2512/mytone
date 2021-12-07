class UserData {
  String? name;
  String? email;
  String? phoneNumber;
  String? uid;
  UserData({this.name, this.phoneNumber, this.email, this.uid});
  factory UserData.fromMap(map) {
    return UserData(
        uid: map['uid'],
        email: map['email'],
        name: map['name'],
        phoneNumber: map['phoneNumber']);
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber
    };
  }
}
