part of 'user_selected_bloc.dart';

class UserSelectedState extends Equatable {
  final ViewStatusModel viewStatus;
  final List<UserModel> userList;
  final int total;
  final int page;
  final int limit;
  final String selectedOption;
  final UserModel? selectedUser;
  final bool resetSelected;

   const UserSelectedState({
    this.viewStatus = ViewStatusModel.loading,
    this.userList = const <UserModel>[],
    this.total = 0,
    this.page = 1,
    this.limit = 10,
    this.selectedOption = '',
    this.selectedUser,
    this.resetSelected = false,
  });

  UserSelectedState copyWith({
    ViewStatusModel? viewStatus,
    List<UserModel>? userList,
    int? total,
    int? page,
    int? limit,
    String? selectedOption,
    UserModel? selectedUser,
    bool? resetSelected,
  }) {
    return UserSelectedState(
      viewStatus: viewStatus ?? this.viewStatus,
      userList: userList ?? this.userList,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      selectedOption: selectedOption ?? this.selectedOption,
      selectedUser: resetSelected != null ? resetSelected ? null : selectedUser ?? this.selectedUser : selectedUser ?? this.selectedUser,
      resetSelected: resetSelected ?? this.resetSelected,
    );
  }

  @override
  List<Object?> get props => [
        viewStatus,
        userList,
        total,
        page,
        limit,
        selectedOption,
        selectedUser,
        resetSelected
      ];
}
