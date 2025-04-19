import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/controller/login_controller.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/buttons/primary_button.dart';
import 'package:payrailpos/widgets/inputs/password_input.dart';
import 'package:payrailpos/widgets/inputs/phone_input.dart';

class Signin extends StatelessWidget {
  Signin({Key? key}) : super(key: key);

  final loginCtrl = Get.put(LoginController());
  //final payment = Get.put(PaymentService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: FocusNode(),
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      'Sign In',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 10),
                    PhoneInput(
                      placeholder: 'Phone number',
                      controller: loginCtrl.phoneCtx,
                      onChanged: (val) {
                        loginCtrl.phone.value = val;
                      },
                    ),
                    PasswordInput(
                      controller: loginCtrl.pinCtx,
                      onChanged: (val) {
                        loginCtrl.password.value = val;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'remember me'.tr,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Obx(
                          () => CupertinoSwitch(
                            activeColor: AppColors.PRIMARY_COLOR,
                            value: loginCtrl.rememberMe.value,
                            onChanged: (val) {
                              loginCtrl.rememberMe.value = val;
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => PrimaryButton(
                        isLoading: loginCtrl.isLoading.value,
                        label: 'Continue'.tr,
                        onPressed: loginCtrl.phone.value.length < 10 ||
                                loginCtrl.password.value.isEmpty
                            ? null
                            : () => loginCtrl.userLogin(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
