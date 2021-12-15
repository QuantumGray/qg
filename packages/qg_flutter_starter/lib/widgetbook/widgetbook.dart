import 'package:flutter/material.dart';
import 'package:qg_flutter_starter/base/defaults.dart';
import 'package:qg_flutter_starter/base/theme/theme.dart';
import 'package:widgetbook/widgetbook.dart';

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const defaults = AppDefaults();
    return Widgetbook(
      lightTheme: AppTheme.light().dataWith(defaults: defaults),
      darkTheme: AppTheme.dark().dataWith(defaults: defaults),
      categories: [
        WidgetbookCategory(
          name: 'widgets',
          widgets: [
            WidgetbookWidget(
              name: '$AppBar',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => AppBar(),
                ),
              ],
            ),
          ],
          folders: [
            WidgetbookFolder(
              name: 'Texts',
              widgets: [
                WidgetbookWidget(
                  name: 'Normal Text',
                  useCases: [
                    WidgetbookUseCase(
                      name: 'Default',
                      builder: (context) => Text(
                        'The brown fox ...',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
      appInfo: AppInfo(
        name: 'Widgetbook Example',
      ),
    );
  }
}
