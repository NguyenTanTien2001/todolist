import 'package:firebase_auth/firebase_auth.dart';

import '/services/auth_services.dart';
import '/services/fire_store_services.dart';
import '/models/quick_note_model.dart';

import '/base/base_view_model.dart';
import '/providers/auth_provider.dart';
import '/providers/fire_store_provider.dart';

class NewNoteViewModel extends BaseViewModel {
  final AutoDisposeProviderReference ref;
  late final FirestoreService firestoreService;
  late final AuthenticationService auth;
  User? user;

  NewNoteViewModel(this.ref) {
    auth = ref.watch(authServicesProvider);
    user = auth.currentUser();
    firestoreService = ref.watch(firestoreServicesProvider);
  }

  Future<void> newNote(QuickNoteModel quickNote) async {
    startRunning();
    // update new quick note to network
    await firestoreService.addQuickNote(user!.uid, quickNote);
    endRunning();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
