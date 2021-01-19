part of 'venuelist_cubit.dart';

@immutable
abstract class VenueListState {}

class VenueListInitial extends VenueListState {}

class VenueListDidLoad extends VenueListState {
  final List<Venue> venues;
  VenueListDidLoad(this.venues);
}
