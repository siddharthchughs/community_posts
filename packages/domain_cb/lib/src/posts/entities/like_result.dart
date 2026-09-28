import 'package:equatable/equatable.dart';

class LikeResult extends Equatable {
  const LikeResult({required this.isLiked, required this.likesCount});
  final bool isLiked;
  final int likesCount;

  @override
  List<Object?> get props => [isLiked, likesCount];
}
