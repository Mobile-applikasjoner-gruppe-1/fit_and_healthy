import 'package:flutter/widgets.dart';

class ExerciseView extends StatelessWidget {
  const ExerciseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text("Date"),
        Text("Exercise List"),
      ],
    ));
  }
}
