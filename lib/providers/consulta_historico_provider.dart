import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/consulta_historico.dart';

class ConsultaHistoricoProvider extends ChangeNotifier {
  final _ref = FirebaseFirestore.instance.collection('historico_consultas');
  List<ConsultaHistorico> _consultas = [];

  List<ConsultaHistorico> get consultas => _consultas;

  /// Carrega histórico de consultas do usuário nas últimas 24h
  Future<void> carregarHistorico(String userId) async {
    final now = DateTime.now();
    final limite = now.subtract(const Duration(hours: 24));

    final snapshot = await _ref
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(limite))
        .orderBy('timestamp', descending: true)
        .get();

    _consultas = snapshot.docs
        .map((doc) => ConsultaHistorico.fromMap(doc.data()))
        .toList();
    notifyListeners();
  }

  /// Salva nova consulta e opcionalmente atualiza histórico
  Future<void> salvar(ConsultaHistorico consulta) async {
    await _ref.doc(consulta.id).set(consulta.toMap());
    // Após salvar, atualizar lista completa em admin e usuário
    _consultas.insert(0, consulta);
    notifyListeners();
  }

  /// Carrega todo o histórico de consultas (admin)
  Future<void> fetchHistorico() async {
    final snapshot = await _ref
        .orderBy('timestamp', descending: true)
        .get();

    _consultas = snapshot.docs
        .map((doc) => ConsultaHistorico.fromMap(doc.data()))
        .toList();
    notifyListeners();
  }
}