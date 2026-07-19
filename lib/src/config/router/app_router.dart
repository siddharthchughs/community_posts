import 'package:community_board/src/config/router/router_constants.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/auth/presentation/pages/signup_page.dart';
import '../../../features/post/presentation/pages/post_detail_page.dart';
import '../../../features/post/presentation/pages/post_form_page.dart';
import '../../../features/post/presentation/pages/post_page.dart';
import '../../../features/profile/edit_profile_page.dart';
import '../../../features/profile/myprofile_page.dart';
import '../../../features/profile/user_profile_page.dart';
import '../../../features/search/presentation/pages/search_page.dart';
import '../../../features/splash/presentation/pages/splash_page.dart';
import '../../widget/error_page.dart';
import '../../widget/scaffold_widget_navbar.dart';
import 'go_router_refresh_stream.dart';

GoRouter createRouter(AuthenticationBloc authBloc) {
  return GoRouter(
    initialLocation: RouteLocation.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authStatus = authBloc.state.status;
      final String location = state.matchedLocation;

      print(authStatus);
      final isCurrentStateSplash =
          location == RouteLocation.login || location == RouteLocation.splash;

      final isAuthorized =
          location == RouteLocation.login || location == RouteLocation.signup;

      if (authStatus == AuthenticationStatus.unknown) {
        return isCurrentStateSplash ? null : RouteLocation.splash;
      }

      if (authStatus == AuthenticationStatus.authorized) {
        if (isCurrentStateSplash || isAuthorized) return RouteLocation.post;
      } else {
        if (!isAuthorized) return RouteLocation.login;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteLocation.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteLocation.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteLocation.signup,
        name: RouteNames.signup,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: RouteLocation.postCreate,
        name: RouteNames.postCreate,
        builder: (context, state) => const PostFormPage(),
      ),
      GoRoute(
        path: RouteLocation.userDetail,
        name: RouteNames.userDetail,
        builder: (context, state) {
          final userId = state.pathParameters['userID'];
          return UserProfilePage(userId: userId!);
        },
      ),
      GoRoute(
        path: RouteLocation.postDetail,
        name: RouteNames.postDetail,
        builder: (context, state) {
          final postId = state.pathParameters['postId'];
          return PostDetailPage(postId: postId!);
        },
        routes: [
          GoRoute(
            path: RouteLocation.postEdit,
            name: RouteNames.postEdit,
            builder: (context, state) {
              final postID = state.pathParameters['postId'];
              return PostFormPage(postId: postID!);
            },
          ),
        ],
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWidgetNavbar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteLocation.post,
                name: RouteNames.post,
                builder: (context, state) {
                  return const PostPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteLocation.search,
                name: RouteNames.search,
                builder: (context, state) {
                  return const SearchPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteLocation.profile,
                name: RouteNames.profile,
                builder: (context, state) {
                  return const MyProfilePage();
                },
              ),
              GoRoute(
                path: RouteLocation.profileEdit,
                name: RouteNames.profileEdit,
                builder: (context, state) {
                  return const EditProfilePage();
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return ErrorPage(error: state.error);
    },
  );
}
