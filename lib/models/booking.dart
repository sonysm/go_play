import 'dart:convert';

import 'package:kroma_sport/models/venue.dart';
import 'package:kroma_sport/models/venue_detail.dart';

Booking bookingFromJson(String str) => Booking.fromJson(json.decode(str));

String bookingToJson(Booking data) => json.encode(data.toJson());

class Booking {
    Booking({
        required this.id,
        required this.venue,
        required this.service,
        required this.status,
        required this.bookDate,
        required this.fromTime,
        required this.toTime,
        this.people,
        required this.price,
        required this.createdAt,
        required this.updatedAt,
        required this.customer,
    });

    int id;
    Venue venue;
    VenueService service;
    String status;
    String bookDate;
    String fromTime;
    String toTime;
    int? people;
    double price;
    DateTime createdAt;
    DateTime updatedAt;
    int customer;

    factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        venue: Venue.fromJson(json["venue"]),
        service: VenueService.fromJson(json["service"]),
        status: json["status"],
        bookDate: json["book_date"],
        fromTime: json["from_time"],
        toTime: json["to_time"],
        people: json["people"],
        price: json["price"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        customer: json["customer"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "venue": venue.toJson(),
        "service": service.toJson(),
        "status": status,
        "book_date": bookDate,
        "from_time": fromTime,
        "to_time": toTime,
        "people": people,
        "price": price,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "customer": customer,
    };
}