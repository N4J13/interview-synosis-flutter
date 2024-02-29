import 'package:dio/dio.dart';
import 'package:users/application/model/user_model.dart';

class UserRepository {
  final client = Dio();

  Future<List<User>> getUser() async {
    final List<User> users = [];

    final response = await client.get('https://reqres.in/api/users');

    if (response.statusCode == 200) {
      for (var item in response.data['data']) {
        users.add(User.fromJson(item));
      }
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
