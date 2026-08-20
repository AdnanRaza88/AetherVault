import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/vault_service.dart';
import '../widgets/sidebar.dart';
import 'note_editor.dart';
import 'graph_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vault = context.read<VaultService>();
      await vault.createDefaultVault();
      setState(() => _initialized = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          const SizedBox(
            width: 260,
            child: Sidebar(),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Consumer<VaultService>(
              builder: (context, vault, _) {
                if (vault.currentNote == null) {
                  return const Center(
                    child: Text(
                      'Select or create a note',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }
                return NoteEditor(noteId: vault.currentNote!.id);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewNoteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showNewNoteDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Note'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Note name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              final vault = context.read<VaultService>();
              await vault.createNote(name, '# $name\n\n');
              Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
