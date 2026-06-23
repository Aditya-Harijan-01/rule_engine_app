import 'package:get/get.dart';

import '../modules/auth_page/bindings/auth_page_binding.dart';
import '../modules/auth_page/views/auth_page_view.dart';
import '../modules/execute_event/bindings/execute_event_binding.dart';
import '../modules/execute_event/views/execute_event_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/rule_editor/bindings/rule_editor_binding.dart';
import '../modules/rule_editor/views/rule_editor_view.dart';
import '../modules/rule_page/bindings/rule_page_binding.dart';
import '../modules/rule_page/views/rule_page_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH_PAGE,
      page: () => const AuthPageView(),
      binding: AuthPageBinding(),
    ),
    GetPage(
      name: _Paths.RULE_PAGE,
      page: () => const RulePageView(),
      binding: RulePageBinding(),
    ),
    GetPage(
      name: _Paths.EXECUTE_EVENT,
      page: () => const ExecuteEventView(),
      binding: ExecuteEventBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.RULE_EDITOR,
      page: () => RuleEditorView(),
      binding: RuleEditorBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
  ];
}
