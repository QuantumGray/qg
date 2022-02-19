import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class HotReload extends StatelessWidget {
  const HotReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook(
      appInfo: AppInfo(
        name: 'qg_flutter_base',
      ),
      categories: [
        WidgetbookCategory(
          name: 'widgets',
          widgets: [
            WidgetbookWidget(
              name: '$Text',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Text("test"),
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
      darkTheme: ThemeData.dark(),
      lightTheme: ThemeData.light(),
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
