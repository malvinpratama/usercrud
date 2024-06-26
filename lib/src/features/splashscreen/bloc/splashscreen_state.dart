part of 'splashscreen_bloc.dart';

class SplashscreenState extends Equatable {
  final ViewStatusModel viewStatus;

  const SplashscreenState({
    this.viewStatus = ViewStatusModel.loading,
  });

  SplashscreenState copyWith({
    ViewStatusModel? viewStatus,
  }) {
    return SplashscreenState(
      viewStatus: viewStatus ?? this.viewStatus,
    );
  }

  @override
  List<Object?> get props => [
        viewStatus,
      ];
}
