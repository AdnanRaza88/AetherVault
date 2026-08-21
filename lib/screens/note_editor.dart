import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/vault_service.dart';
import '../widgets/backlinks_panel.dart';
import '../widgets/wikilink_text.dart';
import 'graph_view.dart';

class NoteEditor extends StatefulWidget {
  final String noteId;

  const NoteEditor({super.key, required this.noteId});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _controller;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    final note = context.read<VaultService>().getNote(widget.noteId);
    _controller = TextEditingController(text: note?.content ?? '');
  }

  @override
  void didUpdateWidget(NoteEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.noteId != widget.noteId) {
      final note = context.read<VaultService>().getNote(widget.noteId);
      _controller.text = note?.content ?? '';
      _editing = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VaultService>(
      builder: (context, vault, _) {
        final note = vault.getNote(widget.noteId);
        if (note == null) {
          return const Center(child: Text('Note not found'));
        }

        return Column(
          children: [
            AppBar(
              title: Text(note.title),
              actions: [
                IconButton(
                  icon: Icon(_editing ? Icons.visibility : Icons.edit),
                  onPressed: () {
                    setState(() => _editing = !_editing);
                    if (!_editing) {
                      vault.updateNote(widget.noteId, _controller.text);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.account_tree),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GraphViewScreen()),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: _editing
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        expands: true,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 15),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write in markdown...',
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: WikilinkText(
                        content: note.content,
                        onLinkTap: (id) => vault.selectNote(id),
                      ),
                    ),
            ),
            BacklinksPanel(note: note),
          ],
        );
      },
    );
  }
}
