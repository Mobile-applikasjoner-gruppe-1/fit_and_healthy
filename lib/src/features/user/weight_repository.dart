import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/shared/models/weight_entry.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';
import 'package:fit_and_healthy/src/features/user/user_repository.dart';

final weightEntryConverter = (
  fromFirestore: (DocumentSnapshot<Map<String, dynamic>> doc, _) =>
      WeightEntry.fromFirestore(doc),
  toFirestore: (WeightEntry weightEntry, _) {
    throw Exception('Should not be used');
  }
);

final newWeightEntryConverter = (
  fromFirestore: (DocumentSnapshot<Map<String, dynamic>> doc, _) {
    throw Exception('Should not be used');
  },
  toFirestore: (NewWeightEntry weightEntry, _) => weightEntry.toFirestore(),
);

class WeightRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;

  static String collectionName = 'weightEntries';

  WeightRepository(this._authRepository);

  CollectionReference<WeightEntry> _getWeightEntryCollection() {
    final AuthUser user = _authRepository.currentUser!;
    return _firestore
        .collection(UserRepository.collectionName)
        .doc(user.firebaseUser.uid)
        .collection(collectionName)
        .withConverter<WeightEntry>(
          fromFirestore: weightEntryConverter.fromFirestore,
          toFirestore: weightEntryConverter.toFirestore,
        );
  }

  CollectionReference<NewWeightEntry> _getNewWeightEntryCollection() {
    final AuthUser user = _authRepository.currentUser!;
    return _firestore
        .collection(UserRepository.collectionName)
        .doc(user.firebaseUser.uid)
        .collection(collectionName)
        .withConverter<NewWeightEntry>(
          fromFirestore: newWeightEntryConverter.fromFirestore,
          toFirestore: newWeightEntryConverter.toFirestore,
        );
  }

  Future<WeightEntry> addWeightEntry(NewWeightEntry entry) async {
    if (!NewWeightEntry.isValidNewWeightEntry(entry)) {
      throw Exception('Invalid weigth entry provided!');
    }

    final weightEntryCollectionRef = _getNewWeightEntryCollection();

    final docRef = await weightEntryCollectionRef.add(entry);

    final newEntry = WeightEntry(
      id: docRef.id,
      weight: entry.weight,
      timestamp: entry.timestamp,
    );

    return newEntry;
  }

  Future<List<WeightEntry>> getWeightHistory() async {
    final querySnapshot = await _getWeightEntryCollection().get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<WeightEntry?> getLatestWeightEntry() async {
    final querySnapshot = await _getWeightEntryCollection()
        .orderBy(WeightEntryField.timestamp.toShortString(), descending: true)
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
        .where(WeightEntryField.timestamp.toShortString(),
            isGreaterThanOrEqualTo: Timestamp.fromDate(targetDate))
        .orderBy(WeightEntryField.timestamp.toShortString(), descending: true)
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<WeightEntry>> getWeightHistoryPastMonth() {
    return getWeightHistoryDaysBack(30);
  }

  Future<List<WeightEntry>> getWeightHistoryPastYear() {
    return getWeightHistoryDaysBack(365);
  }

  Future<void> deleteWeightEntry(String id) async {
    try {
      final weightEntryCollectionRef = _getWeightEntryCollection();
      await weightEntryCollectionRef.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete weight entry: $e');
    }
  }
}
