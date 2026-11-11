class SalaryModel {
  final String id;
  final String userId;
  final double baseSalary;
  final double hourlyRate;
  final String currency;

  SalaryModel({
    required this.id,
    required this.userId,
    required this.baseSalary,
    required this.hourlyRate,
    required this.currency,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      id: json['id'],
      userId: json['user_id'],
      baseSalary: (json['base_salary'] as num).toDouble(),
      hourlyRate: (json['hourly_rate'] as num).toDouble(),
      currency: json['currency'] ?? 'BDT',
    );
  }
}