
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdInterstitialService {
  InterstitialAd? _interstitialAd;

  // TODO: Change to real ID before release
  // static const String _interstitialId = 'ca-app-pub-6709912096960398/5533758236';
  static const String _interstitialId =
      'ca-app-pub-3940256099942544/1033173712';

  static const int _openCountThreshold = 3;

  void load() {
    InterstitialAd.load(
      adUnitId: _interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void show() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      load();
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  Future<void> handleAppOpenCount(BuildContext context) async {
    final isPremium = context.read<BillingCubit>().state.isPremium;
    if (isPremium) return;

    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('app_open_count') ?? 0;
    count++;
    await prefs.setInt('app_open_count', count);

    if (count % _openCountThreshold == 0) {
      await Future.delayed(const Duration(seconds: 2));
      show();
    }
  }
}