import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/constants.dart';
import 'package:core/utils.dart';
import 'package:domain/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/router/router_constants.dart';
import '../../../../core/di/di.dart';
import '../../../auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../bloc/post_comments/post_comments_bloc.dart';
import '../bloc/post_detail/post_detail_bloc.dart';
import '../widget/comment_edit_view.dart';
import '../widget/comment_list_view.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key, required this.postId, this.initialPost});
  final String postId;
  final PostDisplay? initialPost;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PostDetailBloc>()
            ..add(PostDetailFetched(postId: postId, initialPost: initialPost)),
        ),
        BlocProvider(
          create: (context) =>
              getIt<PostCommentsBloc>()
                ..add(PostCommentsLoaded(postId: postId)),
        ),
      ],
      child: BlocListener<PostDetailBloc, PostDetailState>(
        listenWhen: (previous, current) {
          final hasDeleted =
              !previous.postDeletionSuccess && current.postDeletionSuccess;
          final failedToDelete =
              previous.transientFailure == null &&
              current.transientFailure != null;
          return hasDeleted || failedToDelete;
        },
        listener: (previous, state) {
          if (state.postDeletionSuccess) {
            final navigator = Navigator.of(context);
            if (navigator.canPop()) navigator.pop();
            if (navigator.canPop()) navigator.pop();
            return;
          }
          if (state.transientFailure != null) {
            showSnackbar(context, message: state.transientFailure!.message);
            context.read<PostDetailBloc>().add(
              PostDetailTransientFailureConsumed(),
            );
          }
        },
        child: PostDetailView(postId: postId),
      ),
    );
  }
}

class PostDetailView extends StatefulWidget {
  const PostDetailView({super.key, required this.postId});
  final String postId;

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PostCommentsBloc>().add(
        PostCommentsLoadMore(postId: widget.postId),
      );
    }
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    final postDetailBloc = context.read<PostDetailBloc>();

    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: postDetailBloc,
          child: BlocBuilder<PostDetailBloc, PostDetailState>(
            builder: (context, state) {
              final _isSubmitting = state.status == PostDetailStatus.submitting;
              return PopScope(
                canPop: !_isSubmitting,
                child: AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content: const Text(
                    'Are you sure you want to delete the post!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              postDetailBloc.add(const PostDeletedEvent());
                            },
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      barrierDismissible:
          postDetailBloc.state.status == PostDetailStatus.submitting,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select(
      (AuthenticationBloc bloc) => bloc.state.user,
    );
    final currentUserRole = currentUser?.role;
    return BlocBuilder<PostDetailBloc, PostDetailState>(
      builder: (context, state) {
        switch (state.status) {
          case PostDetailStatus.initial || PostDetailStatus.loading:
            return Scaffold(
              appBar: AppBar(title: const Text('Detail')),
              body: const Center(child: CircularProgressIndicator.adaptive()),
            );
          case PostDetailStatus.failing:
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text(
                  'Error : ${state.failure?.message ?? 'Unknown Error'}',
                ),
              ),
            );
          case _:
            final post = state.post!;
            final canModfyPost =
                (currentUser?.id == post.authorID) &&
                (currentUserRole == Role.admin);

            return Scaffold(
              appBar: AppBar(
                title: Text(post.title),
                actions: [
                  if (canModfyPost)
                    IconButton(
                      onPressed: () {
                        context.pushNamed(
                          RouteNames.postEdit,
                          pathParameters: {'postId': post.postId},
                        );
                      },
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Edit Post',
                    ),
                  if (canModfyPost)
                    IconButton(
                      onPressed: () {
                        _showDeleteConfirmDialog(context);
                      },
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Delete Post',
                    ),
                ],
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _buildContent(context, post)),
                  CommentEditView(
                    postId: widget.postId,
                    scrollController: _scrollController,
                  ),
                ],
              ),
            );
        }
      },
    );
  }

  Widget _buildContent(BuildContext context, PostDisplay post) {
    return BlocListener<PostCommentsBloc, PostCommentsState>(
      listenWhen: (previousFailure, currentFailure) {
        final prevTransientFailure = previousFailure.transientFailure;
        final currentTransientFailure = currentFailure.transientFailure;
        final isTransientFailure =
            prevTransientFailure == null && currentTransientFailure != null;
        return isTransientFailure;
      },
      listener: (context, errorState) {
        showSnackbar(context, message: errorState.transientFailure!.message);
        context.read<PostCommentsBloc>().add(
          const PostCommentsTransientFailureConsumed(),
        );
      },
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<PostDetailBloc>().add(
            PostDetailFetched(postId: widget.postId),
          );
          context.read<PostCommentsBloc>().add(
            PostCommentsRefreshed(postId: widget.postId),
          );
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildPostDetail(context, post)),
            const SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: CommentListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostDetail(BuildContext context, PostDisplay post) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          InkWell(
            onTap: () {
              final currentUserId = context
                  .read<AuthenticationBloc>()
                  .state
                  .user
                  ?.id;
              if (currentUserId != post.authorID) {
                context.pushNamed(
                  RouteNames.userDetail,
                  pathParameters: {'userId': post.authorID},
                );
              }
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.amberAccent,
                  child: post.authorAvatarUrl == null ||
                          post.authorAvatarUrl!.isEmpty
                      ? const Icon(Icons.person_2, size: 24, color: Colors.blue)
                      : ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: post.authorAvatarUrl!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(strokeWidth: 2),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error_outline, size: 24),
                            fit: BoxFit.cover,
                            width: 48,
                            height: 48,
                          ),
                        ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'yyyy-MM-dd HH:mm',
                        ).format(post.postCreatedAt),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: 250,
                      imageUrl: post.imageUrl!,
                      placeholder: (context, url) => AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(color: Colors.blueAccent.shade400),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported_outlined),
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 24),
                Text(post.title),
                const SizedBox(height: 24),
                Text(post.content),
                const SizedBox(height: 24),
                Text(post.likesCount.toString()),

                Row(
                  children: [
                    IconButton(
                      onPressed:
                          context.read<PostDetailBloc>().state.status ==
                              PostDetailStatus.submitting
                          ? null
                          : () {
                              context.read<PostDetailBloc>().add(
                                const PostDetailLikeToggled(),
                              );
                            },
                      icon: Icon(
                        post.currentUserLiked
                            ? Icons.thumb_up
                            : Icons.thumb_up_alt_outlined,
                        color: post.currentUserLiked
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    ),
                    Text(post.likesCount.toString()),
                    const SizedBox(width: 16),
                    const Icon(Icons.mode_comment_outlined, size: 24),
                    const SizedBox(width: 16),
                    Text(post.commentCount.toString()),
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
