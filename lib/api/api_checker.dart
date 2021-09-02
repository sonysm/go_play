import 'package:flutter/material.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/repositories/user_repository.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/views/auth/login_screen.dart';
import 'package:kroma_sport/widgets/ks_message_dialog.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class ApiChecker {
  static final _userRepository = UserRepository();

  static void checkApi(BuildContext context, DataState status) {
    if (status == DataState.UnAuthorized) {
      _userRepository.deleteToken();
      _userRepository.deleteHeaderToken();
      showKSMessageDialog(
        context,
        message: 'Sessions Expired',
        barrierDismissible: true,
        onYesPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginScreen.tag, (route) => false);
        },
      );
    } else {
      if (status == DataState.Error) {
        //ScaffoldMessenger.of(context).showSnackBar(
        //  SnackBar(
        //    content: Text(
        //      'Something went wrong!',
        //      style: TextStyle(color: Colors.white),
        //    ),
        //    backgroundColor: Colors.red,
        //  ),
        //);

        showKSSnackBar(
          context,
          title: 'Something went wrong',
          titleColor: whiteColor,
          backgroundColor: Colors.red,
        );
      } else if (status == DataState.ErrorSocket) {
        //ScaffoldMessenger.of(context).showSnackBar(
        //  SnackBar(
        //    content: Text(
        //      'No Internet connection.',
        //      style: TextStyle(color: Colors.white),
        //    ),
        //    backgroundColor: Colors.red,
        //  ),
        //);

        showKSSnackBar(
          context,
          title: 'No Internet connection.',
          titleColor: whiteColor,
          backgroundColor: Colors.red,
        );
      } else if (status == DataState.ErrorTimeOut) {
        //ScaffoldMessenger.of(context).showSnackBar(
        //  SnackBar(
        //    content: Text(
        //      'Request Timeout!',
        //      style: TextStyle(color: Colors.white),
        //    ),
        //    backgroundColor: Colors.red,
        //  ),
        //);

        showKSSnackBar(
          context,
          title: 'Request Timeout!',
          titleColor: whiteColor,
          backgroundColor: Colors.red,
        );
      }
    }
  }
}
