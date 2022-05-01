import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/base/base_view_model.dart';
import '/models/project_model.dart';
import '/providers/auth_provider.dart';
import '/providers/fire_store_provider.dart';
import '/services/fire_store_services.dart';

class MenuViewModel extends BaseViewModel {
  User? user;
  FirestoreService? fireStore;

  BehaviorSubject<List<ProjectModel>?> bsProject = BehaviorSubject();

  StreamSubscription<List<ProjectModel>>? projectStream;

  MenuViewModel(AutoDisposeProviderReference ref) {
    user = ref.watch(authServicesProvider).currentUser();
    fireStore = ref.watch(firestoreServicesProvider);
    if (user != null && fireStore != null) init();
  }

  void init() async {
    initProject();
  }

  void initProject() {
    projectStream = fireStore!.projectStream(user!.uid).listen((event) {
      bsProject.add(event);
    });
  }

  void addProject(String name, int indexColor) {
    var temp = new ProjectModel(
      name: name,
      idAuthor: user!.uid,
      indexColor: indexColor,
      timeCreate: DateTime.now(),
      listTask: [],
    );
    fireStore!.addProject(temp);
  }

  @override
  void dispose() {
    bsProject.close();
    if (projectStream != null) projectStream!.cancel();
    super.dispose();
  }
}
