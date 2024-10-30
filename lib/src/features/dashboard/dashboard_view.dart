import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: const [
            Card(
              color: Colors.blue,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Exercise'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  // add random content here
                  Text('Exercise content'),
                ],
              ),
            ),
            Card(
              color: Colors.green,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Nutrition'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  // add random content here
                  Text('Nutrition content'),
                ],
              ),
            ),
            Card(
              color: Colors.red,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Goals'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  // add random content here
                  Text('Goals content'),
                ],
              ),
            ),
            Card(
              color: Colors.orange,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Something else'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  // add random content here
                  Text('Something else content'),
                ],
              ),
            ),
          ],
        ));
  }
}
