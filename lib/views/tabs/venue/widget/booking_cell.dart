import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/models/booking.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/venue/booking_history_detail.dart';

class BookingCell extends StatelessWidget {
  const BookingCell({Key? key, required this.booking}) : super(key: key);

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchScreen(
          context,
          BookingHistoryDetailScreen.tag,
          arguments: booking,
        );
      },
      child: Container(
        height: 100.0,
        padding: const EdgeInsets.only(
            left: 16.0, top: 8.0, right: 8.0, bottom: 8.0),
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
                color: isLight(context) ? Colors.amber[200] : Colors.amber[600],
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
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.w600),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              booking.venue.address,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                      8.width,
                      Text(
                        booking.status.capitalize,
                        style: TextStyle(color: Colors.green),
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
                              text: DateFormat('hh:mm a').format(DateTime.parse(
                                  booking.bookDate + ' ' + booking.fromTime)),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(color: Colors.amber[700]),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Booking ID: ',
                                style: Theme.of(context).textTheme.caption),
                            TextSpan(
                                text: 'KS${booking.id}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(color: Colors.amber[700])),
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
