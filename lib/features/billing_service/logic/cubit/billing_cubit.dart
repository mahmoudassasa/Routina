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
      await _refreshPremiumStatus();
    } else {
      if (isClosed) return;
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
    if (isClosed) return;
    emit(state.copyWith(status: BillingStatus.loading));
    try {
      await _service.buySubscription(product);
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: BillingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> restore() async {
    if (isClosed) return;
    emit(state.copyWith(isRestoring: true));
    try {
      await _service.restorePurchases();
      await Future.delayed(const Duration(seconds: 5));
      if (isClosed) return;
      if (state.isRestoring) {
        emit(state.copyWith(isRestoring: false));
      }
    } catch (e) {
      if (isClosed) return;
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
          if (isClosed) return;

          final result = await _service.verifyAndComplete(purchase);

          if (isClosed) return;

          if (result.success) {
            await _refreshPremiumStatus();
            if (isClosed) return;
            emit(state.copyWith(isRestoring: false));
          } else if (purchase.status == PurchaseStatus.pending) {
            // Still waiting on Google's side — leave status as-is,
            // a later stream event will resolve this purchase.
            continue;
          } else {
            // Purchase completed on Google's side but our server
            // verification failed, or Google itself reported an error.
            // Either way the UI must not stay stuck on loading.
            emit(state.copyWith(
              status: BillingStatus.error,
              errorMessage: result.errorMessage ??
                  purchase.error?.message ??
                  'Purchase verification failed',
              isRestoring: false,
            ));
          }
        }
      },
      onError: (e) {
        if (isClosed) return;
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