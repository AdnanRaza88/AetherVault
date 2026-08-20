import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';

class VaultService extends ChangeNotifier {
  final Map<String, Note> _notes = {};
  String? vaultRoot;
  String? currentNoteId;

  List<Note> get notes => _notes.values.toList()
    ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

  Note? get currentNote => currentNoteId != null ? _notes[currentNoteId] : null;

  Future<void> openVault(String path) async {
    vaultRoot = path;
    _notes.clear();
    await _scanVault();
    notifyListeners();
  }

  Future<void> createDefaultVault() async {
    final dir = await getApplicationDocumentsDirectory();
    final vaultDir = Directory(p.join(dir.path, 'AetherVault'));
    if (!await vaultDir.exists()) {
      await vaultDir.create(recursive: true);
      await Directory(p.join(vaultDir.path, 'daily')).create();
      await Directory(p.join(vaultDir.path, 'templates')).create();
      final welcome = File(p.join(vaultDir.path, 'Welcome.md'));
      await welcome.writeAsString(
          '# Welcome\n\nThis is your first note in AetherVault.\n\nUse [[Welcome]] style links to connect notes.\n');
    }
    await openVault(vaultDir.path);
  }

  Future<void> _scanVault() async {
    if (vaultRoot == null) return;
    final root = Directory(vaultRoot!);
    await for (final entity in root.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.md')) {
        await _upsertNote(entity.path);
      }
    }
    _rebuildBacklinks();
  }

  Future<void> _upsertNote(String filePath) async {
    if (vaultRoot == null) return;
    final content = await File(filePath).readAsString();
    final rel = p.relative(filePath, from: vaultRoot!);
    final id = rel.replaceAll(r'\', '/').replaceAll('.md', '');
    final title = p.basenameWithoutExtension(filePath);
    final links = _extractWikilinks(content);

    _notes[id] = Note(
      id: id,
      title: title,
      path: filePath,
      content: content,
      links: links,
    );
  }

  List<String> _extractWikilinks(String content) {
    final regex = RegExp(r'\[\[([^\]|]+)(?:\|[^\]]*)?\]\]');
    return regex.allMatches(content).map((m) => m.group(1)!.trim()).toList();
  }

  void _rebuildBacklinks() {
    for (final note in _notes.values) {
      note.backlinks = [];
      note.unlinkedMentions = [];
    }

    for (final source in _notes.values) {
      for (final target in source.links) {
        final normalized = resolveNoteId(target);
        final targetNote = _notes[normalized];
        if (targetNote != null && !targetNote.backlinks.contains(source.id)) {
          targetNote.backlinks.add(source.id);
        }
      }

      for (final target in _notes.values) {
        if (target.id == source.id) continue;
        final pattern = RegExp(r'\b' + RegExp.escape(target.title) + r'\b', caseSensitive: false);
        if (pattern.hasMatch(source.content) && !source.links.contains(target.id)) {
          target.unlinkedMentions.add(source.id);
        }
      }
    }
  }

  String resolveNoteId(String target) {
    final clean = target.replaceAll('.md', '').replaceAll(r'\', '/');
    if (_notes.containsKey(clean)) return clean;
    for (final entry in _notes.entries) {
      if (entry.key.toLowerCase() == clean.toLowerCase()) return entry.key;
      if (entry.value.title.toLowerCase() == clean.toLowerCase()) return entry.key;
    }
    return clean;
  }

  Future<void> createNote(String id, String content) async {
    if (vaultRoot == null) return;
    final filePath = p.join(vaultRoot!, '$id.md');
    final file = File(filePath);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);
    await _upsertNote(filePath);
    _rebuildBacklinks();
    currentNoteId = id;
    notifyListeners();
  }

  Future<void> updateNote(String id, String content) async {
    final note = _notes[id];
    if (note == null) return;
    await File(note.path).writeAsString(content);
    note.content = content;
    note.links = _extractWikilinks(content);
    _rebuildBacklinks();
    notifyListeners();
  }

  Future<void> openDailyNote() async {
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final id = 'daily/$date';
    if (_notes.containsKey(id)) {
      currentNoteId = id;
      notifyListeners();
      return;
    }
    await createNote(id, '# $date\n\n');
  }

  void selectNote(String id) {
    currentNoteId = resolveNoteId(id);
    notifyListeners();
  }

  Note? getNote(String id) {
    return _notes[resolveNoteId(id)];
  }
}
