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

  final PostDisplay postDisplayEntity;
  final Function() onToogleLike;

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.select(
      (AuthenticationBloc bloc) => bloc.state.user?.id,
    );
    return InkWell(
      onTap: () {
        print('Post Card Item :: ${postDisplayEntity.postId}');
        context.pushNamed(
          RouteNames.postDetail,
          pathParameters: {'postId': postDisplayEntity.postId},
          extra: postDisplayEntity,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      backgroundColor: Colors.blueAccent.shade200,
                      child: postDisplayEntity.authorAvatarUrl == null ||
                              postDisplayEntity.authorAvatarUrl!.isEmpty
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
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(postDisplayEntity.authorName),
                        const SizedBox(height: 8),
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
              if (postDisplayEntity.imageUrl != null &&
                  postDisplayEntity.imageUrl!.isNotEmpty) ...[
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
                const SizedBox(height: 10),
              ],
              Text(
                postDisplayEntity.content,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onToogleLike,
                    icon: Icon(
                      postDisplayEntity.currentUserLiked
                          ? Icons.thumb_up
                          : Icons.thumb_up_alt_outlined,
                      size: 28,
                      color: postDisplayEntity.currentUserLiked
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(postDisplayEntity.likesCount.toString()),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.comment_outlined,
                    size: 28,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(width: 12),
                  Text(postDisplayEntity.commentCount.toString()),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
