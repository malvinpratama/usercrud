part of 'create_user_bloc.dart';

class CreateUserState extends Equatable {
  final ViewStatusModel viewStatus;
  final NameInput firstName;
  final NameInput lastName;
  final Email email;
  final NameInput job;

  const CreateUserState({
    this.viewStatus = ViewStatusModel.idle,
    this.firstName = const NameInput.pure(),
    this.lastName = const NameInput.pure(),
    this.email = const Email.pure(),
    this.job = const NameInput.pure(),
  });

  CreateUserState copyWith({
    ViewStatusModel? viewStatus,
    NameInput? firstName,
    NameInput? lastName,
    Email? email,
    NameInput? job,
  }) {
    return CreateUserState(
      viewStatus: viewStatus ?? this.viewStatus,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      job: job ?? this.job,
    );
  }

  @override
  List<Object?> get props => [
        viewStatus,
        firstName,
        lastName,
        email,
        job,
      ];
}
