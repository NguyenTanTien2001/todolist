import 'package:firebase_auth/firebase_auth.dart';
import '/services/auth_services.dart';
import '/services/fire_store_services.dart';
import '/base/base_view_model.dart';
import '/models/task_model.dart';
import '/providers/auth_provider.dart';
import '/providers/fire_store_provider.dart';

class MyTaskViewModel extends BaseViewModel {
  final AutoDisposeProviderReference ref;
  late final FirestoreService firestoreService;
  late final AuthenticationService auth;
  User? user;

  BehaviorSubject<bool> bsIsToDay = BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<List<TaskModel>>? bsListTask =
      BehaviorSubject<List<TaskModel>>();

  MyTaskViewModel(this.ref) {
    auth = ref.watch(authServicesProvider);
    user = auth.currentUser();
    firestoreService = ref.watch(firestoreServicesProvider);

    if (user != null) {
      firestoreService.taskStream(user!.uid).listen((event) {
        List<TaskModel> listAllData = event;
        List<TaskModel> listData = [];
        for (var task in listAllData) {
          if (task.idAuthor == user!.uid ||
              task.listMember.contains(user!.uid)) {
            listData.add(task);
          }
        }
        listData.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
        bsListTask!.add(listData);
      });
    }
  }

  setToDay(bool value) {
    bsIsToDay.add(value);
  }

  void signOut() {
    auth.signOut();
  }

  @override
  void dispose() {
    bsIsToDay.close();
    if (bsListTask != null) {
      bsListTask!.close();
    }
    super.dispose();
  }
}
