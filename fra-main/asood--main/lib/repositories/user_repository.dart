import 'package:asood/services/api_status.dart';
import 'package:asood/services/user_api_service.dart';

class UserRepository {
  final UserApiService userApiService = UserApiService();

  Future<dynamic> sendCode(String number) async {
    return await userApiService.userAuth(number);
  }

  //verify user and if user had data save in its model
  Future<dynamic> verifyCode(String number, String code) async {
    return await userApiService.verifyUser(number, code);
  }

  //logout user
  Future<dynamic> logout() async {
    var res = await userApiService.logout();
    if (res is Success) {
      return res;
    } else {
      return res;
    }
  }
}
