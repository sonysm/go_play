import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sport_booking/models/venue.dart';
import 'package:sport_booking/respositories/user_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final _repository = UserRepository();
  HomeCubit() : super(Loading()) {
    loadData();
  }

  loadData() async {
    emit(Loading());
    var data = await _repository.getDashboard();
    List<Venue> news =
        List.from(data['new']).map((e) => Venue.fromJSON(e)).toList();
    List<Venue> nearBy =
        List.from(data['near_by']).map((e) => Venue.fromJSON(e)).toList();
    emit(DidLoadDashboard(newList: news, nearByList: nearBy));
  }
}
