import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/user.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/user.dart' as KSUser;
import 'package:kroma_sport/repositories/user_repository.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/views/auth/register_screen.dart';
import 'package:kroma_sport/views/main.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

enum OTPStatus {
  loading,
  error,
  completed,
  otp,
}

enum ValidateStatus {
  sendingSMS,
  phoneInvalid,
  couldNotSentCode,
  smsSentCompleted,
  codeVerifiedCompleted,
  verifying,
  invalidOTP,
  error,
}

class VerifyCodeScreen extends StatefulWidget {
  static const String tag = '/verifyCodeScreen';

  final String phoneNumber;

  VerifyCodeScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  String? _verificationId;

  OTPStatus _status = OTPStatus.loading;
  ValidateStatus _valideStatus = ValidateStatus.sendingSMS;

  TextEditingController _editController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  CountdownTimerController? controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 120;

  final userRepository = UserRepository();
  KSHttpClient ksClient = KSHttpClient();

  Stack _buildLoadingScreen() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16.0),
          child: Container(
              width: double.infinity,
              child: Builder(
                builder: (context) {
                  switch (_valideStatus) {
                    case ValidateStatus.sendingSMS:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Sending code to phone',
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(mainColor)),
                          ),
                        ],
                      );

                    case ValidateStatus.verifying:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('Verifying', style: TextStyle(fontSize: 17)),
                          SizedBox(height: 16),
                          Container(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(mainColor)),
                          ),
                        ],
                      );

                    case ValidateStatus.invalidOTP:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Verification code incorrect',
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(height: 24),
                          Container(
                            width: 100,
                            height: 100,
                            child: Icon(Icons.error_outline,
                                color: Colors.grey, size: 100),
                          ),
                          SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            color: mainColor,
                            child: TextButton(
                              child: Text(
                                'Try again',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  _status = OTPStatus.otp;
                                });
                              },
                            ),
                          ),
                        ],
                      );

                    case ValidateStatus.smsSentCompleted:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Verify code sent',
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: 100,
                            height: 100,
                            child: Icon(Icons.check_circle_outline,
                                size: 100, color: mainColor),
                          ),
                        ],
                      );

                    case ValidateStatus.codeVerifiedCompleted:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Phone verified',
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: 100,
                            height: 100,
                            child: Icon(Icons.check_circle_outline,
                                size: 100, color: mainColor),
                          ),
                        ],
                      );

                    case ValidateStatus.phoneInvalid:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Phone number is incorrect!",
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(height: 24),
                          Container(
                            width: 100,
                            height: 100,
                            child: Icon(Icons.error_outline, size: 100),
                          ),
                          SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            color: mainColor,
                            child: TextButton(
                              child: Text(
                                'Try again',
                                style: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      );

                    case ValidateStatus.error:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Something went wrong',
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(height: 24),
                          Container(
                            width: 100,
                            height: 100,
                            child: Icon(Icons.error_outline, size: 100),
                          ),
                          SizedBox(height: 24),
                          TextButton(
                            child: Text('Try again'),
                            onPressed: () {
                              // Navigator.of(context).pushNamedAndRemoveUntil(
                              //     '/verification',
                              //     (Route<dynamic> route) => false,
                              //     arguments: widget.data);
                            },
                          ),
                        ],
                      );

                    default:
                      return Container();
                  }
                },
              )),
        ),
      ],
    );
  }

  Stack _buildOTPScreen() {
    return Stack(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 32, right: 32, bottom: 16.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Verify code', style: TextStyle(fontSize: 28)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Please type the verification code sent to ${widget.phoneNumber}",
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 36),
                  PinInputTextField(
                    controller: _editController,
                    pinLength: 6,
                    decoration: BoxLooseDecoration(
                      strokeColorBuilder: FixedColorBuilder(Colors.grey),
                      hintText: "------",
                      // enteredColor: mainColor,
                      // strokeColor: Colors.grey
                    ),
                    // focusNode: FocusNode(),
                    onChanged: (t) {
                      print(t);
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CountdownTimer(
                        controller: controller,
                        onEnd: onEnd,
                        endTime: endTime,
                        widgetBuilder: (_, CurrentRemainingTime? time) {
                          if (time != null) {
                            var min = time.min ?? 0;
                            return Text(
                                '${_getNumberAddZero(min)} : ${_getNumberAddZero(time.sec!)}');
                          }
                          return TextButton(
                            child: Text(
                              'Resend code',
                              style: TextStyle(
                                fontSize: 16,
                                color: mainColor,
                              ),
                            ),
                            onPressed: () {
                              _sendSMSCode();
                              setState(() {
                                _status = OTPStatus.loading;
                                _valideStatus = ValidateStatus.sendingSMS;
                              });
                            },
                          );
                        },
                        //endWidget: TextButton(
                        //  child: Text(
                        //    'Resend code',
                        //    style: TextStyle(
                        //      fontSize: 16,
                        //      color: mainColor,
                        //    ),
                        //  ),
                        //  onPressed: () {
                        //    _sendSMSCode();
                        //    setState(() {
                        //      _status = OTPStatus.loading;
                        //      _valideStatus = ValidateStatus.sendingSMS;
                        //    });
                        //  },
                        //),
                      )
                    ],
                  ),
                  16.height,
                  Container(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed:
                          _editController.text.length == 6 ? _verifyCode : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            _editController.text.length == 6
                                ? mainColor
                                : Colors.green[200]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void onEnd() {
    print('_________onEnd_________');
  }

  @override
  void initState() {
    super.initState();
    print('phonenummmm ===== ${widget.phoneNumber}');
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      // _toEditUserScreen();

      _sendSMSCode();
      _status = OTPStatus.completed;
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (controller != null) {
      controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Verification',
          ),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Builder(
          builder: (context) {
            switch (_status) {
              case OTPStatus.loading:
                return _buildLoadingScreen();
              case OTPStatus.completed:
                return _buildOTPScreen();
              case OTPStatus.otp:
                return _buildOTPScreen();
              case OTPStatus.error:
                return _buildOTPScreen();
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  _sendSMSCode() async {
    String phone = widget.phoneNumber;
    print('phonenummmm ===== $phone');
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(minutes: 2),
      codeSent: _codeSent,
      verificationCompleted: _verificationCompleted,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      verificationFailed: _verificationFailed,
    );
  }

  _codeSent(String verificationId, [int? n]) {
    setState(() {
      _verificationId = verificationId;
      _valideStatus = ValidateStatus.smsSentCompleted;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _status = OTPStatus.otp;
      });
    });

    print("================ code_sent_completed");
  }

  _verificationCompleted(AuthCredential authCredential) {
    print("================ veryfyCodeCompleted__$authCredential");
    setState(() {
      _valideStatus = ValidateStatus.smsSentCompleted;
    });
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _status = OTPStatus.otp;
      });
    });

    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _valideStatus = ValidateStatus.smsSentCompleted;
      });
    });

    redirectToScreen();
  }

  _codeAutoRetrievalTimeout(String s) {
    //showMessageInfo(context, 'Retrieval Timeout $s');
    // print("================ codeAutoRetrievalTimeout____$s");
  }

  _verificationFailed(FirebaseAuthException f) {
    setState(() {
      _status = OTPStatus.loading;
      _valideStatus = ValidateStatus.error;
    });

    //showMessageInfo(context, 'Verification Failed ${f.message}');

    // print(
    //     "================ verificationFailed_______${f.code}________${f.message}");
  }

  _verifyCode() {
    if (controller != null) {
      controller!.dispose();
      controller = null;
    }
    //Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.tag, (route) => false);
    //return;

    setState(() {
      _status = OTPStatus.loading;
      _valideStatus = ValidateStatus.verifying;
    });

    var credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _editController.text,
    );

    _auth.signInWithCredential(credential).then((result) {
      setState(() {
        _valideStatus = ValidateStatus.codeVerifiedCompleted;
      });

      redirectToScreen();
      // print(
      //     "================ signInWithCredential___________success_________$result");
    }).catchError((onError) {
      setState(() {
        _valideStatus = ValidateStatus.invalidOTP;
      });
      // print(
      //     "================ signInWithCredential___________error_________$onError");
    });
  }

  /// 1 -> 01
  String _getNumberAddZero(int number) {
    if (number < 10) {
      return "0" + number.toString();
    }
    return number.toString();
  }

  void redirectToScreen() async {
    var data =
        await ksClient.postLogin('/user/login', {'phone': widget.phoneNumber});

    if (data != null) {
      if (data is! HttpResult) {
        ksClient.setToken(data['token']);
        userRepository.persistToken(data['refresh_token']);
        userRepository.persistHeaderToken(data['token']);
        KS.shared.user = KSUser.User.fromJson(data['user']);
        BlocProvider.of<UserCubit>(context).emitUser(KS.shared.user);
        Navigator.pushNamedAndRemoveUntil(
            context, MainView.tag, (route) => false);
      } else {
        if (data.code == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, RegisterScreen.tag, (route) => false,
              arguments: widget.phoneNumber);
        }
      }
    }
  }
}
