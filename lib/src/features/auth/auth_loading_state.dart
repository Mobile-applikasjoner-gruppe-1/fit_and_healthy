class AuthLoadingState {
  const AuthLoadingState.initial()
      : state = AuthLoadingStateEnum.initial,
        error = null;
  const AuthLoadingState.loading()
      : state = AuthLoadingStateEnum.loading,
        error = null;
  const AuthLoadingState.success()
      : state = AuthLoadingStateEnum.success,
        error = null;
  const AuthLoadingState.error(Exception error)
      : state = AuthLoadingStateEnum.error,
        error = error;

  const AuthLoadingState(this.state, this.error);

  final AuthLoadingStateEnum state;
  final Exception? error;

  bool get isInitial => state == AuthLoadingStateEnum.initial;

  bool get isLoading => state == AuthLoadingStateEnum.loading;

  bool get isSuccess => state == AuthLoadingStateEnum.success;

  bool get isError => state == AuthLoadingStateEnum.error;
}

enum AuthLoadingStateEnum {
  initial,
  loading,
  success,
  error,
}
