import 'package:domain/posts.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/router/router_constants.dart';
import '../../../auth/presentation/blocs/authentication/authentication_bloc.dart';

class PostCardItem extends StatelessWidget {
  const PostCardItem({
    super.key,
    required this.postDisplayEntity,
    required this.onToogleLike,
  });

  final PostDisplayEntity postDisplayEntity;
  final VoidCallback? onToogleLike;

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.select(
      (AuthenticationBloc bloc) => bloc.state.user?.id,
    );
    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteNames.postDetail,
          pathParameters: {'postId': postDisplayEntity.postId},
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  if (currentUserId != postDisplayEntity.authorID) {
                    context.pushNamed(
                      RouteNames.userDetail,
                      pathParameters: {'userId': postDisplayEntity.authorID},
                    );
                  }
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue.shade200,
                      child: postDisplayEntity.authorAvatarUrl == null
                          ? const Icon(Icons.person, size: 28)
                          : ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: postDisplayEntity.authorAvatarUrl!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error_outline, size: 20),
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(postDisplayEntity.authorName),
                        Text(
                          DateFormat(
                            'yyyy-MM-dd HH:mm',
                          ).format(postDisplayEntity.postCreatedAt),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(postDisplayEntity.title),
              const SizedBox(height: 10),
              if (postDisplayEntity.imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: postDisplayEntity.imageUrl!,
                    placeholder: (context, url) =>
                        Container(height: 180, color: Colors.blueGrey.shade200),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error_outline),
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              Text(
                postDisplayEntity.content,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      postDisplayEntity.currentUserLiked
                          ? Icons.thumb_up
                          : Icons.thumb_down_alt_outlined,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(postDisplayEntity.likeCount.toString()),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.comment_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(postDisplayEntity.commentCount.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
