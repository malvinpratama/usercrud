import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../models/models.dart';
import '../../../../../repositories/repositories.dart';
part 'user_non_selected_state.dart';

class UserNonSelectedBloc extends Cubit<UserNonSelectedState> {
  UserNonSelectedBloc(UsersRepository usersRepository)
      : _usersRepository = usersRepository,
        super(const UserNonSelectedState()) {
    scrollController.addListener(
      () {
        if (scrollController.position.extentAfter == 0) {
          loadMore(false);
        }
      },
    );
    init();
  }
  final UsersRepository _usersRepository;
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  init() {
    emit(
      state.copyWith(
        userList: [],
        page: 1,
      ),
    );
    loadMore(true);
  }

  loadMore(bool init) {
    if (state.total == state.userList.length && !init) {
      return;
    }

    _usersRepository.getUserList(state.page, state.limit).then(
      (usersResponse) {
        final user = [...state.userList];
        if (usersResponse.user != null) {
          user.addAll(usersResponse.user!);
        }
        emit(
          state.copyWith(
            userList: user,
            total: usersResponse.total,
            viewStatus: ViewStatusModel.idle,
            page: state.page != usersResponse.totalPages
                ? state.page + 1
                : usersResponse.totalPages,
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

  onChangeSelectedOption(String value, UserModel user) {
    emit(
      state.copyWith(
        selectedOption: value,
        selectedUser: user,
      ),
    );
  }

  Future<bool> delete() async {
    return await _usersRepository.delete(state.selectedUser!.id!).then(
      (value) {
        if (value == 204) {
          return true;
        } else {
          return false;
        }
      },
    );
  }

  resetSelectedOption() {
    emit(
      state.copyWith(
        selectedOption: '',
        resetSelected: true,
      ),
    );
  }
}
