// lib/features/billing_service/logic/cubit/billing_cubit.dart
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routina/core/services/premium_service.dart';
import 'package:routina/features/billing_service/ui/billing_service.dart';

part 'billing_state.dart';

class BillingCubit extends Cubit<BillingState> {
  final BillingService _service;
  final PremiumService _premiumService = PremiumService();
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  BillingCubit({BillingService? service})
      : _service = service ?? BillingService(),
        super(const BillingState()) {
    _listenToPurchases();
    init();
  }

  Future<void> init() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _service.setFirebaseUserId(user.uid);
      await _refreshPremiumStatus();
    } else {
      emit(state.copyWith(
        status: BillingStatus.expired,
        isPremium: false,
        premiumUntil: null,
      ));
    }
  }

  Future<void> _refreshPremiumStatus() async {
    if (isClosed) return;
    emit(state.copyWith(status: BillingStatus.loading));
    try {
      final data = await _premiumService.fetchPremiumStatus();
      final isPremium = data['is_premium'] as bool? ?? false;
      final untilStr = data['premium_until'] as String?;
      final expiresAt = untilStr != null ? DateTime.tryParse(untilStr) : null;

      if (isClosed) return;
      emit(state.copyWith(
        status: isPremium ? BillingStatus.active : BillingStatus.expired,
        isPremium: isPremium,
        premiumUntil: expiresAt,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: BillingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> subscribe(ProductDetails product) async {
    emit(state.copyWith(status: BillingStatus.loading));
    try {
      await _service.buySubscription(product);
    } catch (e) {
      emit(state.copyWith(
        status: BillingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> restore() async {
    emit(state.copyWith(isRestoring: true));
    try {
      await _service.restorePurchases();
      await Future.delayed(const Duration(seconds: 5));
      if (state.isRestoring) {
        emit(state.copyWith(isRestoring: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isRestoring: false,
        status: BillingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _listenToPurchases() {
    _purchaseSub = _service.purchaseStream.listen(
      (purchases) async {
        for (final purchase in purchases) {
          final success = await _service.verifyAndComplete(purchase);
          if (success) {
            await _refreshPremiumStatus();
            emit(state.copyWith(isRestoring: false));
          } else if (purchase.status == PurchaseStatus.error) {
            emit(state.copyWith(
              status: BillingStatus.error,
              errorMessage: purchase.error?.message ?? 'Purchase failed',
              isRestoring: false,
            ));
          }
        }
      },
      onError: (e) {
        emit(state.copyWith(
          status: BillingStatus.error,
          errorMessage: e.toString(),
          isRestoring: false,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _purchaseSub?.cancel();
    _service.dispose();
    return super.close();
  }
}