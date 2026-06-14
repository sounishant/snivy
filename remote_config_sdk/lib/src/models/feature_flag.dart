class FeatureFlag {
  final String id; 
  final Map<String, dynamic> value; 
  final bool enabled;

  FeatureFlag({required this.id, required this.value, required this.enabled});

  factory FeatureFlag.fromMap(String id, Map<String, dynamic> data) => FeatureFlag(
    id: id,
    value: data,
    enabled: data['enabled'] ?? true, 
}