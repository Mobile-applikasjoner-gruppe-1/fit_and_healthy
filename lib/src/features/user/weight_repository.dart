import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/shared/models/WeightEntry.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';

final weightEntryConverter = (
  fromFirestore: (DocumentSnapshot<Map<String, dynamic>> doc, _) =>
      WeightEntry.fromFirestore(doc),
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

  Future<WeightEntry> addWeightEntry(NewWeightEntry entry) async {
    if (!NewWeightEntry.isValidNewWeightEntry(entry)) {
      throw Exception('Invalid weigth entry provided!');
    }
    final weightEntrysRef = _getWeightEntryCollection();

    final docRef = await weightEntrysRef.add(
      WeightEntry(
        id: '',
        timestamp: entry.timestamp,
        weight: entry.weight,
      ),
    );

    return WeightEntry(
      id: docRef.id,
      timestamp: entry.timestamp,
      weight: entry.weight,
    );
  }

  Future<List<WeightEntry>> getWeightHistory() async {
    final querySnapshot = await _getWeightEntryCollection().get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<WeightEntry?> getLatestWeightEntry() async {
    final querySnapshot = await _getWeightEntryCollection()
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    }
    return null;
  }

  Future<List<WeightEntry>> getWeightHistoryDaysBack(int daysBack) async {
    final DateTime targetDate =
        DateTime.now().subtract(Duration(days: daysBack));
    final querySnapshot = await _getWeightEntryCollection()
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(targetDate))
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
