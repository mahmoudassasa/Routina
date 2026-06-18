import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BillingService {
  static const String monthlyId = 'routina_premium_monthly';
  static const String yearlyId = 'routina_premium_yearly';
  static const Set<String> _productIds = {monthlyId, yearlyId};

  final InAppPurchase _iap = InAppPurchase.instance;
  final SupabaseClient _supabase = Supabase.instance.client;
  
  String? _firebaseUserId;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

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

  Future<bool> verifyAndComplete(PurchaseDetails details) async {
    if (details.status == PurchaseStatus.purchased ||
        details.status == PurchaseStatus.restored) {
      if (details.pendingCompletePurchase) {
        await _iap.completePurchase(details);
      }
      await _syncPremiumToSupabase(details);
      return true;
    }
    if (details.pendingCompletePurchase) {
      await _iap.completePurchase(details);
    }
    return false;
  }

  Future<void> _syncPremiumToSupabase(PurchaseDetails details) async {
    final userId = _firebaseUserId;
    if (userId == null) return;

    final until = _calcExpiry(details.productID);
    
    try {
      await _supabase
          .from('user_premium')
          .upsert({
            'user_id': userId,
            'is_premium': true,
            'premium_until': until.toIso8601String(),
          }, onConflict: 'user_id');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearPremiumInSupabase() async {
    final userId = _firebaseUserId;
    if (userId == null) return;
    
    await _supabase
        .from('user_premium')
        .update({'is_premium': false, 'premium_until': null})
        .eq('user_id', userId);
  }

  Future<({bool isPremium, DateTime? until})> fetchPremiumStatus() async {
    final userId = _firebaseUserId;
    if (userId == null) {
      return (isPremium: false, until: null);
    }

    final row = await _supabase
        .from('user_premium')
        .select('is_premium, premium_until')
        .eq('user_id', userId)
        .maybeSingle();

    if (row == null) {
      return (isPremium: false, until: null);
    }

    final isPremium = row['is_premium'] as bool? ?? false;
    final untilStr = row['premium_until'] as String?;
    final until = untilStr != null ? DateTime.tryParse(untilStr) : null;

    if (isPremium && until != null && until.isBefore(DateTime.now())) {
      await clearPremiumInSupabase();
      return (isPremium: false, until: null);
    }
    
    return (isPremium: isPremium, until: until);
  }

  DateTime _calcExpiry(String productId) {
    final now = DateTime.now();
    return productId == monthlyId
        ? now.add(const Duration(days: 31))
        : now.add(const Duration(days: 365));
  }

  void dispose() {
    _purchaseSubscription?.cancel();
  }
}