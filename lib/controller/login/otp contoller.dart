import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils.dart';
import '../../view/otpScreen.dart';






class LoginController extends GetxController {
  var loading = false.obs;
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;
  var countryPicker = '+91';




  void verifyPhoneNumber() {
    // loading.value = true;
    if (formKey.currentState!.validate()) {
      loading.value = true;
      auth.verifyPhoneNumber(
        phoneNumber: countryPicker + phoneController.text,
        verificationCompleted: (_) {
          loading.value = false;
        },
        verificationFailed: (FirebaseAuthException e) {
          String errorMessage = e.message ?? 'Verification failed!';
          Utils().toastMessage(errorMessage.toString());
          loading.value = false;
          // Handle verification failed
        },
        codeSent: (String verification, int? token) {
          loading.value = false;

          Get.offAll(() => VerifyOtp(
              verification: verification,
              phoneNumberfetch: countryPicker+phoneController.text
            //countryPicker + phoneController.text,
          ));
        },
        codeAutoRetrievalTimeout: (String verificatrionId) {
          // String errorMessage = 'Verification code retrieval timeout!';

          // utils().toastMessage(errorMessage.toString());
          loading.value = false;

        },
      );
    }
  }

  @override
  void dispose() {

    phoneController.clear();
    phoneController.dispose();
    super.dispose();
  }

}

//for verify controller screen

class VerifyController extends GetxController {

  var loading = false.obs;
  final verifyOtpController = TextEditingController();
  var resendTime = 30.obs;
  late Timer countDownTimer;
  addZero(n) => n.toString().padLeft(2, '0');




  void setLoading(bool value) {
    loading.value = value;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    verifyOtpController.clear();
    verifyOtpController.dispose();
  }

  startTimer() {
    resendTime.value = 30;
    countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {

      if (resendTime > 0) {
        resendTime--;
      } else {
        countDownTimer.cancel();
      }

    });
  }

  stopTimer() {
    if (countDownTimer.isActive) {
      countDownTimer.cancel();
    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    startTimer();
    super.onInit();
  }



}


