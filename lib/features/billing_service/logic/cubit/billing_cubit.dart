import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:routina/features/billing_service/ui/billing_service.dart';

part 'billing_state.dart';

class BillingCubit extends Cubit<BillingState> {
  final BillingService _service;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  BillingCubit({BillingService? service})
    : _service = service ?? BillingService(),
      super(const BillingState()) {
    _listenToPurchases();
  }

  // ─── Init ─────────────────────────────────────────────────────────────────

  Future<void> init() async {
    emit(state.copyWith(status: BillingStatus.loading));
    try {
      final available = await _service.isAvailable();
      if (!available) {
        emit(
          state.copyWith(
            status: BillingStatus.error,
            errorMessage: 'Google Play not available',
          ),
        );
        return;
      }
      final result = await _service.fetchPremiumStatus();
      emit(
        state.copyWith(
          status: result.isPremium
              ? BillingStatus.active
              : BillingStatus.expired,
          isPremium: result.isPremium,
          premiumUntil: result.until,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: BillingStatus.error, errorMessage: e.toString()),
      );
    }
  }

  // ─── Purchase ─────────────────────────────────────────────────────────────

  Future<void> subscribe(ProductDetails product) async {
    emit(state.copyWith(status: BillingStatus.loading));
    try {
      await _service.buySubscription(product);
    } catch (e) {
      emit(
        state.copyWith(status: BillingStatus.error, errorMessage: e.toString()),
      );
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
    emit(
      state.copyWith(
        isRestoring: false,
        status: BillingStatus.error,
        errorMessage: e.toString(),
      ),
    );
  }
}

  // ─── Stream listener ──────────────────────────────────────────────────────

  void _listenToPurchases() {
    _sub = _service.purchaseStream.listen(
      (purchases) async {
        for (final purchase in purchases) {
          final success = await _service.verifyAndComplete(purchase);
          if (success) {
            final result = await _service.fetchPremiumStatus();
            emit(
              state.copyWith(
                status: BillingStatus.active,
                isPremium: true,
                premiumUntil: result.until,
                isRestoring: false,
              ),
            );
          } else if (purchase.status == PurchaseStatus.error) {
            emit(
              state.copyWith(
                status: BillingStatus.error,
                errorMessage: purchase.error?.message ?? 'Purchase failed',
                isRestoring: false,
              ),
            );
          }
        }
      },
      onError: (e) => emit(
        state.copyWith(
          status: BillingStatus.error,
          errorMessage: e.toString(),
          isRestoring: false,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _service.dispose();
    return super.close();
  }
}
