import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.role,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final String role;

  @override
  List<Object> get props => [id, name, avatarUrl, role];
}
