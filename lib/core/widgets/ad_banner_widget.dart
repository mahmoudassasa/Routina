// lib/core/widgets/ad_banner_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  // TODO: Change to real ID before release
  // static const String _bannerId = 'ca-app-pub-6709912096960398/6611566417';
  static const String _bannerId = 'ca-app-pub-3940256099942544/6300978111';

  @override
  void initState() {
    super.initState();
    final isPremium = context.read<BillingCubit>().state.isPremium;
    if (!isPremium) _loadBanner();
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: _bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _isBannerLoaded = true);
        },
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBannerLoaded) return const SizedBox.shrink();

    return SizedBox(
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}