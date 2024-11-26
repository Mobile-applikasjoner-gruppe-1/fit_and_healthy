import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/src/features/auth/app_user_model.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;

  UserRepository(this._authRepository);

  Future<void> updateUser(Map<String, dynamic> data) async {
    print('Updating user');
    final AppUser user = _authRepository.currentUser!;
    if (user.firebaseUser == null)
      throw Exception('No authenticated user found!');
    print(user.firebaseUser!.uid);
    final userDoc = _firestore.collection('users').doc(user.firebaseUser!.uid);
    print('Found collection');
    await userDoc.set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final AppUser user = _authRepository.currentUser!;
    if (user.firebaseUser == null)
      throw Exception('No authenticated user found!');
    final userDoc =
        await _firestore.collection('users').doc(user.firebaseUser!.uid).get();
    return userDoc.exists ? userDoc.data() : null;
  }
}
