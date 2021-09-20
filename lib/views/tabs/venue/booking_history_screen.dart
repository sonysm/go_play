import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/booking.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/views/tabs/venue/widget/booking_cell.dart';
import 'package:kroma_sport/widgets/ks_screen_state.dart';
import 'package:line_icons/line_icons.dart';

class BookingHistoryScreen extends StatefulWidget {
  static const tag = '/bookingHistoryScreen';

  BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  KSHttpClient ksClient = KSHttpClient();
  List<Booking> myBookingList = [];

  bool isLoading = true;

  Widget buildBookingList() {
    return !isLoading
        ? SliverToBoxAdapter(
            child: myBookingList.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final booking = myBookingList[index];
                      return BookingCell(booking: booking);
                    },
                    separatorBuilder: (context, index) {
                      return 8.height;
                    },
                    itemCount: myBookingList.length,
                  )
                : KSScreenState(
                    icon: Icon(LineIcons.history, size: 150, color: Colors.blueGrey[700]),
                    title: 'No Booking yet',
                  ),
          )
        : SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 200),
              child: Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(mainColor),
              )),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('My Booking'),
      ),
      body: EasyRefresh.custom(
        header: MaterialHeader(
          valueColor: AlwaysStoppedAnimation<Color>(mainColor),
        ),
        slivers: [
          buildBookingList(),
        ],
        onRefresh: () async {},
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getMyBooking();
  }

  void getMyBooking() async {
    var res = await ksClient.getApi('/booking/my');
    if (res != null) {
      if (res is! HttpResult) {
        myBookingList = List.from((res as List).map((e) => Booking.fromJson(e)));

        Future.delayed(Duration(milliseconds: 500)).then((_) {
          isLoading = false;
          setState(() {});
        });
      }
    }
  }
}
