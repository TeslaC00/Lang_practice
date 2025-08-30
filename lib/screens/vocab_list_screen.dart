// lib/screens/vocab_list_screen.dart
// ----------------------------------
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/vocab.dart';
import 'add_edit_vocab_screen.dart';

class VocabListScreen extends StatelessWidget {
  const VocabListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Vocab>('vocabBox');
    return Scaffold(
      appBar: AppBar(title: const Text('All Entries')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Vocab> b, _) {
          if (b.values.isEmpty) {
            return const Center(child: Text('No entries yet.'));
          }
          final words = b.values
              .where((vocab) => vocab.type == VocabType.word)
              .toList();
          final times = b.values
              .where((vocab) => vocab.type == VocabType.time)
              .toList();
          final sentences = b.values
              .where((vocab) => vocab.type == VocabType.sentence)
              .toList();
          final verbs = b.values
              .where((vocab) => vocab.type == VocabType.verb)
              .toList();

          return ListView(
            children: [
              if (words.isNotEmpty) ...[
                const ListTile(title: Text('Words')),
                ...words.map((vocab) => _buildListTitle(context, vocab)),
                const Divider(),
              ],
              if (times.isNotEmpty) ...[
                const ListTile(title: Text('Times')),
                ...times.map((vocab) => _buildListTitle(context, vocab)),
                const Divider(),
              ],
              if (sentences.isNotEmpty) ...[
                const ListTile(title: Text('Sentences')),
                ...sentences.map((vocab) => _buildListTitle(context, vocab)),
                const Divider(),
              ],
              if (verbs.isNotEmpty) ...[
                const ListTile(title: Text('Verbs')),
                ...verbs.map((vocab) => _buildListTitle(context, vocab)),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditVocabScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListTitle(BuildContext context, Vocab vocab) {
    return ListTile(
      title: Text(vocab.displayTitle()),
      subtitle: Text(vocab.displaySubtext()),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddEditVocabScreen(existing: vocab),
          ),
        ),
      ),
    );
  }
}
