// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAuthHash() => r'cb440927c3ab863427fd4b052a8ccba4c024c863';

/// See also [firebaseAuth].
@ProviderFor(firebaseAuth)
final firebaseAuthProvider = Provider<FirebaseAuth>.internal(
  firebaseAuth,
  name: r'firebaseAuthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firebaseAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthRef = ProviderRef<FirebaseAuth>;
String _$firebaseAuthRepositoryHash() =>
    r'fc210e85754d1f189169198ee44a029f7e85e339';

/// See also [firebaseAuthRepository].
@ProviderFor(firebaseAuthRepository)
final firebaseAuthRepositoryProvider =
    Provider<FirebaseAuthRepository>.internal(
  firebaseAuthRepository,
  name: r'firebaseAuthRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseAuthRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthRepositoryRef = ProviderRef<FirebaseAuthRepository>;
String _$firebaseAuthStateChangeHash() =>
    r'484cf4636231cc3e06e5b56b5f865283f554e280';

/// See also [firebaseAuthStateChange].
@ProviderFor(firebaseAuthStateChange)
final firebaseAuthStateChangeProvider = StreamProvider<AuthUser?>.internal(
  firebaseAuthStateChange,
  name: r'firebaseAuthStateChangeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseAuthStateChangeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthStateChangeRef = StreamProviderRef<AuthUser?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
