import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/shared/models/WeightEntry.dart';
import 'package:fit_and_healthy/src/features/auth/app_user_model.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';

class WeightRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;

  WeightRepository(this._authRepository);

  Future<void> addWeightEntry(WeightEntry entry) async {
    final AppUser user = _authRepository.currentUser!;
    if (user.firebaseUser == null)
      throw Exception('No authenticated user found!');
    final weightHistoryCollection = _firestore
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('weightHistory');
    await weightHistoryCollection.add(entry.toMap());
  }

  Future<List<WeightEntry>> getWeightHistory() async {
    final AppUser user = _authRepository.currentUser!;
    if (user.firebaseUser == null)
      throw Exception('No authenticated user found!');
    final weightHistoryCollection = _firestore
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('weightHistory');

    final querySnapshot = await weightHistoryCollection.get();

    return querySnapshot.docs
        .map((doc) => WeightEntry.fromMap(doc.data()))
        .toList();
  }
}
