import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users/application/model/user_model.dart';
import 'package:users/application/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  List<User> users = [];

  final formKey = GlobalKey<FormState>();


  void getUser() async {
    emit(UserLoading());
    try {
      final response = await UserRepository().getUser();
      users = response;
      emit(UserLoaded());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void addUser(User user) {
    if (!formKey.currentState!.validate()) return;
    users.insert(0, user);
    emit(UserLoaded());
  }

  void deleteUser(User user) {
    users.remove(user);
    emit(UserLoaded());
  }

  void updateUser(User user) {
    final index = users.indexWhere((element) => element.id == user.id);
    users[index] = user;
    emit(UserLoaded());
  }

}
