class FeatureFlag {
  final String id;
  final dynamic value;
  final bool enabled;

  FeatureFlag({required this.id, required this.value, required this.enabled});

  factory FeatureFlag.fromJson(Map<String, dynamic> json) => FeatureFlag(
    id: json['id'],
    value: json['value'],
    enabled: json['enabled'] ?? true,
  );
}