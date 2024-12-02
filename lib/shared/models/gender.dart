/// Enum representing the gender of an individual.
///
/// Values:
/// - [male]: Represents the male gender.
/// - [female]: Represents the female gender.
enum Gender { male, female }

/// Extension on [Gender] to provide utility methods for Firestore integration.
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
