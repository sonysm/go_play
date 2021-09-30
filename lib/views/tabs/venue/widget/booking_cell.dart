import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/models/booking.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';

class BookingCell extends StatelessWidget {
  const BookingCell({Key? key, required this.booking, required this.onTap}) : super(key: key);

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    bool isMeetupAvailable() {
      var bookDate = DateFormat('yyyy-MM-dd hh:mm:ss').parse(booking.bookDate + ' ' + booking.fromTime);
      if (DateTime.now().isAfter(bookDate)) {
        return false;
      }

      return true;
    }

    String mapStatusTitle() {
      switch (booking.status) {
        case 'book':
          if (!isMeetupAvailable()) return 'Finished';
          return 'Booked';
        case 'pending':
          if (!isMeetupAvailable()) return 'Expired';
          return 'Pending';
        case 'vcancel':
          return 'Rejected';
        case 'ucancel':
          return 'Cancel';
        case 'done':
          return 'Finished';
        default:
          return '';
      }
    }

    Color mapStatusColor() {
      switch (booking.status) {
        case 'book':
          return mainColor;
        case 'pending':
          return Colors.amber[700]!;
        case 'vcancel':
          return Colors.red[400]!;
        case 'ucancel':
          return Colors.red[400]!;
        case 'done':
          return ColorResources.getPrimaryText(context);
        default:
          return ColorResources.getPrimaryText(context);
      }
    }

    Color mapDateBackgroundColor() {
      switch (booking.status) {
        case 'book':
          return isLight(context) ? Colors.green[200]! : Colors.green[600]!;
        case 'pending':
          return Colors.amber[200]!;
        case 'vcancel':
          return Colors.red[200]!;
        case 'ucancel':
          return Colors.red[200]!;
        case 'done':
          return isLight(context) ? Colors.green[200]! : Colors.green[600]!;
        default:
          return isLight(context) ? Colors.green[200]! : Colors.green[600]!;
      }
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100.0,
        padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 8.0, bottom: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          // borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Container(
              width: 80.0,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: mapDateBackgroundColor(),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMM').format(DateTime.parse(booking.bookDate)),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    DateFormat('dd').format(DateTime.parse(booking.bookDate)),
                    style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    DateFormat('EEE').format(DateTime.parse(booking.bookDate)),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.venue.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              booking.venue.address,
                              style: Theme.of(context).textTheme.bodyText2,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      8.width,
                      Text(
                        mapStatusTitle(),
                        style: TextStyle(color: mapStatusColor()),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Time: ',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            TextSpan(
                              text: DateFormat('hh:mm a').format(DateTime.parse(booking.bookDate + ' ' + booking.fromTime)),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'Booking ID: ', style: Theme.of(context).textTheme.caption),
                            TextSpan(text: 'KS${booking.id}', style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.amber[700])),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
