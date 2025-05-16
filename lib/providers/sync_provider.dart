import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../services/sync_service.dart';

class SyncProvider extends ChangeNotifier {
  final LocalDatabase _db = LocalDatabase();
  bool syncing = false;

  Future<void> sync() async {
    syncing = true;
    notifyListeners();
    try {
      final pending = await _db.getPending();

      // Preparar dados para enviar ao Cloud Functions
      final items = pending.map((item) => {
        'id': item.id,
        'data': item.data,
        'synced': item.synced,
      }).toList();

      final callable = FirebaseFunctions.instance.httpsCallable('syncData');
      await callable.call({'items': items});

      // Após sucesso, marcar itens como sincronizados localmente
      for (final item in pending) {
        await _db.markSynced(item.id);
      }
    } catch (e) {
      debugPrint('Erro na sincronização: $e');
    }
    syncing = false;
    notifyListeners();
  }
}