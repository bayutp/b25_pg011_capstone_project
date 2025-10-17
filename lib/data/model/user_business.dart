import 'package:cloud_firestore/cloud_firestore.dart';

class UserBusiness {
  final String idBusiness;
  final String idOwner;
  final String name;
  final DateTime createdAt;
  final isActive;

  const UserBusiness({
    this.idBusiness = '',
    required this.idOwner,
    required this.name,
    required this.createdAt,
    this.isActive = false
  });

  factory UserBusiness.fromJson(Map<String, dynamic> json) => UserBusiness(
    idBusiness: json['idBusiness'] as String,
    idOwner: json['idOwner'] as String,
    name: json['name'] as String,
    isActive: json['isActive'] as bool,
    createdAt: (json['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toJson() => {
    'idBusiness': idBusiness,
    'idOwner': idOwner,
    'name': name,
    'isActive': isActive,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
