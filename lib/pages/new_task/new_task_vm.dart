import '/base/base_view_model.dart';
import '/models/meta_user_model.dart';
import '/models/project_model.dart';
import '/models/task_model.dart';
import '/providers/auth_provider.dart';
import '/providers/fire_store_provider.dart';

class NewTaskViewModel extends BaseViewModel {
  dynamic auth, fireStore, user;

  BehaviorSubject<List<ProjectModel>>? bsListProject =
      BehaviorSubject<List<ProjectModel>>();

  BehaviorSubject<List<MetaUserModel>>? bsListUser =
      BehaviorSubject<List<MetaUserModel>>();

  NewTaskViewModel(AutoDisposeProviderReference ref) {
    init(ref);
  }

  void init(var ref) async {
    auth = ref.watch(authServicesProvider);
    user = auth.currentUser();
    fireStore = ref.watch(firestoreServicesProvider);
    initListProjectData();
    initListUserData();
  }

  void newTask(TaskModel task) async {
    // update new quick note to network
    await fireStore.addTask(user.uid, task);
  }

  void initListProjectData() {
    fireStore.projectStream(user.uid).listen((event) {
      bsListProject!.add(event);
    });
  }

  void initListUserData() {
    fireStore.userStream().listen((event) {
      bsListUser!.add(event);
    });
  }

  @override
  void dispose() {
    bsListUser!.close();
    bsListProject!.close();
    super.dispose();
  }
}
