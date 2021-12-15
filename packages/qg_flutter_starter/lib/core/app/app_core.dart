import 'package:flutter/material.dart';
import 'package:qg_flutter_base/presentation/presentation.dart';
import 'package:qg_flutter_starter/base/app_widgets.dart';
import 'package:qg_flutter_starter/base/defaults.dart';
import 'package:qg_flutter_starter/base/theme/theme.dart';

class AppCore extends ConsumerStatefulWidget {
  const AppCore({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppCoreState();
}

class _AppCoreState extends ConsumerState<AppCore> {
  @override
  Widget build(BuildContext context) {
    const defaults = AppDefaults();
    return AppWrapper(
      appWidgets: const AppWidgetsFactory(),
      defaults: const AppDefaults(),
      // THEME
      lightTheme: AppTheme.light().dataWith(defaults: defaults),
      darkTheme: AppTheme.dark().dataWith(defaults: defaults),
      // LOCALIZATIONS
      // localizationsDelegates: ,
      // supportedLocales: ,
      // localeListResolutionCallback: ,
      // ROUTER
      routerShouldRefresh: true,
      initialLocation: '/',
      routes: _routes,
      redirector: _redirector,
    );
  }

  List<GoRoute> get _routes => [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const MaterialPage(
            child: Scaffold(
              body: Text('Hello World'),
            ),
          ),
        ),
      ];

  GoRouterRedirector get _redirector => GoRouterRedirector([MainRedirect(ref)]);
}

class MainRedirect extends Redirect {
  MainRedirect(this.ref);

  final WidgetRef ref;

  @override
  Uri? getNewUri(GoRouterState state) {
    const String? user = null;

    String? route;

    if (state.location == '/register-store') {
      return null;
    }

    const loggedIn = user != null;
    final goingToOnboarding = state.location == '/onboarding';
    final goingToHome = state.location == '/';

    if (!loggedIn && !goingToOnboarding) {
      route = '/onboarding';
    }

    if (loggedIn && !goingToHome) {
      route = '/';
    }

    if (route != null) {
      return Uri.parse(route);
    }

    return null;
  }

  @override
  bool predicate(GoRouterState state) => true;
}
