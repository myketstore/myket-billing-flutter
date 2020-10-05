class SkuDetails {
  String mItemType;
  String mSku;
  String mType;
  String mPrice;
  int mPriceAmountMicros;
  String mPriceCurrencyCode;
  String mTitle;
  String mDescription;
  String mJson;

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
