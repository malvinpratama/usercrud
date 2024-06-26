part of 'intro_bloc.dart';

class IntroState extends Equatable {
  final int index;
  final List<IntroModel> introModelList;
  final ViewStatusModel viewStatus;

  const IntroState({
    this.index = 0,
    this.introModelList = const <IntroModel>[],
    this.viewStatus = ViewStatusModel.idle,
  });

  IntroState copyWith({
    int? index,
    List<IntroModel>? introModelList,
    ViewStatusModel? viewStatus,
  }) {
    return IntroState(
      index: index ?? this.index,
      introModelList: introModelList ?? this.introModelList,
      viewStatus: viewStatus ?? this.viewStatus,
    );
  }

  @override
  List<Object?> get props => [
        index,
        introModelList,
        viewStatus,
      ];
}
