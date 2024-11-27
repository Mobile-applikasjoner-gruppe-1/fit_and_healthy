import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';
import 'package:fit_and_healthy/src/features/user/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;

  UserRepository(this._authRepository);

  Future<void> updateUser(UserModel user) async {
    print('Updating user');
    final AuthUser authUser = _authRepository.currentUser!;
    print(authUser.firebaseUser.uid);
    final userDoc =
        _firestore.collection('users').doc(authUser.firebaseUser.uid);
    print('Found collection');
    await userDoc.set(user.toFirestore(), SetOptions(merge: false));
  }

  Future<UserModel?> getUser() async {
    final user = _authRepository.currentUser!;
    final userDoc =
        await _firestore.collection('users').doc(user.firebaseUser.uid).get();
    if (userDoc.exists) {
      return UserModel.fromFirestore(userDoc.id, userDoc.data()!);
    }
    return null;
  }
}
