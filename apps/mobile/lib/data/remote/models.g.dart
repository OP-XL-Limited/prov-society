// GENERATED FILE. Run `npm run types` after changing supabase/migrations.
// dart format off
// ignore_for_file: type=lint

class JobRunsRow {
  const JobRunsRow({
    required this.id,
    required this.job,
    required this.status,
    required this.startedAt,
    this.finishedAt,
    required this.detail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobRunsRow.fromJson(Map<String, dynamic> json) => JobRunsRow(
    id: json['id'] as int,
    job: json['job'] as String,
    status: json['status'] as String,
    startedAt: DateTime.parse(json['started_at'] as String),
    finishedAt: json['finished_at'] == null ? null : DateTime.parse(json['finished_at'] as String),
    detail: json['detail'] as Object,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  final int id;
  final String job;
  final String status;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final Object detail;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'job': job,
    'status': status,
    'started_at': startedAt.toUtc().toIso8601String(),
    'finished_at': finishedAt?.toUtc().toIso8601String(),
    'detail': detail,
    'created_at': createdAt.toUtc().toIso8601String(),
    'updated_at': updatedAt.toUtc().toIso8601String(),
  };
}

class SettingsRow {
  const SettingsRow({
    required this.key,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SettingsRow.fromJson(Map<String, dynamic> json) => SettingsRow(
    key: json['key'] as String,
    value: json['value'] as Object,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  final String key;
  final Object value;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
    'key': key,
    'value': value,
    'created_at': createdAt.toUtc().toIso8601String(),
    'updated_at': updatedAt.toUtc().toIso8601String(),
  };
}
