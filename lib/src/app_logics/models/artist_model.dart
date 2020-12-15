class UserModel {
  final String fullName;
  final String profilePicture;
  final String username;
  final String dateCreated;
  final String email;

  UserModel({
    this.username,
    this.dateCreated,
    this.email,
    this.fullName,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      fullName: data['full_name'],
      profilePicture: data['profile_picture'],
      username: data['username'],
      dateCreated: data['date'],
      email: data['email']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'profile_picture': profilePicture,
      'username': username,
      'date': dateCreated,
      'email': email
    };
  }
}
