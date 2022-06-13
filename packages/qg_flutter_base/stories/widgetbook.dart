import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class HotReload extends StatelessWidget {
  const HotReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook(
      themes: const [
        // ThemeData.dark(),
        // ThemeData.light(),
      ],
      appInfo: AppInfo(
        name: 'qg_flutter_base',
      ),
      categories: [
        WidgetbookCategory(
          name: 'widgets',
          widgets: [
            WidgetbookComponent(
              name: '$Text',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => const Text("test"),
                ),
              ],
            ),
          ],
          folders: [
            WidgetbookFolder(
              name: 'Texts',
              widgets: [
                WidgetbookComponent(
                  name: 'Normal Text',
                  useCases: [
                    WidgetbookUseCase(
                      name: 'Default',
                      builder: (context) => const Text(
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
      devices: [
        Apple.iPhone11,
        Apple.iPhone12,
        Samsung.s10,
        Samsung.s21ultra,
        Device(
          name: 'Custom Device',
          resolution: Resolution.dimensions(
            nativeWidth: 500,
            nativeHeight: 500,
            scaleFactor: 2,
          ),
          type: DeviceType.tablet,
        ),
      ],
    );
  }
}
