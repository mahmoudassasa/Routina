import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:routina/core/services/premium_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerifyPurchaseResult {
  final bool success;
  final String? errorMessage;

  const VerifyPurchaseResult({required this.success, this.errorMessage});
}

class BillingService {
  static const String monthlyId = 'routina_premium_monthly';
  static const String yearlyId = 'routina_premium_yearly';
  static const Set<String> _productIds = {monthlyId, yearlyId};

  final InAppPurchase _iap = InAppPurchase.instance;
  final SupabaseClient _supabase = Supabase.instance.client;
  final PremiumService _premiumService = PremiumService();

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

  Future<VerifyPurchaseResult> verifyAndComplete(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.pending) {
      return const VerifyPurchaseResult(success: false, errorMessage: null);
    }

    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      try {
        final token = purchase.verificationData.serverVerificationData;
        final productId = purchase.productID;

        final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

        final response = await _supabase.functions.invoke(
          'verify-purchase',
          headers: {
            if (idToken != null) 'Authorization': 'Bearer $idToken',
          },
          body: {
            'purchaseToken': token,
            'productId': productId,
          },
        );


        final rawData = response.data;
        final Map<String, dynamic> data = rawData is String
            ? jsonDecode(rawData)
            : Map<String, dynamic>.from(rawData as Map);

        if (response.status == 200 && data['success'] == true) {
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          
          await fetchPremiumStatus();

          return const VerifyPurchaseResult(success: true);
        }

        final serverError = data['error']?.toString();

        return VerifyPurchaseResult(
          success: false,
          errorMessage: serverError ?? 'Verification failed (${response.status})',
        );
      } on FunctionException catch (e) {
        String? errorMsg;
        if (e.details is Map && e.details['error'] != null) {
          errorMsg = e.details['error'].toString();
        } else if (e.details is String) {
          try {
            final parsed = jsonDecode(e.details as String);
            if (parsed is Map && parsed['error'] != null) {
              errorMsg = parsed['error'].toString();
            }
          } catch (_) {}
        }
        return VerifyPurchaseResult(
          success: false,
          errorMessage: errorMsg ?? e.reasonPhrase ?? 'Verification failed',
        );
      // ignore: unused_catch_stack
      } catch (e, stackTrace) {
        return VerifyPurchaseResult(success: false, errorMessage: e.toString());
      }
    }

    if (purchase.status == PurchaseStatus.error ||
        purchase.status == PurchaseStatus.canceled) {
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }

    return const VerifyPurchaseResult(success: false, errorMessage: null);
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

  void dispose() {}
}

class PremiumStatusResult {
  final bool isPremium;
  final DateTime? until;

  PremiumStatusResult({required this.isPremium, this.until});
}