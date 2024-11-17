enum SupportedAuthProvider {
  google('google.com'),
  facebook('facebook.com'),
  apple('apple.com');

  final String providerId;
  const SupportedAuthProvider(this.providerId);
}
