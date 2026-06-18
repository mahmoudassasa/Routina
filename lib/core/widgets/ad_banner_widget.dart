import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:routina/features/billing_service/logic/cubit/billing_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  bool _hasCheckedPremium = false;
  static String get _bannerId => dotenv.get('ADMOB_BANNER_ID');

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
    return BlocBuilder<BillingCubit, BillingState>(
      builder: (context, state) {
        if (state.status == BillingStatus.loading) {
          return const SizedBox.shrink();
        }

        if (!state.isPremium && !_hasCheckedPremium) {
          _hasCheckedPremium = true;
          _loadBanner();
        }

        if (state.isPremium) {
          return const SizedBox.shrink();
        }

        if (!_isBannerLoaded) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        );
      },
    );
  }
}
