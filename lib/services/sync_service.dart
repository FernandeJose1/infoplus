import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'sync_service.g.dart';

// 1. Definição da tabela local
class Items extends Table {
  TextColumn get id => text()();
  TextColumn get data => text()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// 2. Banco de dados local via Drift
@DriftDatabase(tables: [Items])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

// 3. Conexão preguiçosa ao arquivo SQLite
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final docs = await getApplicationDocumentsDirectory();
    final file = File(p.join(docs.path, 'infoplus.sqlite'));
    return NativeDatabase(file);
  });
}

// 4. Extensão com métodos de sincronização
extension SyncService on LocalDatabase {
  /// Retorna itens que ainda não foram sincronizados
  Future<List<Item>> getPending() {
    return (select(items)..where((tbl) => tbl.synced.equals(false))).get();
  }

  /// Marca item como sincronizado
  Future<void> markSynced(String id) {
    return (update(items)..where((tbl) => tbl.id.equals(id))).write(
      ItemsCompanion(synced: Value(true)),
    );
  }

  /// Envia pendências ao servidor e marca como sincronizado
  Future<void> pushPendingToServer() async {
    final pending = await getPending();
    for (final item in pending) {
      // envie para Firestore via HTTP ou Cloud Functions
      // após sucesso:
      await markSynced(item.id);
    }
  }
}