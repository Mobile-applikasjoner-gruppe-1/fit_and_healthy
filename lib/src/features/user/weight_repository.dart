import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/shared/models/WeightEntry.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';

final weightEntryConverter = (
  fromFirestore: (snapshot, _) => WeightEntry.fromFirestore(snapshot.data()!),
  toFirestore: (WeightEntry weightEntry, _) => weightEntry.toFirestore(),
);

class WeightRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;

  WeightRepository(this._authRepository);

  Future<String> addWeightEntry(WeightEntry entry) async {
    final AuthUser user = _authRepository.currentUser!;

    CollectionReference weightEntrysRef = _firestore
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('weightEntry')
        .withConverter<WeightEntry>(
          fromFirestore: weightEntryConverter.fromFirestore,
          toFirestore: weightEntryConverter.toFirestore,
        );

    DocumentReference weightEntryRef = await weightEntrysRef.add(entry);

    return weightEntryRef.id;
  }

  Future<List<WeightEntry>> getWeightHistory() async {
    final AuthUser user = _authRepository.currentUser!;

    QuerySnapshot<WeightEntry> querySnapshot = await _firestore
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('weightEntry')
        .withConverter<WeightEntry>(
            fromFirestore: weightEntryConverter.fromFirestore,
            toFirestore: weightEntryConverter.toFirestore)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
