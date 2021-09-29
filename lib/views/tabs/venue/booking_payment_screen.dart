import 'package:dotted_border/dotted_border.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/payment.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/image_helper.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/main.dart';
import 'package:kroma_sport/views/tabs/venue/booking_history_screen.dart';
import 'package:kroma_sport/widgets/ks_complete_dialog.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_message_dialog.dart';
import 'package:line_icons/line_icons.dart';

class BookingPaymentScreen extends StatefulWidget {
  static const tag = '/bookingPayment';
  BookingPaymentScreen({Key? key, required this.bookingData}) : super(key: key);

  final Map<String, String> bookingData;

  @override
  _BookingPaymentScreenState createState() => _BookingPaymentScreenState();
}

class _BookingPaymentScreenState extends State<BookingPaymentScreen> {
  KSHttpClient _ksHttpClient = KSHttpClient();
  List<Payment> paymentList = [];

  Payment? selectedPayment;

  late Map<String, String> _bookingData;

  TextEditingController _trxTextController = TextEditingController();
  FocusNode _trxFocusNode = FocusNode();

  Widget paymentsWidget() {
    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final paymt = paymentList.elementAt(index);
            return Card(
              elevation: 0.3,
              clipBehavior: Clip.antiAlias,
              color: ColorResources.getPrimary(context),
              child: RadioListTile<Payment>(
                value: paymt,
                title: Text(
                  paymt.name,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onChanged: (Payment? value) {
                  if (value!.slug == 'cash') {
                    _trxFocusNode.unfocus();
                  }
                   _trxFocusNode.requestFocus();
                  setState(() => selectedPayment = value);
                },
                groupValue: selectedPayment,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
              ),
            );
          },
          childCount: paymentList.length,
        ),
      ),
    );
  }

  Widget transactionNumberWidget() {
    return SliverToBoxAdapter(
      child: (selectedPayment != null && selectedPayment!.slug != 'cash')
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Please confirm your transaction ID'),
                  Card(
                    elevation: 0.3,
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.only(top: 8.0),
                    color: ColorResources.getPrimary(context),
                    child: TextField(
                      focusNode: _trxFocusNode,
                      controller: _trxTextController,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        border: InputBorder.none,
                        hintText: 'Transaction ID',
                        prefixIcon: Icon(LineIcons.receipt, color: ColorResources.getSecondaryIconColor(context)),
                      ),
                    ),
                  )
                ],
              ),
            )
          : SizedBox(),
    );
  }

  Widget confirmButton() {
    return SliverToBoxAdapter(
      child: Container(
        height: 48.0,
        margin: const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
        child: ElevatedButton(
          onPressed: confirmBooking,
          child: Text('Confirm Booking'),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: MaterialStateProperty.all(mainColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text('Payment methods'),
      ),
      body: CustomScrollView(
        slivers: [
          paymentsWidget(),
          // transactionImageWidget(),
          transactionNumberWidget(),
          confirmButton(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _bookingData = widget.bookingData;
    getPaymentMethodList();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void dispose() {
    _trxFocusNode.unfocus();
    super.dispose();
  }

  void getPaymentMethodList() async {
    await _ksHttpClient.getApi('/booking/payment/method').then((res) {
      if (res != null && res is! HttpResult) {
        paymentList = List.from((res as List).map((e) => Payment.fromJson(e)));
        setState(() {});
      }
    });
  }

  void confirmBooking() {
    if (selectedPayment == null) {
      showKSMessageDialog(
        context,
        message: 'Please choose payment method first before confirm booking',
        buttonTitle: 'OK',
      );
    } else {
      if (selectedPayment!.slug == 'cash') {
        showKSConfirmDialog(
          context,
          message: 'You are about to book a pitch.\n\nPlease confirm!',
          onYesPressed: placeBooking,
        );
      } else {
        if (_trxTextController.text.trim().length < 4) {
          showKSMessageDialog(
            context,
            message: 'Please input transaction number properly!',
            buttonTitle: 'OK',
          );
        } else {
          _trxFocusNode.unfocus();
          showKSConfirmDialog(
            context,
            message: 'You are about to book a pitch.\n\nPlease confirm!',
            onYesPressed: placeBooking,
          );
        }
      }
    }
  }

  void placeBooking() async {
    _bookingData['payment_method'] = selectedPayment!.id.toString();

    if (_trxTextController.text.isNotEmpty) {
      _bookingData['tranx'] = _trxTextController.text;
    }

    showKSLoading(context);

    var res = await _ksHttpClient.postApi('/booking/service/${_bookingData['venue_id']}', body: _bookingData);
    if (res != null) {
      if (res is! HttpResult) {
        dismissScreen(context);
        showKSComplete(context, message: 'Book successfully!');
        await Future.delayed(Duration(milliseconds: 700));
        dismissScreen(context);
        Navigator.pushNamedAndRemoveUntil(context, BookingHistoryScreen.tag, ModalRoute.withName(MainView.tag));
      } else {
        dismissScreen(context);
        showKSMessageDialog(
          context,
          message: 'Booking failed. Please try again!',
        );
      }
    }
  }
}
