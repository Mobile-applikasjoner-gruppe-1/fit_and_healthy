import 'package:fit_and_healthy/src/features/nutrition/controllers/meal_controller.dart';
import 'package:fit_and_healthy/src/features/nutrition/controllers/meal_item_controller.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/meal.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal_item/food_item.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MealCreationScreen extends ConsumerStatefulWidget {
  static const route = 'create';
  static const routeName = 'Create Meal';

  @override
  _MealCreationScreenState createState() => _MealCreationScreenState();
}

class _MealCreationScreenState extends ConsumerState<MealCreationScreen> {
  final TextEditingController _titleController = TextEditingController();

  Meal _getMealFromFields() {
    // TODO: Implement getting meal from fields in form
    final meal = Meal(
      id: 'temp',
      name: _titleController.text,
      timestamp: DateTime(_selectedDate.year, _selectedDate.month,
          _selectedDate.day, _selectedTime.hour, _selectedTime.minute),
    );

    // TODO: Implement getting meal from UI
    meal.items.add(
      FoodItem(
        id: '1',
        name: 'Item 1',
        barcode: '1234567890',
        nutritionInfo: {
          'calories': 100,
          'protein': 10,
          'fat': 5,
          'sugars': 5,
          'fiber': 2,
          'carbs': 20,
        },
      ),
    );

    return meal;
  }

  void _createMeal() async {
    final meal = _getMealFromFields();

    final mealController = ref.read(mealControllerProvider.notifier);
    final mealItemController = ref.read(mealItemControllerProvider.notifier);

    final id = await mealController.addMeal(meal);

    await mealItemController.addItemsToMeal(id, meal.items);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Meal added successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
    if (context.canPop()) {
      Navigator.pop(context);
    }
  }

  DateTime _selectedDate = DateTime.now(); // Selected date
  TimeOfDay _selectedTime = TimeOfDay.now(); // Selected time
  List<FoodItem> _items = []; // List of items added to the meal.

  /**
   * Handles the date selection process using `showDatePicker`.
   * Updates the selected date if the user picks one.
   */
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  /**
   * Handles the time selection process using `showTimePicker`.
   * Updates the selected time if the user picks one.
   */
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  /**
   * Displays an alert dialog when no exercises are added.
   */
  Future<void> _showNoItemsDialog(BuildContext context) async {
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No Items Added'),
          content: const Text(
              'You have not added any items. Do you want to continue?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldContinue == true) {
      _createMeal();
    }
  }

  final TextEditingController dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(label: Text('Title')),
                  controller: _titleController,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    await _selectDate(context);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(
                        '${DateFormat.EEEE().format(_selectedDate)} ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await _selectTime(context);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.access_alarms_outlined),
                      const SizedBox(width: 8),
                      Text(' ${_selectedTime.format(context)}'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Items Added',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                if (_items.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return ListTile(
                        title: Text('${item.name} (${item.grams})'),
                      );
                    },
                  )
                else
                  const Text('No items added yet.'),
              ],
            ),
          ),
        ),
      ),
    );

    return NestedScaffold(
      appBar: AppBar(
        title: Text('Create Meal'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_items.isEmpty) {
                _showNoItemsDialog(context);
              } else {
                _createMeal();
              }
            },
          ),
        ],
      ),
      body: content,
    );
  }
}
