import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/models.dart';
import '../../../utils/utils.dart';

part 'intro_state.dart';

class IntroBloc extends Cubit<IntroState> {
  IntroBloc() : super(const IntroState()) {
    init();
  }

  final PageController _pageController = PageController(initialPage: 0);
  PageController get controller => _pageController;

  Timer? _t;

  init() {
    final introModelList = [
      const IntroModel(
        image: ImageAssets.kDummy,
        title: 'Loren Ipsum Sit Amet',
        description: '1. Lorem ipsum dolor sit amet, consectetur elit sit amet',
      ),
      const IntroModel(
        image: ImageAssets.kDummy,
        title: 'Loren Ipsum Sit Amet',
        description: '2. Lorem ipsum dolor sit amet, consectetur elit sit amet',
      ),
      const IntroModel(
        image: ImageAssets.kDummy,
        title: 'Loren Ipsum Sit Amet',
        description: '3. Lorem ipsum dolor sit amet, consectetur elit sit amet',
      ),
      const IntroModel(
        image: ImageAssets.kDummy,
        title: 'Loren Ipsum Sit Amet',
        description: '4. Lorem ipsum dolor sit amet, consectetur elit sit amet',
      ),
    ];
    emit(
      state.copyWith(
        introModelList: introModelList,
      ),
    );

    autoPlay();
  }

  void next() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );

    emit(
      state.copyWith(
        index: state.index + 1,
      ),
    );

    _t?.cancel();
    autoPlay();
  }

  skip() {
    _pageController.animateToPage(
      state.introModelList.length - 1,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );
    emit(
      state.copyWith(
        index: state.introModelList.length - 1,
      ),
    );
    _t?.cancel();
  }

  finish() {
    emit(
      state.copyWith(viewStatus: ViewStatusModel.submitting),
    );
    SettingModel(key: 'first_time', value: '0').save().then(
      (result) {
        if (result.isSuccess) {
          emit(
            state.copyWith(viewStatus: ViewStatusModel.success),
          );
        } else {
          emit(
            state.copyWith(viewStatus: ViewStatusModel.failure),
          );
        }
      },
    );
  }

  resetViewStatus() {
    emit(
      state.copyWith(viewStatus: ViewStatusModel.idle),
    );
  }

  autoPlay() async {
    _t = Timer(
      const Duration(seconds: 3),
      () {
        if (state.index < state.introModelList.length - 1) {
          next();
          autoPlay();
        }
      },
    );
  }
}
