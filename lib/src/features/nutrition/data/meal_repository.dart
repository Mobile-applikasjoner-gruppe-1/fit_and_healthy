import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/data/meal_item_repository.dart';
import 'package:fit_and_healthy/src/openfoodfacts/foodrelatedclasses/mealClass.dart';

final mealConverter = (
  fromFirestore: (snapshot, _) => Meal.fromFirebase(snapshot),
  toFirestore: (Meal meal, _) => meal.toFirebase(),
);

class MealRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;

  MealRepository(this._authRepository);

  Future<String> addMeal(Meal meal) async {
    final user = _authRepository.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final firebaseUser = user.firebaseUser;

    final mealsCollection = _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('meals');
    final docRef = await mealsCollection
        .withConverter<Meal>(
          fromFirestore: (snapshot, _) => Meal.fromFirebase(snapshot),
          toFirestore: mealConverter.toFirestore,
        )
        .add(meal);

    return docRef.id;
  }

  Future<Meal> getMealById(String mealId) async {
    final user = _authRepository.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final firebaseUser = user.firebaseUser;

    final mealDoc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('meals')
        .doc(mealId)
        .withConverter<Meal>(
          fromFirestore: (snapshot, _) => Meal.fromFirebase(snapshot),
          toFirestore: mealConverter.toFirestore,
        )
        .get();

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
    final user = _authRepository.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final firebaseUser = user.firebaseUser;

    final mealsCollection = _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('meals');

    final meals = await mealsCollection
        .withConverter<Meal>(
          fromFirestore: (snapshot, _) => Meal.fromFirebase(snapshot),
          toFirestore: mealConverter.toFirestore,
        )
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThanOrEqualTo: endOfDay)
        .get();

    return meals.docs.map((doc) => doc.data()).toList();
  }

  Future<void> deleteMealById(String mealId) async {
    final user = _authRepository.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final firebaseUser = user.firebaseUser;

    final mealItemRepository = MealItemRepository(_authRepository);

    await mealItemRepository.deleteAllItemsForMeal(mealId);

    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('meals')
        .doc(mealId)
        .delete();
  }
}
