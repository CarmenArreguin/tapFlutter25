class UserModel {
  final int? idUser;
  final String? userName;
  final String? passName;

  UserModel({
    this.idUser, 
    this.userName, 
    this.passName,
  });

  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
      idUser: map['idUser'],
      userName: map['userName'],
      passName: map['passName']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'userName': userName,
      'passName': passName,
    };
  }
}