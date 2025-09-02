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

class _VocabListScreenState extends State<VocabListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Vocab>('vocabBox');

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Entries'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Words'),
            Tab(text: 'Times'),
            Tab(text: 'Sentences'),
            Tab(text: 'Verbs'),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Vocab> b, _) {
          if (b.values.isEmpty) {
            return const Center(child: Text('No entries yet'));
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

          return TabBarView(
            controller: _tabController,
            children: [
              _buildCategoryList(words),
              _buildCategoryList(times),
              _buildCategoryList(sentences),
              _buildCategoryList(verbs),
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

  Widget _buildCategoryList(List<Vocab> items) {
    if (items.isEmpty) {
      return const Center(child: Text('No entries in this category'));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 2,
          child: _buildListTitle(context, items[index]),
        );
      },
    );
  }

  Widget _buildListTitle(BuildContext context, Vocab vocab) {
    return ListTile(
      title: Text(vocab.displayTitle()),
      subtitle: Text(vocab.displaySubtext()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueAccent),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEditVocabScreen(existing: vocab),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
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
