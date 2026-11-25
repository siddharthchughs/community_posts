import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:core/utils.dart';
import 'package:domain/posts.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bus/global_event.dart';
import '../../../../../core/bus/global_event_bus.dart';

part 'post_form_event.dart';
part 'post_form_state.dart';

@injectable
class PostFormBloc extends Bloc<PostFormEvent, PostFormState> {
  PostFormBloc({
    required CreatePostUseCase createPostUsecase,
    required UploadPostImageUseCase uploadImageUsecase,
    required GlobalEventBus globalEventBus,
    required UpdatePostUseCase updatePostUseCase,
    required GetPostDetailUseCase getPostDetailUseCase,
  }) : _createPostUseCase = createPostUsecase,
       _uploadPostImageUseCase = uploadImageUsecase,
       _globalEventBus = globalEventBus,
       _updatePostUseCase = updatePostUseCase,
       _getPostDetailUseCase = getPostDetailUseCase,
       super(const PostFormIntial()) {
    on<PostFormSubmittedEvent>(_onPostFormSubmitted);
    on<PostFormPrefilled>(_postFormPrefilled);
    on<PostEdited>(_postFormEdited);
  }

  final CreatePostUseCase _createPostUseCase;
  final UploadPostImageUseCase _uploadPostImageUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final GetPostDetailUseCase _getPostDetailUseCase;
  final GlobalEventBus _globalEventBus;

  Future<void> _onPostFormSubmitted(
    PostFormSubmittedEvent event,
    Emitter<PostFormState> emitter,
  ) async {
    String? imageUrl;
    String? postId;

    if (event.imageFile != null) {
      final uploadResult = await _uploadPostImageUseCase(
        UploadPostImageParams(image: event.imageFile!, postId: null),
      );
      final responseSucess = uploadResult.fold(
        (failure) {
          emit(PostFormFailure(failure: failure));
          return false;
        },
        (sucess) {
          postId = sucess.postId;
          imageUrl = sucess.imageUrl;
          return true;
        },
      );
      if (!responseSucess) return;
    }
    final createResult = await _createPostUseCase(
      CreatePostParams(
        postId: postId,
        title: event.title,
        content: event.content,
        imageUrl: imageUrl,
      ),
    );

    createResult.fold(
      (failure) {
        emit(PostFormFailure(failure: failure));
      },
      (newPost) {
        _globalEventBus.add(PostCreatedDispacted(posts: newPost));
        emit(PostFormSuccess(data: newPost));
      },
    );
  }

  Future<void> _postFormPrefilled(
    PostFormPrefilled event,
    Emitter<PostFormState> emitter,
  ) async {
    emit(const PostFormProgress());
    final result = await _getPostDetailUseCase(event.postId);
    result.fold(
      (filure) => emit(PostFormFailure(failure: filure)),
      (post) => PostFormSuccess(data: post),
    );
  }

  Future<void> _postFormEdited(
    PostEdited event,
    Emitter<PostFormState> emitter,
  ) async {
    final result = await _updatePostUseCase(
      UpdatePostParams(
        originalPost: event.originalPost,
        newTitle: event.title,
        newContent: event.newContent,
        fileImageUrl: event.newImageFile,
        isImageChanged: event.imageIsRemoved || event.newImageFile != null,
      ),
    );
    result.fold(
      (failure) {
        emit(PostFormFailure(failure: failure));
      },
      (postUpdatedSuccess) {
        _globalEventBus.add(PostUpdatedDispatched(posts: postUpdatedSuccess));
        emit(PostFormSuccess(data: postUpdatedSuccess));
      },
    );
  }
}
