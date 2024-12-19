import 'package:get/get.dart';
import 'package:sample_chat_app/pages/home_page.dart';
import 'package:sample_chat_app/pages/login_page.dart';
import 'package:sample_chat_app/pages/register_page.dart';

class Routes {
  Routes._();

  static const String initialRoute = "/login";

  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginPage(),
    ),
    GetPage(
      name: '/registration',
      page: () => const RegistrationPage(),
    ),
    GetPage(
      name: '/home',
      page: () => const HomePage(),
    ),
  ];
}
