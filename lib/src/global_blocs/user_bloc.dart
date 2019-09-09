import 'dart:async';


import 'package:rxdart/rxdart.dart';
import 'package:water_copy/models/user.dart';
import 'package:water_copy/services/firestore/firestore_user_service.dart';
import 'package:water_copy/src/global_blocs/bloc_base.dart';

class UserBloc implements BlocBase {
  UserBloc();

  User _user;
  StreamSubscription _userStreamSubscription;

  final _userController = BehaviorSubject<User>();
  Function(User) get _inUser => _userController.sink.add;
  Stream<User> get outUser => _userController.stream;

  Stream<int> get outMaxWater => outUser.map((user) => user.maxWaterPerDay);

  Future<void> init() async {
    await FirestoreUserService.checkAndCreateUser();
    await FirestoreUserService.updateLastLoggedIn();
    final userStream = await FirestoreUserService.getUserStream();
    _userStreamSubscription = userStream.listen((doc) {
      _user = User.fromDb(doc.data);
      _inUser(_user);
    });
  }

  @override
  void dispose() {
    _userController.close();
    _userStreamSubscription.cancel();
  }
}
