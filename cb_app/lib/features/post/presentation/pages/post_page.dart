import 'package:core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/post_bloc.dart';
import '../widget/post_card_item.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PostBloc>()..add(PostsFetched()),
      child: const PostPageView(),
    );
  }
}

// TO have the pagination work we need to make this page
// Stateful

class PostPageView extends StatefulWidget {
  const PostPageView({super.key});

  @override
  State<PostPageView> createState() => _PostPageView();
}

class _PostPageView extends State<PostPageView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.removeListener(_scroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PostBloc>().add(PostMorePostsFetched());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: BlocConsumer<PostBloc, PostListState>(
        listenWhen: (previous, current) {
          final isTransientFailure =
              previous.transientFailure == null &&
              current.transientFailure != null;
          return isTransientFailure;
        },
        builder: (context, state) {
          return switch (state.state) {
            PostUIState.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            PostUIState.failure => Center(
              child: Padding(
                padding: const EdgeInsetsGeometry.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error : ${state.failure?.message ?? 'Unknown Error'}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PostBloc>().add(PostsFetched());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),

            // PostUIState.loadingmore => throw UnimplementedError(),
            // PostUIState.morepostadded => throw UnimplementedError(),
            // PostUIState.refresh => throw UnimplementedError(),
            _ when state.posts.isEmpty => RefreshIndicator(
              onRefresh: () async {
                context.read<PostBloc>().add(PostsRefreshed());
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 15,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: const Center(
                        child: Text('There are no posts yet'),
                      ),
                    ),
                  );
                },
              ),
            ),
            _ => RefreshIndicator(
              onRefresh: () async {
                context.read<PostBloc>().add(PostsRefreshed());
              },
              child: ListView.builder(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: state.isLimitMax
                    ? state.posts.length
                    : state.posts.length + 1,
                itemBuilder: (context, index) {
                  if (index > state.posts.length) {
                    return (state.state == PostUIState.loadingmore)
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  }
                  final post = state.posts[index];
                  return PostCardItem(
                    postDisplayEntity: post,
                    onToogleLike: () {},
                  );
                },
              ),
            ),
          };
        },
        listener: (context, state) {
          if (state.transientFailure != null) {
            showSnackbar(context, message: state.transientFailure!.message);
            context.read<PostBloc>().add(PostsTransientFailureConsumed());
          }
        },
      ),
    );
  }
}
