// models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoView {
  String name,birthday,phoneNumber,country,email,image,uid;
  String entreprise,keyofentreprise,fcmToken;
  List secteur=[],followers=[];
  int share=0;
  UserInfoView({
required this.email,
required this.image,
required this.phoneNumber,
required this.country,
required this.name,
required this.birthday,
required this.fcmToken,
this.entreprise='',
this.keyofentreprise='',
this.uid='',
this.share=0,
required this.followers,
required this.secteur,
  });
  static  UserInfoView fromDocumentSnapshot(
      QueryDocumentSnapshot value,String uid1) {
    final Map<String, dynamic> data = value.data() as Map<String, dynamic>;
    return UserInfoView(
      uid: uid1,
      name: data['name']??'',
      email: data['email']??'',
      phoneNumber: data['phoneNumber']??'',
      country: data['location']??'',
      birthday: data['date']??'',
      entreprise: data['entreprise']??'',
      keyofentreprise: data['keyentreprise']??'',
      fcmToken: data['fcmToken']??'',
      image:data['image']??'',
      secteur: data['secteur']??'',
      followers: data['followers']??[],
      share: data['share']??0
    );
  }
}
