import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users/application/bloc/user_cubit.dart';
import 'package:users/application/model/user_model.dart';
import 'package:users/screens/edit_screen.dart';
import 'package:users/widgets/loading_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserCubit userCubit = context.read<UserCubit>()..getUser();
    return Scaffold(
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: LoadingWidget(
              loading: state is UserLoading,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Users",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        
                      ],
                    ),
                  ),
                  ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final user = userCubit.users[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListTile(
                              onLongPress: () {
                                deleteConfirm(context, userCubit, user);
                              },
                              onTap: () {
                                Navigator.push(
                                    context,
                                    (MaterialPageRoute(
                                        builder: (context) =>
                                            EditScreen(user: user, bloc: userCubit,))));
                              },
                              title: Text("${user.firstName} ${user.lastName}"),
                              subtitle: Text(user.email),
                              trailing: IconButton(
                                onPressed: () {
                                  deleteConfirm(context, userCubit, user);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user.avatar),
                                radius: 25,
                                child: Text(
                                  user.id.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                              )),
                        )
                        );
                      },
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics())),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditScreen(
                          length: userCubit.users.length,
                          bloc: userCubit,
                        )));
          },
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.add, color: Colors.white)),
    );
  }

  void deleteConfirm(context, UserCubit bloc, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: const Text("Are you sure you want to delete this user?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                bloc.deleteUser(user);
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
