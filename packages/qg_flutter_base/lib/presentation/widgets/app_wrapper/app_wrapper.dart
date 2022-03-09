// import 'package:device_preview/device_preview.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pixel_perfect/pixel_perfect.dart';
import 'package:qg_flutter_base/base/theme/theme_notifier.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';
import 'package:qg_flutter_base/presentation/widgets/app_wrapper/app_wrapper_config.dart';
import 'package:qg_flutter_base/presentation/widgets/lifecycle_manager.dart';
import 'package:qg_flutter_base/presentation/widgets/wrappers.dart';
import 'package:qg_flutter_base/repositories/navigation/navigation_repository.dart';
import 'package:spaces/spaces.dart';

import '../animated_splash_screen.dart';
import '../widgets_scope.dart';

// provider watcher builder instead of direct provider
// authStateChanged listenable (stream)
// router callback called with every watched provider listens for redirect
// QA wrapper - device preview + widgetbook +
// encapsulate appwrapper parameters in a class
class AppWrapper extends ConsumerStatefulWidget {
  // CONFIG
  final AppWrapperConfig config;
  // final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  // final Iterable<Locale> supportedLocales;
  // final Locale? Function(List<Locale>?, Iterable<Locale>)?
  //     localeListResolutionCallback;
  // final BaseTheme baseTheme;
  // final FeedbackThemeData Function(ThemeData theme)? feedbackTheme;
  // final Widget? Function(AppLifecycleState state)? onAppLifecycleStateChanged;
  // final bool devicePreviewEnabled;
  // final Map<LogicalKeySet, Intent> shortcuts;
  // final Map<Type, Action<Intent>> Function(BuildContext context)?
  //     actionsBuilder;
  // final String? pixelPerfectAsset;
  // // ROUTER
  // final String? initialLocation;
  // final List<NavigatorObserver>? observers;
  // final List<GoRoute> routes;
  // final Page<dynamic> Function(BuildContext, GoRouterState)? errorPageBuilder;
  // final Listenable? refreshListenable;
  // final GoRouterRedirector? redirector;
  // final List<Wrapper>? navigatorWrappers;
  // // PROVIDER OVERRIDES
  // final ProviderFamily<SpacingData, MediaQueryData>? spacingProvider;
  // final IDefaults defaults;
  // final IAppWidgetsFactory appWidgets;
  // // SPLASH
  // final SplashConfig? splashConfig;
  // final bool routerShouldRefresh;
  // final bool debugShowCheckedModeBanner;

  const AppWrapper({
    Key? key,
    required this.config,
    //
    // this.localizationsDelegates,
    // this.supportedLocales = const <Locale>[Locale('en', 'US')],
    // this.localeListResolutionCallback,
    // required this.baseTheme,
    // this.feedbackTheme,
    // this.onAppLifecycleStateChanged,
    // this.observers,
    // this.redirector,
    // this.initialLocation,
    // required this.routes,
    // this.errorPageBuilder,
    // this.refreshListenable,
    // this.devicePreviewEnabled = false,
    // this.shortcuts = const {},
    // this.actionsBuilder,
    // this.pixelPerfectAsset,
    // this.navigatorWrappers,
    // this.spacingProvider,
    // required this.defaults,
    // required this.appWidgets,
    // this.splashConfig,
    // this.routerShouldRefresh = false,
    // this.debugShowCheckedModeBanner = true,
  }) : super(key: key);
  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends ConsumerState<AppWrapper> {
  AppWrapper get _ => widget;

  AppWrapperConfig get config => _.config;
  AppConfig get appConfig => config.appConfig;
  RouterConfig get routerConfig => config.routerConfig;
  ProviderConfig get providerConfig => config.providerConfig;
  QaConfig get qaConfig => config.qaConfig;

  @protected
  GoRouter? _router;

  @protected
  GoRouter get router => _router ??= GoRouter(
        observers: routerConfig.observers,
        urlPathStrategy: UrlPathStrategy.path,
        refreshListenable: routerConfig.refreshListenable
          ?..addListener(() {
            _router?.refresh();
          }),
        redirect: routerConfig.redirector?.redirect,
        initialLocation: routerConfig.splashConfig != null ? '/splash' : '/',
        routes: [
          ...routerConfig.routes,
          if (routerConfig.splashConfig != null) _splashRoute,
        ],
        errorPageBuilder: routerConfig.errorPageBuilder ??
            (context, state) => MaterialPage(
                  child: Scaffold(
                    body: ref.read(pWidgets).exceptionIndicator(context),
                  ),
                ),
        navigatorBuilder: (context, navigator) => Defaults(
          defaults: providerConfig.defaults,
          child:
              // DevicePreview(
              //   enabled: qaConfig.devicePreviewEnabled,
              //   builder: (context) =>

              AppWidgets(
            widgets: providerConfig.appWidgets,
            child: Shortcuts(
              shortcuts: appConfig.shortcuts,
              child: Actions(
                actions: appConfig.actionsBuilder != null
                    ? appConfig.actionsBuilder!(context)
                    : const {},
                child: LifecycleManager(
                  onAppLifecycleStateChanged:
                      appConfig.onAppLifecycleStateChanged,
                  child: Wrappers(
                    wrappers: [
                      if (qaConfig.pixelPerfectAsset != null)
                        (context, child) => PixelPerfect(
                              assetPath: qaConfig.pixelPerfectAsset,
                              child: child,
                            ),
                      ...?routerConfig.navigatorWrappers,
                    ],
                    child: Spacing(
                      dataBuilder: (context) => ref.watch(
                        providerConfig.spacingProvider != null
                            ? providerConfig.spacingProvider!(context.media())
                            : pSpacing(context.media()),
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
    final config = routerConfig.splashConfig!;
    return GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: AnimatedSplashScreen.withScreenFunction(
          duration: config.splashDuration?.inMilliseconds ?? 1000,
          splash: Align(
            child: config.splashWidget,
          ),
          screenFunction: config.splashSetup,
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
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<NavigationState>(
      pNavigationRepository,
      (_, state) => state.routerFunction?.call(router),
    );

    final themeNotifier = ref.watch(pThemeNotifier)
      ..setBaseTheme(appConfig.baseTheme, false);

    return BetterFeedback(
      localizationsDelegates: appConfig.localizationsDelegates!.toList(),
      localeOverride: const Locale('en'),
      theme: appConfig.feedbackTheme?.call(
        themeNotifier.mode(
          providerConfig.defaults,
          providerConfig.appWidgets,
        ),
      ),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: qaConfig.debugShowCheckedModeBanner,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        theme: themeNotifier.mode(
          providerConfig.defaults,
          providerConfig.appWidgets,
        ),
        localizationsDelegates:
            appConfig.localizationsDelegates, // Add this line
        supportedLocales: appConfig.supportedLocales,
        localeListResolutionCallback: appConfig.localeListResolutionCallback,
      ),
    );
  }
}
