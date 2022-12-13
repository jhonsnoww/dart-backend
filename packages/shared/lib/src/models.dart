import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:db/db.dart' as db;

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
class User with _$User implements db.UserView {
  const factory User(
      {required int id, required String name, required String email,required DateTime createdDate,required String phoneNumber}) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromDb(db.User ur) =>
      User(id: ur.id, name: ur.name, email: ur.email,phoneNumber: ur.phoneNumber,createdDate: ur.createdDate);
}
