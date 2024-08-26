import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jam_it/core/widgets/Loader/loader.dart';
import 'package:jam_it/core/theme/app_pallete.dart';
import 'package:jam_it/core/widgets/custom_field.dart';
import 'package:jam_it/features/auth/view/widgets/auth_button.dart';
import 'package:jam_it/features/auth/view/widgets/hero_image.dart';
import 'package:jam_it/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:jam_it/core/utils/utils.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        authViewModelProvider.select((value) => value?.isLoading == true));

    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
          data: (data) {
            snackBarPopUp(context, "Account Created Sucessfully");
            Navigator.popAndPushNamed(context, "/login");
          },
          error: (error, stackTrace) {
            snackBarPopUp(context, error.toString());
          },
          loading: () {},
        );
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const HeroImage(),
                      const SizedBox(
                        height: 35,
                      ),
                      CustomField(
                        controller: nameController,
                        hintext: 'Name',
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      CustomField(
                        controller: emailController,
                        hintext: 'Email',
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      CustomField(
                        controller: passwordController,
                        isHiddenText: true,
                        hintext: 'Password',
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      AuthButton(
                        buttonText: 'Sign Up',
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            ref.read(authViewModelProvider.notifier).signUpUser(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                          } else {
                            snackBarPopUp(context, "Missing Fields");
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.popAndPushNamed(context, "/login");
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: const [
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                  color: Pallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "A CrowdSource Intiative",
                        style: TextStyle(
                          fontSize: 10,
                          color: Pallete.subtitleText,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
