import 'package:get/get.dart';

import '../../../view/home/home_binding.dart';
import '../../../view/home/home_view.dart';
part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
