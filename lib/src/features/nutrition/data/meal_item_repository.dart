import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/data/meal_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal_item/food_item.dart';
import 'package:fit_and_healthy/src/features/user/user_repository.dart';

final mealItemConverter = (
  fromFirestore: (snapshot, _) => FoodItem.fromFirebase(snapshot),
  toFirestore: (FoodItem foodItem, _) => foodItem.toFirebase(),
);

class MealItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;
  final String mealId;

  static const collectionName = 'items';

  MealItemRepository(this._authRepository, this.mealId);

  CollectionReference<FoodItem> _getMealItemsCollection() {
    final user = _authRepository.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final firebaseUser = user.firebaseUser;

    return _firestore
        .collection(UserRepository.collectionName)
        .doc(firebaseUser.uid)
        .collection(MealRepository.collectionName)
        .doc(mealId)
        .collection(collectionName)
        .withConverter<FoodItem>(
          fromFirestore: (snapshot, _) => FoodItem.fromFirebase(snapshot),
          toFirestore: mealItemConverter.toFirestore,
        );
  }

  Future<String> addMealItem(FoodItem mealItem) async {
    final docRef = await _getMealItemsCollection().add(mealItem);

    return docRef.id;
  }

  Future<FoodItem> getMealItemById(String itemId) async {
    final mealItemDoc = await _getMealItemsCollection().doc(itemId).get();

    if (!mealItemDoc.exists) {
      throw Exception('Meal item not found');
    }

    final meal = mealItemDoc.data();

    if (meal == null) {
      throw Exception('Meal item data is null');
    }

    return meal;
  }

  Future<List<FoodItem>> getAllMealItemsForMeal() async {
    final items = await _getMealItemsCollection().get();

    return items.docs.map((doc) => doc.data()).toList();
  }

  Future<void> deleteMealItemById(String itemId) async {
    await _getMealItemsCollection().doc(itemId).delete();
  }

  Future<void> deleteAllItemsForMeal() async {
    final items = await _getMealItemsCollection().get();

    for (var item in items.docs) {
      await item.reference.delete();
    }
  }

  Stream<List<FoodItem>> getMealItemsStream() {
    return _getMealItemsCollection().snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  Future<void> addFoodItems(List<FoodItem> foodItems) async {
    WriteBatch batch = _firestore.batch();

    foodItems.forEach((foodItem) {
      final mealItemRef = _getMealItemsCollection().doc();
      batch.set(mealItemRef, foodItem);
    });

    await batch.commit();
  }
}
