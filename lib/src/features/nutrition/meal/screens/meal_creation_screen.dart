import 'package:fit_and_healthy/src/features/nutrition/controllers/meal_controller.dart';
import 'package:fit_and_healthy/src/features/nutrition/controllers/meal_item_controller.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/meal.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/widgets/food_item_search.dart';
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
    final meal = Meal(
      id: 'temp',
      name: _titleController.text,
      timestamp: DateTime(_selectedDate.year, _selectedDate.month,
          _selectedDate.day, _selectedTime.hour, _selectedTime.minute),
    );

    meal.items.addAll(_items);

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

  void _removeFoodItem(FoodItem item) {
    setState(() {
      _items.remove(item);
    });
  }

  void _showEditGramsDialog(FoodItem item, double currentGrams) {
    final TextEditingController gramsController =
        TextEditingController(text: currentGrams.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Grams'),
        content: TextField(
          controller: gramsController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Enter new weight in grams'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final grams =
                  double.tryParse(gramsController.text) ?? currentGrams;
              if (grams > 0) {
                setState(() {
                  item.setGrams(grams);
                });
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
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
                FoodItemSearch(
                  onFoodItemAdded: (item) {
                    setState(() {
                      _items.add(item);
                    });
                  },
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
                        title: Text(item.name),
                        subtitle: Text('${item.grams} grams'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditGramsDialog(item, item.grams);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _removeFoodItem(item);
                              },
                            ),
                          ],
                        ),
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
