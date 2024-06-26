import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';

part 'splashscreen_state.dart';

class SplashscreenBloc extends Cubit<SplashscreenState> {
  SplashscreenBloc(SettingsRepository settingsRepository)
      : _settingsRepository = settingsRepository,
        super(const SplashscreenState()) {
    init();
  }

  final SettingsRepository _settingsRepository;

  init() {
    checkFirstTime();
  }

  checkFirstTime() {
    _settingsRepository.getSettingByKey('first_time').then(
      (value) {
        Future.delayed(const Duration(seconds: 3)).then(
          (_) {
            if (value?.value == '1') {
              emit(
                state.copyWith(
                  viewStatus: ViewStatusModel.success,
                ),
              );
            } else {
              emit(
                state.copyWith(
                  viewStatus: ViewStatusModel.failure,
                ),
              );
            }
          },
        );
      },
    );
  }
}
