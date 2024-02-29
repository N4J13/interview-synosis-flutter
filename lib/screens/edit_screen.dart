import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:users/application/bloc/user_cubit.dart';
import 'package:users/application/model/user_model.dart';

class EditScreen extends StatelessWidget {
  User? user;
  int? length;
  UserCubit? bloc;
  EditScreen({super.key, this.user, this.length, this.bloc});

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    UserCubit userCubit = context.read<UserCubit>();

    if (user != null) {
      firstNameController.text = user!.firstName;
      lastNameController.text = user!.lastName;
      emailController.text = user!.email;
    }
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user != null ? "Edit User" : "Add User",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: userCubit.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: firstNameController,
                          autovalidateMode: AutovalidateMode.always,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            
                          ]),
                          decoration: const InputDecoration(
                              labelText: "First Name",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.deepPurple))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: lastNameController,
                          autovalidateMode: AutovalidateMode.always,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          decoration: const InputDecoration(
                              labelText: "Last Name",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.deepPurple))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: emailController,
                          autovalidateMode: AutovalidateMode.always,
                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email()
                          ]),
                          decoration: const InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.deepPurple))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                          User updatedUser = User(
                            id: user?.id ?? length! + 1,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            avatar: user?.avatar ?? "https://reqres.in/img/faces/1-image.jpg",
                          );
                          if (user != null) {
                            bloc?.updateUser(updatedUser);
                          } else {
                            bloc?.addUser(updatedUser);
                          }
                        },

                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                user != null ? "Update" : "Add",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                                textAlign: TextAlign.center,
                              )),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
