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

  CollectionReference<WeightEntry> _getWeightEntryCollection() {
    final AuthUser user = _authRepository.currentUser!;
    return _firestore
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('weightEntry')
        .withConverter<WeightEntry>(
          fromFirestore: weightEntryConverter.fromFirestore,
          toFirestore: weightEntryConverter.toFirestore,
        );
  }

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
    final querySnapshot = await _getWeightEntryCollection().get();

    // QuerySnapshot<WeightEntry> querySnapshot = await _firestore
    //     .collection('users')
    //     .doc(user.firebaseUser.uid)
    //     .collection('weightEntry')
    //     .withConverter<WeightEntry>(
    //         fromFirestore: weightEntryConverter.fromFirestore,
    //         toFirestore: weightEntryConverter.toFirestore)
    //     .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<WeightEntry?> getLatestWeightEntry() async {
    final querySnapshot = await _getWeightEntryCollection()
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    if (querySnapshot.docChanges.isNotEmpty) {
      return querySnapshot.docs.first.data();
    }
    return null;
  }

  Future<List<WeightEntry>> getWeightHistoryDaysBack(int daysBack) async {
    final DateTime targetDate =
        DateTime.now().subtract(Duration(days: daysBack));
    final querySnapshot = await _getWeightEntryCollection()
        .where('timestamp',
            isGreaterThanOrEqualTo: targetDate.toIso8601String())
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<WeightEntry>> getWeightHistoryPastMonth() {
    return getWeightHistoryDaysBack(30);
  }

  Future<List<WeightEntry>> getWeightHistoryPastYear() {
    return getWeightHistoryDaysBack(365);
  }
}
