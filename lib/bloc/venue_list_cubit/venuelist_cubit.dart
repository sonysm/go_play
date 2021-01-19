import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:sport_booking/models/venue.dart';

part 'venuelist_state.dart';

class VenueListCubit extends Cubit<VenueListState> {
  VenueListCubit() : super(VenueListInitial()) {
    loadData();
  }

  loadData() async {
    String json = await rootBundle.loadString('assets/dummy/venue_list.json');
    dynamic data = jsonDecode(json);
    var venues =
        List.from(data['near_by']).map((e) => Venue.fromJSON(e)).toList();
    emit(VenueListDidLoad(venues));
  }
}
