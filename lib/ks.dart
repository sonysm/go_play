import 'models/user.dart';

class KS {
  KS._internal();

  static KS _singleton = KS._internal();
  static KS get shared {
    //if (_singleton == null) {
    //  _singleton = KS._internal();
    //}

    return _singleton;
  }

  late User user;
}
