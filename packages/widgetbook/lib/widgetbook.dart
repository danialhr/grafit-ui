import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:grafit_ui/grafit_ui.dart';
import 'components/buttons_use_case.dart';
import 'components/inputs_use_case.dart';
import 'components/cards_use_case.dart';
import 'components/dialogs_use_case.dart';
import 'components/tabs_use_case.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              data: ThemeData(
                useMaterial3: true,
                extensions: [
                  GrafitTheme.light(),
                ],
              ),
              name: 'Light',
            ),
            WidgetbookTheme(
              data: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                extensions: [
                  GrafitTheme.dark(),
                ],
              ),
              name: 'Dark',
            ),
          ],
        ),
        TextScaleAddon(
          setting: TextScaleSetting(),
        ),
      ],
      directories: [
        WidgetbookCategory(
          name: 'Components',
          children: [
            WidgetbookComponent(
              name: 'Buttons',
              useCases: [
                WidgetbookUseCase(
                  name: 'Button Variants',
                  builder: buttonsUseCase,
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Inputs',
              useCases: [
                WidgetbookUseCase(
                  name: 'Input Field',
                  builder: inputsUseCase,
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Cards',
              useCases: [
                WidgetbookUseCase(
                  name: 'Card Component',
                  builder: cardsUseCase,
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Dialogs',
              useCases: [
                WidgetbookUseCase(
                  name: 'Dialog Component',
                  builder: dialogsUseCase,
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Tabs',
              useCases: [
                WidgetbookUseCase(
                  name: 'Tabs Component',
                  builder: tabsUseCase,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
