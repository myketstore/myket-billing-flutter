import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';
import 'package:myket_iap/util/iab_result.dart';
import 'package:myket_iap/util/inventory.dart';
import 'package:myket_iap/util/purchase.dart';

class MyketIAP {
  static const String PURCHASE = "purchase";
  static const String INVENTORY = "inventory";
  static const String RESULT = "result";
  static const MethodChannel _channel = const MethodChannel('myket');

  static Future<IabResult?> init(
      {required String rsaKey, bool enableDebugLogging = false}) async {
    var iabResult = await _channel.invokeMethod("init", <String, dynamic>{
      'rsa': rsaKey,
      'enableDebugLogging': enableDebugLogging,
    });
    var iabResultJson = iabResult != null ? json.decode(iabResult) : null;
    return iabResultJson != null ? IabResult.fromJson(iabResultJson) : null;
  }

  static Future<Map> launchPurchaseFlow(
      {required String sku, String? payload}) async {
    var map =
        await _channel.invokeMethod("launchPurchaseFlow", <String, dynamic>{
      'sku': sku,
      'payload': payload,
    });
    var purchaseJson = json.decode(map["purchase"]);
    var resultJson = json.decode(map["result"]);
    return {
      RESULT: resultJson != null ? IabResult.fromJson(resultJson) : null,
      PURCHASE: purchaseJson != null ? Purchase.fromJson(purchaseJson) : null,
    };
  }

  static Future<Map> consume({required Purchase purchase}) async {
    var map = await _channel.invokeMethod("consume", <String, dynamic>{
      'purchase': json.encode(purchase.toJson()),
    });
    var purchaseJson = json.decode(map["purchase"]);
    var resultJson = json.decode(map["result"]);
    return {
      RESULT: resultJson != null ? IabResult.fromJson(resultJson) : null,
      PURCHASE: purchaseJson != null ? Purchase.fromJson(purchaseJson) : null,
    };
  }

  static Future<Map> getPurchase(
      {required String sku, bool querySkuDetails = false}) async {
    var map = await _channel.invokeMethod("getPurchase", <String, dynamic>{
      'sku': sku,
      'querySkuDetails': querySkuDetails,
    });
    var purchaseJson = json.decode(map["purchase"]);
    var resultJson = json.decode(map["result"]);
    return {
      RESULT: resultJson != null ? IabResult.fromJson(resultJson) : null,
      PURCHASE: purchaseJson != null ? Purchase.fromJson(purchaseJson) : null,
    };
  }

  static Future dispose() async {
    return await _channel.invokeMethod("dispose");
  }

  static Future<Map> queryInventory(
      {bool querySkuDetails = false, List<String>? skus}) async {
    var map = await _channel.invokeMethod("queryInventory",
        <String, dynamic>{'querySkuDetails': querySkuDetails, 'skus': skus});
    var purchaseJson = json.decode(map["inventory"]);
    var resultJson = json.decode(map["result"]);
    return {
      RESULT: resultJson != null ? IabResult.fromJson(resultJson) : null,
      INVENTORY: purchaseJson != null ? Inventory.fromJson(purchaseJson) : null,
    };
  }
}
