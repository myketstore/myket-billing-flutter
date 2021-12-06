class SkuDetails {
  late String mItemType;
  late String mSku;
  late String mType;
  late String mPrice;
  late int mPriceAmountMicros;
  late String mPriceCurrencyCode;
  late String mTitle;
  String? mDescription;
  late String mJson;

  SkuDetails();

  factory SkuDetails.fromJson(dynamic json) => SkuDetails()
    ..mItemType = json['mItemType']
    ..mSku = json['mSku']
    ..mType = json['mType']
    ..mPrice = json['mPrice']
    ..mPriceAmountMicros = json['mPriceAmountMicros']
    ..mPriceCurrencyCode = json['mPriceCurrencyCode']
    ..mTitle = json['mTitle']
    ..mDescription = json['mDescription']
    ..mJson = json['mJson'];

  Map<String, dynamic> toJson() => {
        'mItemType': mItemType,
        'mSku': mSku,
        'mType': mType,
        'mPrice': mPrice,
        'mPriceAmountMicros': mPriceAmountMicros,
        'mPriceCurrencyCode': mPriceCurrencyCode,
        'mTitle': mTitle,
        'mDescription': mDescription,
        'mJson': mJson,
      };
}
