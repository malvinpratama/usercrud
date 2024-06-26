import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../models/models.dart';
import '../../../../../repositories/repositories.dart';
part 'user_selected_state.dart';

class UserSelectedBloc extends Cubit<UserSelectedState> {
  UserSelectedBloc(UsersRepository usersRepository)
      : _usersRepository = usersRepository,
        super(const UserSelectedState()) {
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
    scrollController.addListener(
      () {
        if (scrollController.position.extentAfter == 0) {
          loadMore(false);
        }
      },
    );
  }

  loadMore(bool init) {
    if (state.total == state.userList.length && !init) {
      return;
    }

    _usersRepository.getSelectedUserList(state.page, state.limit).then(
      (userList) {
        final user = [...state.userList];
        user.addAll(userList);
        
       _usersRepository.countSelectedUser().then((count) {
        final totalPages = (count / state.limit).ceil();
          emit(
          state.copyWith(
            userList: user,
            total: count,
            viewStatus: ViewStatusModel.idle,
            page: state.page != totalPages
                ? state.page + 1
                : totalPages,
          ),
        );
       },);
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
        userList: [],
        page: 1,
      ),
    );
    loadMore(true);
  }
}
