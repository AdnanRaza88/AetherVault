import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../services/vault_service.dart';

class BacklinksPanel extends StatelessWidget {
  final Note note;

  const BacklinksPanel({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final vault = context.read<VaultService>();

    return Container(
      height: 180,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
        color: Color(0xFF121212),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Linked Mentions',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
            ),
          ),
          Expanded(
            child: note.backlinks.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('No linked mentions', style: TextStyle(color: Colors.white38, fontSize: 13)),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: note.backlinks.map((id) {
                      final n = vault.getNote(id);
                      return ListTile(
                        dense: true,
                        title: Text(n?.title ?? id, style: const TextStyle(fontSize: 13)),
                        onTap: () => vault.selectNote(id),
                      );
                    }).toList(),
                  ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(
              'Unlinked Mentions',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
            ),
          ),
          Expanded(
            child: note.unlinkedMentions.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('No unlinked mentions', style: TextStyle(color: Colors.white38, fontSize: 13)),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: note.unlinkedMentions.map((id) {
                      final n = vault.getNote(id);
                      return ListTile(
                        dense: true,
                        title: Text(n?.title ?? id, style: const TextStyle(fontSize: 13)),
                        onTap: () => vault.selectNote(id),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
