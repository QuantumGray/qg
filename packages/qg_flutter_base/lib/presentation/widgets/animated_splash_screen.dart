import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

enum _splashType { simpleSplash, backgroundScreenReturn }
enum SplashTransition {
  slideTransition,
  scaleTransition,
  rotationTransition,
  sizeTransition,
  fadeTransition,
  decoratedBoxTransition
}

typedef ScreenFunction = Future<String?> Function();

class AnimatedSplashScreen extends StatefulHookWidget {
  /// Type of page transition
  final PageTransitionType transitionType;

  /// Type of splash transition
  final SplashTransition splashTransition;

  /// Only required case use [AnimatedSplashScreen.withScreenFunction]
  /// here you pass your function that need called before to jump to next screen
  final Future<String?> Function()? function;

  /// Custom animation to icon of splash
  final Animatable? customAnimation;

  /// Background color
  final Color backgroundColor;

  /// Only required in default construct, here you pass your widget that will be
  /// browsed
  final Widget? nextScreen;

  /// Type of AnimatedSplashScreen
  final _splashType type;

  /// If icon in splash need stay inside [Center] widget
  final bool centered;

  /// If you want to implement the navigation to the next page yourself.
  /// By default is [false], the widget will call Navigator.of(_context).pushReplacement()
  /// using PageTransition with [transictionType] after [duration] to [nextScreen]
  final bool disableNavigation;

  /// It can be string for [Image.asserts], normal [Widget] or you can user tags
  /// to choose which one you image type, for example:
  /// * '[n]www.my-site.com/my-image.png' to [Image.network]
  final dynamic splash;

  /// Time in milliseconds after splash animation to jump to next screen
  /// Default is [milliseconds: 2500], minimum is [milliseconds: 100]
  final int duration;

  /// Curve of splash animation
  final Curve curve;

  /// Splash animation duration, default is [milliseconds: 800]
  final Duration? animationDuration;

  /// Icon in splash screen size
  final double? splashIconSize;

  factory AnimatedSplashScreen({
    Curve curve = Curves.easeInCirc,
    ScreenFunction? function,
    int duration = 2500,
    required dynamic splash,
    required Widget nextScreen,
    Color backgroundColor = Colors.white,
    Animatable? customTween,
    bool centered = true,
    bool disableNavigation = false,
    SplashTransition? splashTransition,
    PageTransitionType? pageTransitionType,
    Duration? animationDuration,
    double? splashIconSize,
  }) {
    return AnimatedSplashScreen._internal(
      backgroundColor: backgroundColor,
      animationDuration: animationDuration,
      transitionType: pageTransitionType ?? PageTransitionType.bottomToTop,
      splashTransition: splashTransition ?? SplashTransition.fadeTransition,
      splashIconSize: splashIconSize,
      customAnimation: customTween,
      function: function,
      duration: duration,
      centered: centered,
      disableNavigation: disableNavigation,
      splash: splash,
      type: _splashType.simpleSplash,
      nextScreen: nextScreen,
      curve: curve,
    );
  }

  factory AnimatedSplashScreen.withScreenFunction({
    Curve curve = Curves.easeInCirc,
    bool centered = true,
    bool disableNavigation = false,
    int duration = 2500,
    required dynamic splash,
    ScreenFunction? screenFunction,
    Animatable? customTween,
    Color backgroundColor = Colors.white,
    SplashTransition? splashTransition,
    PageTransitionType? pageTransitionType,
    Duration? animationDuration,
    double? splashIconSize,
  }) {
    return AnimatedSplashScreen._internal(
      type: _splashType.backgroundScreenReturn,
      animationDuration: animationDuration,
      transitionType: pageTransitionType ?? PageTransitionType.bottomToTop,
      splashTransition: splashTransition ?? SplashTransition.fadeTransition,
      backgroundColor: backgroundColor,
      splashIconSize: splashIconSize,
      customAnimation: customTween,
      function: screenFunction,
      duration: duration,
      centered: centered,
      disableNavigation: disableNavigation,
      nextScreen: null,
      splash: splash,
      curve: curve,
    );
  }

  const AnimatedSplashScreen._internal({
    required this.animationDuration,
    required this.splashTransition,
    required this.customAnimation,
    required this.backgroundColor,
    required this.transitionType,
    required this.splashIconSize,
    required this.nextScreen,
    required this.function,
    required this.duration,
    required this.centered,
    required this.disableNavigation,
    required this.splash,
    required this.curve,
    required this.type,
  });

  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  AnimatedSplashScreen get w => widget;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: w.animationDuration ?? const Duration(milliseconds: 800),
      vsync: this,
    );

    final animation = w.customAnimation ??
        () {
          switch (w.splashTransition) {
            case SplashTransition.slideTransition:
              return Tween<Offset>(
                end: Offset.zero,
                begin: const Offset(1, 0),
              );

            case SplashTransition.decoratedBoxTransition:
              return DecorationTween(
                end: const BoxDecoration(color: Colors.black87),
                begin: const BoxDecoration(color: Colors.redAccent),
              );

            default:
              return Tween(begin: 0.0, end: 1.0);
          }
        }() as Animatable<dynamic>;

    _animation = animation
        .animate(CurvedAnimation(parent: _animationController, curve: w.curve));
    _animationController.forward().then((_) {
      if (w.function == null) {
        _complete();
      }
    });

    if (w.function != null) {
      w.function!().then((String? route) => _complete(route: route));
    }
  }

  @override
  void dispose() {
    _animationController.reset();
    _animationController.dispose();
    super.dispose();
  }

  void _complete({String? route}) {
    if (route != null) {
      GoRouter.of(_context).go(route);
    }
  }

  Widget _splash() {
    final size =
        w.splashIconSize ?? MediaQuery.of(context).size.shortestSide * 0.2;

    Widget main({required Widget child}) =>
        w.centered ? Center(child: child) : child;

    return _transition(
      child: main(
        child: SizedBox(
          height: size,
          child: w.splash is String
              ? <Widget>() {
                  return Image.asset(w.splash as String);
                }()
              : (w.splash is IconData
                  ? Icon(w.splash as IconData, size: size)
                  : w.splash as Widget),
        ),
      ),
    );
  }

  /// return transtion
  Widget _transition({required Widget child}) {
    switch (w.splashTransition) {
      case SplashTransition.slideTransition:
        return SlideTransition(
          position: _animation as Animation<Offset>,
          child: child,
        );

      case SplashTransition.scaleTransition:
        return ScaleTransition(
          scale: _animation as Animation<double>,
          child: child,
        );

      // case SplashTransition.rotationTransition:
      //   return RotationTransition(
      //       turns: (_animation as Animation<double>), child: child);
      //   break;

      // case SplashTransition.sizeTransition:
      //   return SizeTransition(
      //       sizeFactor: (_animation as Animation<double>), child: child);
      //   break;

      // case SplashTransition.fadeTransition:
      //   return FadeTransition(
      //       opacity: (_animation as Animation<double>), child: child);
      //   break;

      // case SplashTransition.decoratedBoxTransition:
      //   return DecoratedBoxTransition(
      //       decoration: (_animation as Animation<Decoration>), child: child);
      //   break;

      default:
        return FadeTransition(
          opacity: _animation as Animation<double>,
          child: child,
        );
    }
  }

  static late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: w.backgroundColor,
      body: _splash(),
    );
  }
}
