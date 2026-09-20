import 'package:flutter/widgets.dart';

import 'services/settings.dart';

/// 설정을 위젯 트리에 내려주는 단순 InheritedWidget.
/// 변경 감지는 각 화면에서 [ListenableBuilder] 로 한다.
class AppScope extends InheritedWidget {
  final AppSettings settings;

  const AppScope({super.key, required this.settings, required super.child});

  static AppScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!;

  @override
  bool updateShouldNotify(AppScope old) => settings != old.settings;
}
