import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/base/theme/base_theme.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';
import 'package:qg_flutter_base/presentation/widgets/wrappers.dart';
import 'package:spaces/spaces.dart';

class AppWrapperConfig {
  final AppConfig appConfig;
  final RouterConfig routerConfig;
  final ProviderConfig providerConfig;
  final QaConfig qaConfig;
  const AppWrapperConfig({
    required this.appConfig,
    required this.routerConfig,
    required this.providerConfig,
    required this.qaConfig,
  });
}

class AppConfig {
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final Locale? Function(List<Locale>?, Iterable<Locale>)?
      localeListResolutionCallback;
  final BaseTheme baseTheme;
  final FeedbackThemeData Function(ThemeData theme)? feedbackTheme;
  final Widget? Function(AppLifecycleState state)? onAppLifecycleStateChanged;
  final Map<LogicalKeySet, Intent> shortcuts;
  final Map<Type, Action<Intent>> Function(BuildContext context)?
      actionsBuilder;

  const AppConfig({
    this.localizationsDelegates,
    required this.supportedLocales,
    this.localeListResolutionCallback,
    required this.baseTheme,
    this.feedbackTheme,
    this.onAppLifecycleStateChanged,
    required this.shortcuts,
    this.actionsBuilder,
  });
}

class RouterConfig {
  final String? initialLocation;
  final List<NavigatorObserver>? observers;
  final List<GoRoute> routes;
  final Page<dynamic> Function(BuildContext, GoRouterState)? errorPageBuilder;
  final void Function(WidgetRef ref, void Function() notifyListeners)? refresh;
  final GoRouterRedirector? redirector;
  final List<Wrapper>? navigatorWrappers;
  final SplashConfig? splashConfig;
  final bool routerShouldRefresh;

  const RouterConfig({
    this.initialLocation,
    this.observers,
    required this.routes,
    this.errorPageBuilder,
    this.refresh,
    this.redirector,
    this.navigatorWrappers,
    this.splashConfig,
    this.routerShouldRefresh = true,
  });
}

class ProviderConfig {
  final ProviderFamily<SpacingData, MediaQueryData>? spacingProvider;
  final BaseDefaults defaults;
  final BaseWidgets appWidgets;

  const ProviderConfig({
    this.spacingProvider,
    required this.defaults,
    required this.appWidgets,
  });
}

class QaConfig {
  final String? pixelPerfectAsset;
  final bool devicePreviewEnabled;
  final bool debugShowCheckedModeBanner;

  const QaConfig({
    this.pixelPerfectAsset,
    this.devicePreviewEnabled = false,
    this.debugShowCheckedModeBanner = true,
  });
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
  bool predicate(GoRouterState state);
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
    return null;
  }
}

// apprwapper core + appwrapper shell(providerscope overrides)

class SplashConfig {
  final Widget splashWidget;
  final Duration? splashDuration;
  final Future<String?> Function()? splashSetup;
  final Color? backgroundColor;
  const SplashConfig({
    required this.splashWidget,
    this.splashDuration,
    this.splashSetup,
    this.backgroundColor,
  });
}
