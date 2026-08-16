import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils.dart';
import 'package:domain/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/di.dart';
import '../bloc/post_comments/post_comments_bloc.dart';
import '../bloc/post_detail/post_detail_bloc.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key, required this.postId});
  final String postId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<PostDetailBloc>()..add(PostDetailFetched(postId: postId)),
        ),
        BlocProvider(
          create: (context) =>
              getIt<PostCommentsBloc>()
                ..add(PostCommentsLoaded(postId: postId)),
        ),
      ],
      child: PostDetailView(postId: postId),
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
        PostCommentsLoadedMore(postId: widget.postId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailBloc, PostDetailState>(
      builder: (context, state) {
        switch (state.status) {
          case PostDetailStatus.initial || PostDetailStatus.loading:
            return Scaffold(
              appBar: AppBar(title: const Text('Detail')),
              body: Center(child: Text('Post Detail Page View')),
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
          // TODO: Handle this case.
          case _:
            final post = state.post!;
            return Scaffold(
              appBar: AppBar(title: Text('Detail')),
              body: _buildContext(context, post),
            );
        }
      },
    );
  }

  Widget _buildContext(BuildContext context, PostDisplay post) {
    return BlocListener<PostCommentsBloc, PostCommentsState>(
      listenWhen: (previous, current) {
        final prevTransientFailure = previous.transientFailure;
        final currentTransientFailure = current.transientFailure;
        final isTransientFailure =
            prevTransientFailure == null && currentTransientFailure != null;
        return isTransientFailure;
      },
      listener: (context, state) {
        showSnackbar(context, message: state.transientFailure!.message);
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
          slivers: [SliverToBoxAdapter(child: _buildPostDetail(context, post))],
        ),
      ),
    );
  }

  Widget _buildPostDetail(BuildContext context, PostDisplay post) {
    return Padding(
      padding: EdgeInsetsGeometry.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.amberAccent,
            child: post.authorAvatarUrl == null
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
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.authorName),
              Text(DateFormat('yyyy-MM-dd HH:mm').format(post.postCreatedAt)),
            ],
          ),
        ],
      ),
    );
  }
}
