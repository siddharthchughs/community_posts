import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../src/config/router/router_constants.dart';
import '../../../../src/di/di.dart';
import '../../../../src/utils/auth_states.dart';
import '../../../../src/utils/ui_utils.dart';
import '../blocs/login/login_bloc.dart';
import 'package:string_validator/string_validator.dart' as validator;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (context) => getIt<LoginBloc>(), child: LoginView());
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    context.read<LoginBloc>().add(
      LoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        backgroundColor: Colors.white,
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              showSnackbar(context, message: state.failure.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is LoadProgressState;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autovalidateMode,
                    child: Column(
                      children: [
                        const Text('Community Board'),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            label: Text('Email'),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!validator.isEmail(value.trim())) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !isLoading,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            label: Text('Password'),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Please enter atleast 623 characters';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: isLoading ? null : (_) => _submit(),
                          enabled: !isLoading,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.amber,
                                  ),
                                )
                              : const Text('Login'),
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.goNamed(RouteNames.signup);
                                },
                          child: const Text('Not a member, SignUp'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
