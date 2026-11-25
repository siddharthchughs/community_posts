import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/constants.dart';
import 'package:domain/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/router/router_constants.dart';
import '../../../auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../bloc/post_comments/post_comments_bloc.dart';

class CommentCardView extends StatelessWidget {
  const CommentCardView({super.key, required this.commentDisplay});
  final CommentDisplay commentDisplay;

  void _onEditCommentDialog(BuildContext context) {
    final commentListBloc = context.read<PostCommentsBloc>();

    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: commentListBloc,
          child: _EditCommentDialog(comment: commentDisplay),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthenticationBloc>().state.user;
    final currentUserRole = currentUser?.role;

    final bool canEdit = currentUser?.id == commentDisplay.authorId;
    final bool canDelete = canEdit || (currentUserRole == Role.admin);

    return BlocSelector<PostCommentsBloc, PostCommentsState, bool>(
      selector: (state) {
        return state.submittingCommentId == commentDisplay.id;
      },
      builder: (context, isSubmitting) {
        if (isSubmitting) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            vertical: 5,
            horizontal: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  if (currentUser?.id == commentDisplay.authorId) {
                    context.pushNamed(
                      RouteNames.userDetail,
                      pathParameters: {'userId': commentDisplay.authorId},
                    );
                  }
                },
                tileColor: Colors.indigoAccent.shade200,
                contentPadding: const EdgeInsetsGeometry.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: commentDisplay.authorAvatarUrl == null
                      ? const Icon(
                          Icons.person_2_outlined,
                          size: 30,
                          color: Colors.blue,
                        )
                      : ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: commentDisplay.authorAvatarUrl!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error_outline, size: 20),
                            fit: BoxFit.cover,
                            width: 35,
                            height: 35,
                          ),
                        ),
                ),

                title: Text(
                  commentDisplay.authorUserName,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat(
                        'MM-dd HH:mm',
                      ).format(commentDisplay.createdAt),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      commentDisplay.content,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (canEdit)
                      IconButton(
                        onPressed: () => _onEditCommentDialog(context),
                        icon: const Icon(
                          Icons.edit,
                          size: 40,
                          color: Colors.white,
                        ),
                        tooltip: 'Edit Comment',
                      ),
                    if (canDelete)
                      IconButton(
                        onPressed: () async {
                          final commentListBloc = context
                              .read<PostCommentsBloc>();
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Comment'),
                              content: const Text(
                                'Are you sure you want to delete this comment?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            commentListBloc.add(
                              PostCommentDeleted(
                                postId: commentDisplay.postId,
                                commentId: commentDisplay.id,
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 40,
                          color: Colors.amberAccent,
                        ),
                        tooltip: 'Delete Comment',
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
            ],
          ),
        );
      },
    );
  }
}

class _EditCommentDialog extends StatefulWidget {
  const _EditCommentDialog({super.key, required this.comment});
  final CommentDisplay comment;

  @override
  State<_EditCommentDialog> createState() => _EditCommentDialogState();
}

class _EditCommentDialogState extends State<_EditCommentDialog> {
  late final TextEditingController _textEditController;
  bool _isSaveEnabled = false;

  @override
  void initState() {
    _textEditController = TextEditingController(text: widget.comment.content);
    _textEditController.addListener(_updateSaveButtonState);
    super.initState();
  }

  void _updateSaveButtonState() {
    final isNotEmpty = _textEditController.text.trim().isNotEmpty;
    final isChanged = _textEditController.text != widget.comment.content;
    if (mounted) {
      setState(() {
        _isSaveEnabled = isNotEmpty && isChanged;
      });
    }
  }

  void _submit(bool isSubmitting) {
    if (!_isSaveEnabled || isSubmitting) return;
    final newContent = _textEditController.text.trim();
    context.read<PostCommentsBloc>().add(
      PostCommentEdited(commentId: widget.comment.id, newContent: newContent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCommentsBloc, PostCommentsState>(
      listener: (context, state) {
        final _onPostSubmitted = state.submittingCommentId == widget.comment.id;
        if (!_onPostSubmitted && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: BlocSelector<PostCommentsBloc, PostCommentsState, bool>(
        selector: (state) {
          return state.submittingCommentId == widget.comment.id;
        },
        builder: (context, isSubmitting) {
          return AlertDialog(
            title: const Text('Edit Comment'),
            content: TextField(
              autofocus: true,
              controller: _textEditController,
              maxLines: null,
              enabled: !isSubmitting,
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    isSubmitting ? null : Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: _isSaveEnabled && !isSubmitting
                    ? () => _submit(isSubmitting)
                    : null,
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _textEditController.removeListener(_updateSaveButtonState);
    _textEditController.dispose();
    super.dispose();
  }
}
