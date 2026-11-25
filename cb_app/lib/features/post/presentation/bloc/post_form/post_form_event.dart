part of 'post_form_bloc.dart';

sealed class PostFormEvent extends Equatable {
  const PostFormEvent();

  @override
  List<Object?> get props => [];
}

final class PostFormSubmittedEvent extends PostFormEvent {
  const PostFormSubmittedEvent({
    required this.title,
    required this.content,
    this.imageFile,
  });

  final String title;
  final String content;
  final File? imageFile;

  @override
  List<Object?> get props => [title, content, imageFile];
}

final class PostFormPrefilled extends PostFormEvent {
  const PostFormPrefilled({required this.postId});
  final String postId;

  @override
  List<Object?> get props => [postId];
}

final class PostEdited extends PostFormEvent {
  const PostEdited({
    required this.originalPost,
    required this.title,
    required this.newContent,
    required this.newImageFile,
    required this.imageIsRemoved,
  });

  final PostDisplay originalPost;
  final String title;
  final String newContent;
  final File? newImageFile;
  final bool imageIsRemoved;

  @override
  List<Object?> get props => [
    originalPost,
    title,
    newContent,
    newImageFile,
    imageIsRemoved,
  ];
}
