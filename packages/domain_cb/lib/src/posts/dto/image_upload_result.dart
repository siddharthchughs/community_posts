import 'package:equatable/equatable.dart';

class ImageUploadResult extends Equatable {
  final String postId;
  final String imageUrl;
  ImageUploadResult({required this.postId, required this.imageUrl});

  @override
  List<Object> get props => [postId, imageUrl];
}
