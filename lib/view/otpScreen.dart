
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:todo_list/view/welcome_screen.dart';

import '../controller/login/otp contoller.dart';
import '../firebase/saveMobileNo.dart';
import '../utils.dart';
import 'loginScreem.dart';


class VerifyOtp extends StatelessWidget {
  final String verification;
  final String phoneNumberfetch;

  VerifyOtp(
      {super.key, required this.verification, required this.phoneNumberfetch});

  final VerifyController verifyController = Get.put(VerifyController());

  final _formKey2 = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Gernal_mobile_no = phoneNumberfetch;//this string i have created in language to take data to firestore

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                Form(
                    key: _formKey2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .25,
                        ),
                        const Text(
                          'Verify Your Mobile Number',
                          style: TextStyle(fontSize: 25,color: Colors.white),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        const Text(
                          'Otp send to Mobile No',
                          style: TextStyle(fontSize: 16,color: Colors.white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              phoneNumberfetch.toString(),
                              style: const TextStyle(fontSize: 16,color: Colors.white),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: const Text(
                                  '   Edit',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.greenAccent),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PinCodeTextField(
                            textStyle: TextStyle(color: Colors.white),
                            controller: verifyController.verifyOtpController,
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                inactiveColor: Colors.white,
                                inactiveBorderWidth: 1,
                                selectedBorderWidth: 1,
                                activeBorderWidth: 1,
                                borderRadius: BorderRadius.circular(10)),
                            appContext: context,
                            length: 6,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ' Enter Six Digit Code.';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .03,
                ),
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .06,
                      width: MediaQuery.of(context).size.width * .90,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent),
                        onPressed: () async {
                          if (_formKey2.currentState!.validate()) {
                            verifyController.setLoading(true);

                            final credential = PhoneAuthProvider.credential(
                                verificationId: verification,
                                smsCode: verifyController
                                    .verifyOtpController.text
                                    .toString());
                            try {
                              await auth.signInWithCredential(credential);




                              Store_MobileNo_database();
                              Get.offAll(()=> WelcomeScreen());



                            } on FirebaseAuthException catch (e) {
                              String errorMessage =
                                  e.message ?? 'Verification failed!';

                              verifyController.setLoading(false);

                              Utils().toastMessage(errorMessage.toString());
                            }
                          }
                        },
                        child: Center(
                            child: Obx(() => verifyController.loading.value
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text(
                              'Verify',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ))),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .009,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Resend Otp in ',
                          style: TextStyle(fontSize: 17,color: Colors.white),
                        ),
                        Obx(
                              () => verifyController.resendTime.value == 0
                              ? InkWell(
                              onTap: () {
                                verifyController.startTimer();
                                auth.verifyPhoneNumber(
                                    phoneNumber: phoneNumberfetch,
                                    verificationCompleted: (_) {},
                                    verificationFailed:
                                        (FirebaseAuthException e) {
                                      String errorMessage = e.message ??
                                          'Verification failed!';
                                      Utils().toastMessage(
                                          errorMessage.toString());
                                    },
                                    codeSent: (String verification,
                                        int? token) {},
                                    codeAutoRetrievalTimeout:
                                        (String verificatrionId) {
                                      // String errorMessage = 'Verification code retrieval timeout!';
                                      //
                                      // utils().toastMessage(errorMessage.toString());
                                    });
                              },
                              child: const Text(
                                ' Resend',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.greenAccent),
                              ))
                              : Text(
                            '${verifyController.addZero(verifyController.resendTime)} ',
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Colors.greenAccent),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            )));
  }
}
