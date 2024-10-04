import 'package:fit_and_healthy/src/features/settings/settings_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Exercise',
          ),
          NavigationDestination(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant),
            label: 'Nutrition',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
      body: Padding(
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
          )),
    );
  }
}
