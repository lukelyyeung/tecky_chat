import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/auth/blocs/register_form_cubit.dart';
import 'package:tecky_chat/features/auth/repositories/auth_repository.dart';
import 'package:tecky_chat/theme/colors.dart';
import 'package:tecky_chat/theme/theme.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: const _RegisterScreen(),
        create: (_) => RegisterFormCubit(
            authRepository: RepositoryProvider.of<AuthRepository>(context, listen: false)));
  }
}

class _RegisterScreen extends StatefulWidget {
  const _RegisterScreen({Key? key}) : super(key: key);

  @override
  State<_RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<_RegisterScreen> {
  String? _email;
  String? _password;
  String? _confirmPassword;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.neutralWhite,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                Image.asset(
                  'assets/images/tecky_splash.png',
                  filterQuality: FilterQuality.high,
                ),
                const Text(
                  'Create an account and start journey',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 48),
                TextFormField(
                    validator: (input) {
                      if (input?.isNotEmpty != true) {
                        return 'Email is required.';
                      }

                      if (!RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(input!)) {
                        return 'Invalid email.';
                      }
                    },
                    onSaved: (input) => _email = input,
                    cursorColor: ThemeColors.neutralActive,
                    decoration: TeckyChatTheme.textFieldInputDecoration.copyWith(hintText: 'Email')),
                const SizedBox(height: 16),
                TextFormField(
                    onChanged: (input) => _password = input,
                    validator: (input) {
                      if (input?.isNotEmpty != true) {
                        return 'Password is required.';
                      }
                    },
                    onSaved: (input) => _password = input,
                    cursorColor: ThemeColors.neutralActive,
                    obscureText: true,
                    decoration:
                        TeckyChatTheme.textFieldInputDecoration.copyWith(hintText: 'Password')),
                const SizedBox(height: 16),
                TextFormField(
                    onChanged: (input) => _confirmPassword = input,
                    validator: (input) {
                      if (input?.isNotEmpty != true) {
                        return 'Confirm password is required.';
                      }

                      if (_password != _confirmPassword) {
                        return 'Password does not match.';
                      }
                    },
                    cursorColor: ThemeColors.neutralActive,
                    obscureText: true,
                    decoration: TeckyChatTheme.textFieldInputDecoration
                        .copyWith(hintText: 'Confirm Password')),
                BlocBuilder<RegisterFormCubit, RegisterFormState>(builder: (context, state) {
                  if (state.error == null) {
                    return const SizedBox(height: 0);
                  }

                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(state.error!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: ThemeColors.danger,
                            ))),
                  );
                }),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () {
                    final formState = _formKey.currentState!;

                    if (formState.validate()) {
                      formState.save();
                      context.read<RegisterFormCubit>().submitRegisterForm(
                            email: _email!,
                            password: _password!,
                          );
                    }
                  },
                  child: BlocBuilder<RegisterFormCubit, RegisterFormState>(builder: (context, state) {
                    final isLoading = state.formStatus == FormStatus.submitting;

                    return Container(
                      height: 52,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: isLoading ? ThemeColors.neutralDisabled : ThemeColors.brandDefault,
                          borderRadius: const BorderRadius.all(Radius.circular(30))),
                      child: isLoading
                          ? const CupertinoActivityIndicator()
                          : const Text('Continue',
                              style: TextStyle(
                                  color: ThemeColors.neutralWhite, fontWeight: FontWeight.w600)),
                    );
                  }),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
