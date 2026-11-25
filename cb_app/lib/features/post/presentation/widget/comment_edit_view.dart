import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/post_comments/post_comments_bloc.dart';

class CommentEditView extends StatefulWidget {
  const CommentEditView({
    super.key,
    required this.postId,
    required this.scrollController,
  });

  final String postId;
  final ScrollController scrollController;

  @override
  State<CommentEditView> createState() => _CommentEditViewState();
}

class _CommentEditViewState extends State<CommentEditView> {
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    _commentTextController.text = '';
    super.initState();
  }

  void _submitComment() {
    final _content = _commentTextController.text;
    if (_content.isEmpty) return;

    context.read<PostCommentsBloc>().add(
      PostCommentAdded(postId: widget.postId, content: _content),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) widget.scrollController.jumpTo(0);
    });

    _commentTextController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PostCommentsBloc, PostCommentsState, bool>(
      selector: (state) {
        return state.uiState == PostCommentsUIState.submitting;
      },
      builder: (context, hasSubmitted) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.yellow, width: 1.5)),
              color: Colors.indigo,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 20.0),
                    controller: _commentTextController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    enabled: !hasSubmitted,
                    onSubmitted: (_) =>
                        hasSubmitted ? null : (_) => _submitComment(),
                  ),
                ),
                hasSubmitted
                    ? const SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.send_outlined,
                          color: Colors.blueAccent,
                        ),
                        onPressed: _submitComment,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    super.dispose();
  }
}
