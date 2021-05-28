part of 'signup_cubit.dart';

enum SignUpStatus { initial, submitting, sucess, error }

class SignUpState extends Equatable {
  final String username;
  final String email;
  final String password;
  final SignUpStatus status;
  final Failure failure;

  bool get isFormValid =>
      email.isNotEmpty && username.isNotEmpty && password.isNotEmpty;

  const SignUpState(
      {@required this.email,
      @required this.password,
      @required this.status,
      @required this.failure,
      @required this.username});

  factory SignUpState.initial() {
    return SignUpState(
        username: '',
        email: '',
        password: '',
        status: SignUpStatus.initial,
        failure: const Failure());
  }



  @override
  List<Object> get props => [username, email, password, status, failure];

  SignUpState copyWith({
    String username,
    String email,
    String password,
    SignUpStatus status,
    Failure failure,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
