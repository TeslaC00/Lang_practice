// lib/screens/vocab_list_screen.dart
// ----------------------------------
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/vocab.dart';
import '../services/logger_service.dart';
import 'add_edit_vocab_screen.dart';

class VocabListScreen extends StatefulWidget {
  const VocabListScreen({super.key});

  @override
  State<VocabListScreen> createState() => _VocabListScreenState();
}

class _VocabListScreenState extends State<VocabListScreen> {
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
              if (words.isNotEmpty) _buildCategory('Words', words),
              if (times.isNotEmpty) _buildCategory('Times', times),
              if (sentences.isNotEmpty) _buildCategory('Sentences', sentences),
              if (verbs.isNotEmpty) _buildCategory('Verbs', verbs),
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

  Widget _buildCategory(String title, List<Vocab> items) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: items.length > 10 ? 300 : items.length * 30,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildListTitle(context, items[index]);
            },
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildListTitle(BuildContext context, Vocab vocab) {
    return ListTile(
      dense: true,
      title: Text(vocab.displayTitle()),
      subtitle: Text(vocab.displaySubtext()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEditVocabScreen(existing: vocab),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmAndDelete(vocab),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndDelete(Vocab vocab) async {
    // Show confirmation dialog
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
            'Are you sure you want to delete "${vocab.displayTitle()}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    // Check if the widget is still mounted before using context
    if (!mounted) return;

    // If confirmed, delete the item
    if (confirmDelete != true) return;

    try {
      vocab.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${vocab.displayTitle()}" deleted')),
      );
    } catch (e) {
      LoggerService().e('Failed to delete vocab: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete item.')));
    }
  }
}
