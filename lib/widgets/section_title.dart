import 'package:flutter/material.dart';

/// Section title text.
class SectionTitle extends StatelessWidget {
  /// Constructor.
  const SectionTitle(this.title, {super.key});

  /// Title text.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}
