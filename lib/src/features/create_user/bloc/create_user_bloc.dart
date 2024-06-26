import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';

part 'create_user_state.dart';

class CreateUserBloc extends Cubit<CreateUserState> {
  CreateUserBloc(UsersRepository usersRepository, UserModel? userModel)
      : _usersRepository = usersRepository,
        _userModel = userModel,
        super(const CreateUserState()) {
    init();
  }
  final UsersRepository _usersRepository;
  final UserModel? _userModel;

  final TextEditingController _firstNameController = TextEditingController();
  TextEditingController get firstNameController => _firstNameController;

  final TextEditingController _lastNameController = TextEditingController();
  TextEditingController get lastNameController => _lastNameController;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  init() {
    if (_userModel != null) {
      _firstNameController.text = _userModel.firstName ?? '';
      _lastNameController.text = _userModel.lastName ?? '';
      _emailController.text = _userModel.email ?? '';

      emit(
        state.copyWith(
          firstName: NameInput.dirty(value: _userModel.firstName!),
          lastName: NameInput.dirty(value: _userModel.lastName!),
          email: Email.dirty(value: _userModel.email!),
          job: _userModel.job == null
              ? null
              : NameInput.dirty(value: _userModel.job!),
        ),
      );
    }
  }

  onChangeFirstName(String value) {
    final firstName = NameInput.dirty(value: value);
    emit(
      state.copyWith(
        firstName: firstName,
      ),
    );
  }

  onChangeLastName(String value) {
    final lastName = NameInput.dirty(value: value);
    emit(
      state.copyWith(
        lastName: lastName,
      ),
    );
  }

  onChangeEmail(String value) {
    final email = Email.dirty(value: value);
    emit(
      state.copyWith(
        email: email,
      ),
    );
  }

  onChangeJob(String value) {
    final job = NameInput.dirty(value: value);
    emit(
      state.copyWith(
        job: job,
      ),
    );
  }

  validate() {
    final formInputs = <FormzInput>[
      state.firstName,
      state.lastName,
      state.email,
      state.job,
    ];

    return Formz.validate(formInputs);
  }

  createUpdateUser() {
    if (validate() && state.viewStatus != ViewStatusModel.submitting) {
      emit(
        state.copyWith(
          viewStatus: ViewStatusModel.submitting,
        ),
      );
      final data = {
        'first_name': state.firstName.value,
        'last_name': state.lastName.value,
        'email': state.email.value,
        'job': state.job.value,
      };

      if (_userModel != null) {
         _usersRepository.update(data, _userModel.id!).then(
        (value) {
          emit(
            state.copyWith(
              viewStatus: ViewStatusModel.success,
            ),
          );
        },
      ).onError(
        (error, stackTrace) {
          emit(
            state.copyWith(
              viewStatus: ViewStatusModel.failure,
            ),
          );
        },
      );
      } else {
        _usersRepository.create(data).then(
          (value) {
            emit(
              state.copyWith(
                viewStatus: ViewStatusModel.success,
              ),
            );
          },
        ).onError(
          (error, stackTrace) {
            emit(
              state.copyWith(
                viewStatus: ViewStatusModel.failure,
              ),
            );
          },
        );
      }
    }
  }

  resetStatus() {
    emit(
      state.copyWith(
        viewStatus: ViewStatusModel.idle,
      ),
    );
  }
}
