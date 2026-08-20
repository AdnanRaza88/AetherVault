import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/vault_service.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VaultService>(
      builder: (context, vault, _) {
        return Container(
          color: const Color(0xFF141414),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text(
                      'AetherVault',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.today, size: 20),
                      tooltip: 'Daily Note',
                      onPressed: () => vault.openDailyNote(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: vault.notes.length,
                  itemBuilder: (context, index) {
                    final note = vault.notes[index];
                    final selected = vault.currentNoteId == note.id;
                    return ListTile(
                      dense: true,
                      selected: selected,
                      selectedTileColor: const Color(0xFF2A2A2A),
                      title: Text(
                        note.title,
                        style: TextStyle(
                          color: selected ? const Color(0xFFA78BFA) : Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () => vault.selectNote(note.id),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
