import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post_comments/post_comments_bloc.dart';
import 'comment_card_view.dart';

class CommentListView extends StatelessWidget {
  const CommentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCommentsBloc, PostCommentsState>(
      builder: (context, state) {
        switch (state.uiState) {
          case PostCommentsUIState.initial || PostCommentsUIState.loading:
            return const SliverFillRemaining(
              child: CircularProgressIndicator.adaptive(),
            );
          case PostCommentsUIState.failure:
            return SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsetsGeometry.all(18.0),
                  child: Text(
                    'Error:: ${state.failure?.message ?? 'Unknown Error'}',
                  ),
                ),
              ),
            );
          case _:
            if (state.comments.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 28),
                  child: Center(child: Text('No Comments Yet')),
                ),
              );
            }
            return SliverList.builder(
              itemCount: state.hasReachedMax
                  ? state.comments.length
                  : state.comments.length + 1,
              itemBuilder: (context, index) {
                if (index > state.comments.length) {
                  return state.uiState == PostCommentsUIState.fetchingMore
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(16.0),
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        )
                      : const SizedBox.shrink();
                }
                return CommentCardView(commentDisplay: state.comments[index]);
              },
            );
        }
      },
    );
  }
}
