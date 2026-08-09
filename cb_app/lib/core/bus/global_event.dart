import 'package:domain/posts.dart';
import 'package:equatable/equatable.dart';

sealed class GlobalEvent extends Equatable {
  const GlobalEvent();

  @override
  List<Object?> get props => [];
}

final class PostCreatedDispacted extends GlobalEvent {
  const PostCreatedDispacted({required this.posts});

  final PostDisplayEntity posts;

  @override
  List<Object?> get props => [posts];
}
