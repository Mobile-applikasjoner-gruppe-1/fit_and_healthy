import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/shared/models/WeightEntry.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';

class WeightRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;

  WeightRepository(this._authRepository);

  Future<void> addWeightEntry(WeightEntry entry) async {
    final AuthUser user = _authRepository.currentUser!;

    final weightHistoryCollection = _firestore
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('weightEntry');
    await weightHistoryCollection.add(entry.toMap());
  }

  Future<List<WeightEntry>> getWeightHistory() async {
    final AuthUser user = _authRepository.currentUser!;
    final weightHistoryCollection = _firestore
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('weightEntry');

    final querySnapshot = await weightHistoryCollection.get();

    return querySnapshot.docs
        .map((doc) => WeightEntry.fromMap(doc.data()))
        .toList();
  }
}
