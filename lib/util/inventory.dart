import 'package:myket_iap/util/purchase.dart';
import 'package:myket_iap/util/sku_details.dart';

class Inventory {
  Map<String, Purchase> mPurchaseMap = Map();
  Map<String, SkuDetails> mSkuMap = Map();

  Inventory();

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory()
    ..mPurchaseMap = Map<String, Purchase>.fromIterable(
        json["mPurchaseMap"].entries,
        key: (i) => i.key,
        value: (i) => Purchase.fromJson(i.value))
    ..mSkuMap = Map<String, SkuDetails>.fromIterable(json["mSkuMap"].entries,
        key: (i) => i.key, value: (i) => SkuDetails.fromJson(i.value));

  Map<String, dynamic> toJson() => {
        'mPurchaseMap': mPurchaseMap,
        'mSkuMap': mSkuMap,
      };

  @override
  String toString() {
    return 'Inventory{mPurchaseMap: $mPurchaseMap, mSkuMap: $mSkuMap}';
  }
}
