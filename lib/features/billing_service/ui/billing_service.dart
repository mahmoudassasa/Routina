// lib/features/billing_service/ui/billing_service.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:routina/core/services/premium_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BillingService {
  static const String monthlyId = 'routina_premium_monthly';
  static const String yearlyId = 'routina_premium_yearly';
  static const Set<String> _productIds = {monthlyId, yearlyId};

  final InAppPurchase _iap = InAppPurchase.instance;
  final SupabaseClient _supabase = Supabase.instance.client;
  final PremiumService _premiumService = PremiumService();

  String? _firebaseUserId;

  void setFirebaseUserId(String? uid) {
    _firebaseUserId = uid;
  }

  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  Future<bool> isAvailable() => _iap.isAvailable();

  Future<List<ProductDetails>> fetchProducts() async {
    final response = await _iap.queryProductDetails(_productIds);
    return response.productDetails;
  }

  Future<void> buySubscription(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() => _iap.restorePurchases();

  Future<bool> verifyAndComplete(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.pending) {
      return false;
    }

    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      try {
        final token = purchase.verificationData.serverVerificationData;
        final productId = purchase.productID;

        final response = await _supabase.functions.invoke(
          'verify-purchase',
          body: {
            'purchaseToken': token,
            'subscriptionId': productId,
            'userId': _firebaseUserId ?? FirebaseAuth.instance.currentUser?.uid,
          },
        );

        if (response.status == 200 && response.data['success'] == true) {
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          return true;
        }
        return false;
      } catch (e) {
        return false;
      }
    }

    if (purchase.status == PurchaseStatus.error ||
        purchase.status == PurchaseStatus.canceled) {
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }

    return false;
  }
  Future<PremiumStatusResult> fetchPremiumStatus() async {
    try {
      final data = await _premiumService.fetchPremiumStatus();
      final isPremium = data['is_premium'] as bool? ?? false;
      final untilStr = data['premium_until'] as String?;
      final expiresAt = untilStr != null ? DateTime.tryParse(untilStr) : null;

      return PremiumStatusResult(
        isPremium: isPremium,
        until: expiresAt,
      );
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    // Safe placeholder
  }
}

class PremiumStatusResult {
  final bool isPremium;
  final DateTime? until;

  PremiumStatusResult({required this.isPremium, this.until});
}