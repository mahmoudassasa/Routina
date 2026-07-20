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
  static String get _bannerId => dotenv.get('ADMOB_BANNER_ID');

  void _loadBanner() {
    if (_bannerAd != null || _isBannerLoaded) return;

    _bannerAd = BannerAd(
      adUnitId: _bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _isBannerLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
        },
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
    return BlocConsumer<BillingCubit, BillingState>(
      listenWhen: (previous, current) => previous.isPremium != current.isPremium,
      listener: (context, state) {
        if (!state.isPremium && state.status != BillingStatus.loading) {
          _loadBanner();
        }
      },
      builder: (context, state) {
        if (state.status == BillingStatus.loading || state.isPremium) {
          return const SizedBox.shrink();
        }

        if (!_isBannerLoaded && _bannerAd == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _loadBanner());
          return const SizedBox.shrink();
        }

        if (!_isBannerLoaded || _bannerAd == null) {
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