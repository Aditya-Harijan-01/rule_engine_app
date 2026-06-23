import 'package:flutter/material.dart';

class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    required this.snapshot,
    required this.builder,
    super.key,
  });

  final AsyncSnapshot<T> snapshot;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Something went wrong\n${snapshot.error}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (!snapshot.hasData)
      return const Center(child: CircularProgressIndicator());
    return builder(snapshot.data as T);
  }
}
