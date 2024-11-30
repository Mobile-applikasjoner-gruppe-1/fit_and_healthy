import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal_item/food_item.dart';

final mealItemConverter = (
  fromFirestore: (snapshot, _) => FoodItem.fromFirebase(snapshot),
  toFirestore: (FoodItem foodItem, _) => foodItem.toFirebase(),
);

class MealItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;

  MealItemRepository(this._authRepository);

  Future<String> addMealItem(String mealId, FoodItem mealItem) async {
    final user = _authRepository.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final firebaseUser = user.firebaseUser;

    final mealItemsCollection = _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('meals')
        .doc(mealId)
        .collection('items');

    final docRef = await mealItemsCollection
        .withConverter<FoodItem>(
          fromFirestore: (snapshot, _) => FoodItem.fromFirebase(snapshot),
          toFirestore: mealItemConverter.toFirestore,
        )
        .add(mealItem);

    return docRef.id;
  }

  Future<FoodItem> getMealItemById(String mealId, String itemId) async {
    final user = _authRepository.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final firebaseUser = user.firebaseUser;

    final mealItemDoc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('meals')
        .doc(mealId)
        .collection('items')
        .doc(itemId)
        .withConverter<FoodItem>(
          fromFirestore: (snapshot, _) => FoodItem.fromFirebase(snapshot),
          toFirestore: mealItemConverter.toFirestore,
        )
        .get();

    if (!mealItemDoc.exists) {
      throw Exception('Meal item not found');
    }

    final meal = mealItemDoc.data();

    if (meal == null) {
      throw Exception('Meal item data is null');
    }

    return meal;
  }

  Future<List<FoodItem>> getAllMealItemsForMeal(String mealId) async {
    final user = _authRepository.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final firebaseUser = user.firebaseUser;

    final mealItemsCollection = _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('meals')
        .doc(mealId)
        .collection('items');

    final items = await mealItemsCollection
        .withConverter<FoodItem>(
          fromFirestore: (snapshot, _) => FoodItem.fromFirebase(snapshot),
          toFirestore: mealItemConverter.toFirestore,
        )
        .get();

    return items.docs.map((doc) => doc.data()).toList();
  }

  Future<void> deleteMealItemById(String mealId, String itemId) async {
    final user = _authRepository.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final firebaseUser = user.firebaseUser;

    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('meals')
        .doc(mealId)
        .collection('items')
        .doc(itemId)
        .delete();
  }

  Future<void> deleteAllItemsForMeal(String mealId) async {
    final user = _authRepository.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final firebaseUser = user.firebaseUser;

    final mealItemsCollection = _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('meals')
        .doc(mealId)
        .collection('items');

    final items = await mealItemsCollection.get();

    for (var item in items.docs) {
      await item.reference.delete();
    }
  }
}
