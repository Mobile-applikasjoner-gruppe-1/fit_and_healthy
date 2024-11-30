enum Gender { male, female }

extension GenderExtension on Gender {
  static toFirestore(Gender gender) {
    return gender.toString().split('.').last;
  }

  static fromFirestore(String gender) {
    return Gender.values.firstWhere(
      (g) => g.toString() == 'Gender.${gender}',
      orElse: () => Gender.male,
    );
  }
}
