import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qg_flutter_base/base/snackbar_config/snackbar_config.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';
import 'package:qg_flutter_base/widgets/spaces/space.dart';

class OverlaySnackBar extends SnackBar {
  OverlaySnackBar({Key? key, required SnackBarConfig config})
      : super(
          key: key,
          padding: EdgeInsets.zero,
          margin:
              const EdgeInsets.only(top: 60, left: 15, right: 15, bottom: 3),
          duration: config.duration ?? const Duration(seconds: 3),
          onVisible: () {},
          elevation: 9,
          content: HookBuilder(
            builder: (context) {
              final duration =
                  config.duration ?? const Duration(milliseconds: 2700);
              const timeoutDuration = Duration(seconds: 50);
              final theme = Theme.of(context);
              final animationController = useAnimationController(
                duration: config.duration ??
                    (config.future != null ? timeoutDuration : duration),
                initialValue: config.future != null ? 1 : 0,
              )..forward().then((_) {
                  if (config.future == null) config.afterCallback?.call();
                });

              if (config.future != null) {
                Future.wait([
                  config.future!,
                  Future.delayed(
                    duration,
                  ),
                ]).then((_) {
                  config.afterCallback?.call();
                  ScaffoldMessenger.of(context).clearSnackBars();
                });
              }

              return SizedBox(
                height: 90,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: CurvedAnimation(
                              parent: animationController,
                              curve: const Interval(
                                0,
                                .1,
                                curve: Curves.ease,
                              ),
                            ),
                            child: Material(
                              // color: theme.colorScheme.surface,
                              color: Colors.transparent,

                              clipBehavior: Clip.hardEdge,
                              shape: const StadiumBorder(),
                              child: (config.future != null)
                                  ? const LinearProgressIndicator(
                                      backgroundColor: Colors.transparent,
                                      color: Colors.blue,
                                      minHeight: 5,
                                    )
                                  : ProgressBar(
                                      progress: animationController,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (config.label != null)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  top: 8,
                                  right: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Space.small(),
                                    Text(
                                      config.label!,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    if (config.description != null) ...[
                                      const Space.small(),
                                      Text(
                                        config.description!,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (config.widget != null) config.widget!,
                              if (config.actionCallback != null &&
                                  config.actionLabel != null &&
                                  config.widget == null)
                                TextButton(
                                  onPressed: config.actionCallback,
                                  child: Text(
                                    config.actionLabel!,
                                  ),
                                ),
                              CloseButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
}

class ProgressBar extends StatelessWidget {
  final double height;
  final Animation<double> progress;

  const ProgressBar({
    Key? key,
    required this.progress,
    this.height = 5,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = context.theme();
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        final maxWidth = boxConstraints.maxWidth;
        return AnimatedBuilder(
          animation: progress,
          builder: (context, _) {
            final percent = maxWidth * (progress.value);
            return Stack(
              children: [
                Container(
                  width: maxWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration.zero,
                  width: percent,
                  height: height,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
