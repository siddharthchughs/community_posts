import 'package:domain/posts.dart';
import 'package:equatable/equatable.dart';

class GlobalEvent extends Equatable {
  const GlobalEvent();

  @override
  List<Object?> get props => [];
}

final class PostCreatedDispacted extends GlobalEvent {
  const PostCreatedDispacted({required this.posts});

  final PostDisplay posts;

  @override
  List<Object?> get props => [posts];
}

final class PostUpdatedDispatched extends GlobalEvent {
  const PostUpdatedDispatched({required this.posts});

  final PostDisplay posts;

  @override
  List<Object?> get props => [posts];
}
