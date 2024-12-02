import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/data/meal_item_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/meal.dart';
import 'package:fit_and_healthy/src/features/user/user_repository.dart';

final mealConverter = (
  fromFirestore: (snapshot, _) => Meal.fromFirebase(snapshot),
  toFirestore: (Meal meal, _) => meal.toFirebase(),
);

class MealRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;

  static const collectionName = 'meals';

  MealRepository(this._authRepository);

  CollectionReference<Meal> _getMealsCollection() {
    final user = _authRepository.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final firebaseUser = user.firebaseUser;

    return _firestore
        .collection(UserRepository.collectionName)
        .doc(firebaseUser.uid)
        .collection(collectionName)
        .withConverter<Meal>(
          fromFirestore: (snapshot, _) => Meal.fromFirebase(snapshot),
          toFirestore: mealConverter.toFirestore,
        );
  }

  Future<String> addMeal(Meal meal) async {
    final docRef = await _getMealsCollection().add(meal);

    return docRef.id;
  }

  Future<Meal> getMealById(String mealId) async {
    final mealDoc = await _getMealsCollection().doc(mealId).get();

    if (!mealDoc.exists) {
      throw Exception('Meal not found');
    }

    final meal = mealDoc.data();

    if (meal == null) {
      throw Exception('Meal data is null');
    }

    return meal;
  }

  Future<List<Meal>> getAllMealsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final meals = await _getMealsCollection()
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThanOrEqualTo: endOfDay)
        .get();

    return meals.docs.map((doc) => doc.data()).toList();
  }

  Future<void> deleteMealById(String mealId) async {
    final mealItemRepository = MealItemRepository(_authRepository, mealId);

    await mealItemRepository.deleteAllItemsForMeal();

    await _getMealsCollection().doc(mealId).delete();
  }

  Stream<List<Meal>> getMealsStreamForDate(DateTime date) {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final userId = _authRepository.currentUser!.firebaseUser.uid;

    print('Getting workouts from database for date: $startOfDay');

    return _firestore
        .collection(UserRepository.collectionName)
        .doc(userId)
        .collection(collectionName)
        .withConverter<Meal>(
          fromFirestore: mealConverter.fromFirestore,
          toFirestore: mealConverter.toFirestore,
        )
        .where('dateTime', isGreaterThanOrEqualTo: startOfDay)
        .where('dateTime', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
