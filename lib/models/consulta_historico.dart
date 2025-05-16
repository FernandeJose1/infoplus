class ConsultaHistorico {
  final String id;
  final String userId;
  final String tipo; // 'vaga' ou 'preco'
  final DateTime timestamp;

  ConsultaHistorico({
    required this.id,
    required this.userId,
    required this.tipo,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'tipo': tipo,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ConsultaHistorico.fromMap(Map<String, dynamic> map) {
    return ConsultaHistorico(
      id: map['id'],
      userId: map['userId'],
      tipo: map['tipo'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}