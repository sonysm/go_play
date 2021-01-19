part of 'home_cubit.dart';

@immutable
abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {}

class Loading extends HomeState {}

class DidLoadDashboard extends HomeState {
  final List<Venue> newList;
  final List<Venue> nearByList;

  const DidLoadDashboard({this.newList, this.nearByList});
}
