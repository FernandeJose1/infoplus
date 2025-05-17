import 'package:freezed_annotation/freezed_annotation.dart';

part 'job.freezed.dart';
part 'job.g.dart';

@freezed
class Job with _$Job {
  const factory Job({
    required String id,
    required String title,
    required String location,
    required String province, // Adicionado
    required String category,
    required DateTime createdAt,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}