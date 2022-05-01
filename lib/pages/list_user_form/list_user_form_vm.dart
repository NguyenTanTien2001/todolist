import 'package:firebase_auth/firebase_auth.dart';

import '/services/auth_services.dart';
import '/models/meta_user_model.dart';
import '/providers/auth_provider.dart';
import '/providers/fire_store_provider.dart';
import '/services/fire_store_services.dart';
import '/base/base_view_model.dart';

class ListUserFormViewModel extends BaseViewModel {
  final AutoDisposeProviderReference ref;
  late final FirestoreService firestoreService;
  User? user;
  late final AuthenticationService auth;

  // ignore: close_sinks
  BehaviorSubject<List<MetaUserModel>>? bsListUser =
      BehaviorSubject<List<MetaUserModel>>();
  BehaviorSubject<List<MetaUserModel>> bsSelectListUser =
      BehaviorSubject<List<MetaUserModel>>.seeded([]);

  ListUserFormViewModel(this.ref) {
    auth = ref.watch(authServicesProvider);
    user = auth.currentUser();
    firestoreService = ref.watch(firestoreServicesProvider);

    bsSelectListUser.add([]);
    if (user != null)
      firestoreService.userStream(user!.email!).listen((event) {
        bsListUser!.add(event);
      });
  }

  void checkClick(MetaUserModel value) {
    List<MetaUserModel> list = List.from(bsSelectListUser.value);

    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    bsSelectListUser.add(list);
  }

  void initSelect(List<MetaUserModel> list) {
    bsSelectListUser.add(list);
  }

  @override
  void dispose() {
    if (bsListUser != null) {
      bsListUser!.close();
    }
    bsSelectListUser.close();
    super.dispose();
  }
}
