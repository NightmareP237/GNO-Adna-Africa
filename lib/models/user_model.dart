// models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoView {
  String name,birthday,phoneNumber,country,email,image,uid;
  String entreprise,keyofentreprise;
  UserInfoView({
required this.email,
required this.image,
required this.phoneNumber,
required this.country,
required this.name,
required this.birthday,
this.entreprise='',
this.keyofentreprise='',
this.uid='',
  });
   static Future<UserInfoView> fromDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> value,String uid1) async {
    final Map<String, dynamic> data= value.data() as Map<String, dynamic>;
    return UserInfoView(
      uid: uid1,
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      country: data['location'],
      birthday: data['date'],
      entreprise: data['entreprise'],
      keyofentreprise: data['keyentreprise'],
      image:data['image']
    );
  }
}