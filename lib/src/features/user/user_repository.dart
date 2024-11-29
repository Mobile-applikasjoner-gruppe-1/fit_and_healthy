import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';
import 'package:fit_and_healthy/src/features/user/user_model.dart';

final userConverter = (
  fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) {
    if (!snapshot.exists) {
      throw Exception(
          'Firestore document does not exist for user ID: ${snapshot.id}');
    }
    return UserModel.fromFirestore(snapshot.data()!, snapshot.id);
  },
  toFirestore: (UserModel userModel, _) => userModel.toFirestore(),
);

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;

  UserRepository(this._authRepository);

  DocumentReference<UserModel> _getUserModelDocument() {
    final AuthUser user = _authRepository.currentUser!;

    return _firestore
        .collection('users')
        .doc(user.firebaseUser.uid)
        .withConverter<UserModel>(
            fromFirestore: userConverter.fromFirestore,
            toFirestore: userConverter.toFirestore);
  }

  Future<void> updateUser(UserModel user) async {
    await _getUserModelDocument().set(user, SetOptions(merge: false));
  }

  Future<UserModel?> getUser() async {
    final userDoc = await _getUserModelDocument().get();

    if (userDoc.exists) {
      return userDoc.data();
    }
    return null;
  }
}
