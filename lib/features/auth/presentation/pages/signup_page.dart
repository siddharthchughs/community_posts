import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:string_validator/string_validator.dart' as validator;

import '../../../../src/config/router/router_constants.dart';
import '../../../../src/di/di.dart';
import '../../../../src/errors/failures.dart';
import '../../../../src/utils/auth_states.dart';
import '../../../../src/utils/ui_utils.dart';
import '../blocs/signup/signup_bloc.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => getIt<SignupBloc>(),
    child: const SignUpView(),
  );
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _userTextController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Timer? _cooldownTimer;
  DateTime? _cooldownUntil;

  bool _isCooldownActive() {
    if (_cooldownUntil == null) return false;

    final isActive = DateTime.now().isBefore(_cooldownUntil!);
    if (!isActive) {
      _cooldownUntil = null;
    }
    return isActive;
  }

  void _startCooldown() {
    _cooldownUntil = DateTime.now().add(const Duration(seconds: 30));
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _register() {
    if (_isCooldownActive()) {
      showSnackbar(
        context,
        message: 'Too many attempts. Please wait 45 seconds and try again.',
      );
      return;
    }

    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    _startCooldown();

    context.read<SignupBloc>().add(
      SignUpRequest(
        email: _emailController.text.trim(),
        username: _userTextController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('SignUp')),
        backgroundColor: Colors.white,
        body: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupFailure) {
              showSnackbar(context, message: state.failure.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is SignupProgress;
            final isCooldownActive = _isCooldownActive();
            final isButtonDisabled = isLoading || isCooldownActive;
            return SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 40),
                      const Text('Community Board'),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _userTextController,
                        decoration: const InputDecoration(
                          label: Text('Username'),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your username';
                          }
                          if (value.trim().length < 2) {
                            return 'Please enter atleast 2 charcaters for username';
                          }
                          if (value.trim().length > 20) {
                            return 'Please enter characters up to 20 characters long.';
                          }
                          if (validator.isEmail(value.trim())) {
                            return 'Please a valid username';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(label: Text('Email')),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!validator.isEmail(value.trim())) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          label: Text('Password'),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.trim().length < 6) {
                            return 'Please enter password atleast 6 characters';
                          }
                          if (value.trim().length > 20) {
                            return 'Please enter password upto 20 characters';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          label: Text('Confirm Password'),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value != _passwordController.text) {
                            return 'password does not match';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: isLoading ? null : (_) => _register(),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isButtonDisabled ? null : _register,
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.amber,
                                ),
                              )
                            : Text(isCooldownActive ? 'Please wait' : 'SignUp'),
                      ),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.goNamed(RouteNames.login);
                              },
                        child: const Text('Already a member, Login'),
                      ),
                    ],
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
    _cooldownTimer?.cancel();
    _userTextController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
