import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jam_it/features/home/view/widgets/search_list.dart';
import 'package:jam_it/features/home/viewmodel/query_viewmodel.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) =>
                  ref.read(queryNotifierProvider.notifier).updateQuery(value),
            ),
            const SearchList(),
          ],
        ),
      ),
    );
  }
}
// 