import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/posts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCardView extends StatelessWidget {
  CommentCardView({super.key, required this.commentDisplay});
  CommentDisplay commentDisplay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.amberAccent.shade200,
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
                          const CircularProgressIndicator.adaptive(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error_outline, size: 20),
                      fit: BoxFit.cover,
                      width: 40,
                      height: 50,
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
