import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/router/router_constants.dart';
import '../../../auth/presentation/blocs/authentication/authentication_bloc.dart';

class CommentCardView extends StatelessWidget {
  const CommentCardView({super.key, required this.commentDisplay});
  final CommentDisplay commentDisplay;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthenticationBloc>().state.user;

    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              if (currentUser?.id == commentDisplay.authorId) {
                context.pushNamed(
                  RouteNames.userDetail,
                  pathParameters: {'userId': commentDisplay.authorId},
                );
              }
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.amber.shade50,
              child: commentDisplay.authorAvatarUrl == null
                  ? const Icon(
                      Icons.person_2_outlined,
                      size: 48,
                      color: Colors.blue,
                    )
                  : ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: commentDisplay.authorAvatarUrl!,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(strokeWidth: 2.0),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error_outline, size: 20),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      commentDisplay.authorUserName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      DateFormat(
                        'MM-dd HH:mm',
                      ).format(commentDisplay.createdAt),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(commentDisplay.content),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
