import 'package:flutter/material.dart';

class TestThemeScreen extends StatelessWidget {
  const TestThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Preview'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ======================
          // TEXT STYLES
          // ======================
          Text('Text styles', style: textTheme.titleLarge),
          const SizedBox(height: 12),

          Text('Display Large', style: textTheme.displayLarge),
          Text('Headline Medium', style: textTheme.headlineMedium),
          Text('Title Large', style: textTheme.titleLarge),
          Text('Body Large', style: textTheme.bodyLarge),
          Text('Body Medium', style: textTheme.bodyMedium),
          Text('Label Large', style: textTheme.labelLarge),

          const SizedBox(height: 24),
          const Divider(),

          // ======================
          // BUTTONS
          // ======================
          Text('Buttons', style: textTheme.titleLarge),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Elevated'),
              ),
              FilledButton(
                onPressed: () {},
                child: const Text('Filled'),
              ),
              FilledButton.tonal(
                onPressed: () {},
                child: const Text('Tonal'),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Outlined'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Text'),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),

          // ======================
          // FORM FIELDS
          // ======================
          Text('Form fields', style: textTheme.titleLarge),
          const SizedBox(height: 12),

          TextField(
            decoration: const InputDecoration(
              labelText: 'Text field',
              hintText: 'Enter text',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            items: const [
              DropdownMenuItem(value: '1', child: Text('Option 1')),
              DropdownMenuItem(value: '2', child: Text('Option 2')),
            ],
            onChanged: (_) {},
            decoration: const InputDecoration(
              labelText: 'Dropdown',
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),

          // ======================
          // CARDS
          // ======================
          Text('Cards', style: textTheme.titleLarge),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Card title', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'This is a card body using surface colors.',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),

          // ======================
          // LIST TILE
          // ======================
          Text('List tiles', style: textTheme.titleLarge),
          const SizedBox(height: 12),

          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('List item'),
                  subtitle: Text('Subtitle text'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(height: 0),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Another item'),
                  subtitle: Text('More details'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),

          // ======================
          // COLOR SWATCHES
          // ======================
          Text('ColorScheme preview', style: textTheme.titleLarge),
          const SizedBox(height: 12),

          _ColorTile('Primary', colors.primary, colors.onPrimary),
          _ColorTile('Secondary', colors.secondary, colors.onSecondary),
          _ColorTile('Background', colors.surface, colors.onSurface),
          _ColorTile('Surface', colors.surface, colors.onSurface),
          _ColorTile('Error', colors.error, colors.onError),

          const SizedBox(height: 24),
          const Divider(),

          // ======================
          // FEEDBACK
          // ======================
          Text('Feedback', style: textTheme.titleLarge),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('This is a SnackBar'),
                ),
              );
            },
            child: const Text('Show SnackBar'),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Dialog title'),
                    content: const Text(
                      'This dialog uses the DialogTheme colors.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Confirm'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Show Dialog'),
          ),

          const SizedBox(height: 32),
        ],
      ),

      // ======================
      // BOTTOM NAVIGATION
      // ======================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),

      // ======================
      // FAB
      // ======================
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ======================
// COLOR TILE WIDGET
// ======================
class _ColorTile extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _ColorTile(
      this.label,
      this.color,
      this.textColor,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
