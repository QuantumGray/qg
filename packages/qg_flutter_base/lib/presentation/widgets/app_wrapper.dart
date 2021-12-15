// import 'package:device_preview/device_preview.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pixel_perfect/pixel_perfect.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';
import 'package:qg_flutter_base/presentation/widgets/widgets.dart';
import 'package:qg_flutter_base/repositories/navigation/navigation_repository.dart';
import 'package:spaces/spaces.dart';

import 'animated_splash_screen.dart';

class AppWrapper extends ConsumerStatefulWidget {
  // CONFIG
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final Locale? Function(List<Locale>?, Iterable<Locale>)?
      localeListResolutionCallback;
  final ThemeData darkTheme;
  final ThemeData lightTheme;
  final ThemeMode themeMode;
  final Widget? Function(AppLifecycleState state)? onAppLifecycleStateChanged;
  final bool devicePreviewEnabled;
  final Map<LogicalKeySet, Intent> shortcuts;
  final Map<Type, Action<Intent>> Function(BuildContext context)?
      actionsBuilder;
  final String? pixelPerfectAsset;
  // ROUTER
  final String? initialLocation;
  final List<NavigatorObserver>? observers;
  final List<GoRoute> routes;
  final Page<dynamic> Function(BuildContext, GoRouterState)? errorPageBuilder;
  final Listenable? refreshListenable;
  final GoRouterRedirector? redirector;
  final List<Wrapper>? navigatorWrappers;
  // PROVIDER OVERRIDES
  final ProviderFamily<SpacingData, MediaQueryData>? spacingProvider;
  final IDefaults defaults;
  final IAppWidgetsFactory appWidgets;
  // SPLASH
  final SplashConfig? splashConfig;
  final bool routerShouldRefresh;

  const AppWrapper({
    Key? key,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localeListResolutionCallback,
    required this.darkTheme,
    required this.lightTheme,
    this.themeMode = ThemeMode.system,
    this.onAppLifecycleStateChanged,
    this.observers,
    this.redirector,
    this.initialLocation,
    required this.routes,
    this.errorPageBuilder,
    this.refreshListenable,
    this.devicePreviewEnabled = false,
    this.shortcuts = const {},
    this.actionsBuilder,
    this.pixelPerfectAsset,
    this.navigatorWrappers,
    this.spacingProvider,
    required this.defaults,
    required this.appWidgets,
    this.splashConfig,
    this.routerShouldRefresh = false,
  }) : super(key: key);
  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends ConsumerState<AppWrapper> {
  AppWrapper get _ => widget;

  RefreshListenableWrapper get refreshListenableWrapper =>
      RefreshListenableWrapper(listenable: _.refreshListenable);

  GoRouter? _router;

  GoRouter get router => _router ??= GoRouter(
        observers: _.observers,
        urlPathStrategy: UrlPathStrategy.path,
        refreshListenable: _.refreshListenable,
        redirect: _.redirector?.redirect,
        initialLocation: _.splashConfig != null ? '/splash' : '/',
        routes: [
          ..._.routes,
          if (_.splashConfig != null) _splashRoute,
        ],
        errorPageBuilder: _.errorPageBuilder ??
            (context, state) => MaterialPage(
                  child: Scaffold(
                    body: ref.read(pWidgets).exceptionIndicator(context),
                  ),
                ),
        navigatorBuilder: (context, navigator) => Defaults(
          defaults: _.defaults,
          child:
              // DevicePreview(
              //   enabled: _.devicePreviewEnabled,
              //   builder: (context) =>

              AppWidgets(
            widgets: _.appWidgets,
            child: Shortcuts(
              shortcuts: _.shortcuts,
              child: Actions(
                actions: _.actionsBuilder != null
                    ? _.actionsBuilder!(context)
                    : const {},
                child: LifecycleManager(
                  onAppLifecycleStateChanged: _.onAppLifecycleStateChanged,
                  child: Wrappers(
                    wrappers: [
                      if (_.pixelPerfectAsset != null)
                        (context, child) => PixelPerfect(
                              assetPath: _.pixelPerfectAsset,
                              child: child,
                            ),
                      ...?_.navigatorWrappers,
                    ],
                    child: Spacing(
                      dataBuilder: (context) => ref.watch(
                        _.spacingProvider != null
                            ? _.spacingProvider!(context.media())
                            : pDefaultSpacing(context.media()),
                      ),
                      child: navigator!,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // ),
      );

  GoRoute get _splashRoute {
    final config = _.splashConfig!;
    return GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: AnimatedSplashScreen.withScreenFunction(
          duration: config.splashDuration?.inMilliseconds ?? 1000,
          splash: Align(
            child: config.splashWidget,
          ),
          screenFunction: () async {
            await config.splashSetup?.call();
            router.go('/');
          },
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: config.backgroundColor ??
              Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(AppWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_.routerShouldRefresh) {
      router.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<NavigationState>(
      pNavigationRepository,
      (_, state) => state.routerFunction?.call(router),
    );

    return BetterFeedback(
      child: MaterialApp.router(
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        theme: _.lightTheme,
        darkTheme: _.darkTheme,
        themeMode: _.themeMode,
        localizationsDelegates: _.localizationsDelegates, // Add this line
        supportedLocales: _.supportedLocales,
        localeListResolutionCallback: _.localeListResolutionCallback,
      ),
    );
  }
}

class GoRouterRedirector {
  const GoRouterRedirector(this._redirects);
  final List<Redirect> _redirects;

  String? redirect(GoRouterState state) {
    final current = Uri(path: state.subloc, queryParameters: state.queryParams);
    for (final redirect in _redirects) {
      if (redirect.predicate(state)) {
        final uri = redirect.getNewUri(state);
        if (uri != null) {
          final uriString = uri.toString();
          if (uriString == current.toString()) {
            return null;
          }
          return uriString;
        }
      }
    }
    return null;
  }
}

abstract class Redirect {
  const Redirect();

  /// Determines whether this redirection should take place.
  bool predicate(GoRouterState state);

  /// Returns an optional `Uri` instance if there is a redirect. This
  /// can return Null because `predicate` may return true if it knows there is
  /// zero chance any future redirect should be checked. For example, if the
  /// app is not initialized, you may know that your only possible redirect is
  /// *to* the splash screen. However, if you are already there, [getNewUri]
  /// will return null.
  Uri? getNewUri(GoRouterState state);
}

class DeepLinkRedirect extends Redirect {
  const DeepLinkRedirect();

  @override
  bool predicate(GoRouterState state) => state.subloc == 'home';

  @override
  Uri? getNewUri(GoRouterState state) {
    final location = state.location;
    if (location != state.location) {
      final queryParams = Map<String, String>.from(state.queryParams);
      queryParams['location'] = state.location;
      return Uri(
        path: state.subloc,
        queryParameters: queryParams,
      );
    }
  }
}

class RefreshListenableWrapper extends ChangeNotifier {
  final Listenable? listenable;

  RefreshListenableWrapper({this.listenable}) {
    if (listenable != null) {
      listenable!.addListener(notifyListeners);
    }
  }

  void splashDone() {
    notifyListeners();
  }
}

final pDefaultSpacing =
    Provider.family<SpacingData, MediaQueryData>((ref, media) {
  if (media.size.width > 500) {
    return SpacingData.generate(30);
  }
  return SpacingData.generate(18);
});

class SplashConfig {
  final Widget splashWidget;
  final Duration? splashDuration;
  final Future<void> Function()? splashSetup;
  final Color? backgroundColor;
  const SplashConfig({
    required this.splashWidget,
    this.splashDuration,
    this.splashSetup,
    this.backgroundColor,
  });
}
