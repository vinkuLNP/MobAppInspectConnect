import 'dart:async';
import 'package:clean_architecture/core/basecomponents/base_view_model.dart';
import 'package:flutter/material.dart';

class OnBoardingProvider extends BaseViewModel {
  final PageController pageController = PageController(initialPage: 0);

  int _currentPage = 0;
  int get currentPage => _currentPage;

  Timer? _timer;

  void init() {
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (pageController.hasClients) {
        pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeIn,
        );
      }
      notifyListeners();
    });
  }

  void onPageChanged(int page) {
    if (page >= 0 && page <= 2) {
      _currentPage = page;
      notifyListeners();
    }
  }


  @override
  void onDispose() {
    _timer?.cancel();
    pageController.dispose();
    super.onDispose();
  }
}
