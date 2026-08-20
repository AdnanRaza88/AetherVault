import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/vault_service.dart';

class GraphViewScreen extends StatelessWidget {
  const GraphViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph View'),
      ),
      body: Consumer<VaultService>(
        builder: (context, vault, _) {
          final notes = vault.notes;
          if (notes.isEmpty) {
            return const Center(child: Text('No notes to display'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                color: const Color(0xFF1A1A1A),
                child: ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    'Links: ${note.links.length}  |  Backlinks: ${note.backlinks.length}',
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  trailing: note.links.isNotEmpty
                      ? const Icon(Icons.hub, size: 18, color: Color(0xFFA78BFA))
                      : null,
                  onTap: () {
                    vault.selectNote(note.id);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
