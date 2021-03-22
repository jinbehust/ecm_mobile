import 'package:get/get.dart';
import 'package:get_demo/pages/home/domain/entity/user.dart';
import '../service/user_service.dart';

enum Status { loading, success, error }

class LoginController extends GetxController {
  UserService databaseHelper = UserService();
  doLogin(String username, String password) {
    databaseHelper.loginData(username, password);
  }
}
