import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdInterstitialService {
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;

  static String get _interstitialId => dotenv.get('ADMOB_INTERSTITIAL_ID');
  static const int _openCountThreshold = 3;

  void load() {
    if (_interstitialAd != null || _isLoading) return;
    _isLoading = true;

    InterstitialAd.load(
      adUnitId: _interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isLoading = false;
        },
      ),
    );
  }

  void show() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      load(); 
    } else {
      load(); 
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  Future<void> handleAppOpenCount(BuildContext context) async {
    final state = context.read<BillingCubit>().state;

    if (state.status == BillingStatus.loading || state.isPremium) return;

    if (_interstitialAd == null) load();

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