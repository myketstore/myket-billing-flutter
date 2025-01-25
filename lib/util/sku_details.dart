class SkuDetails {
  late String mItemType;
  late String mSku;
  late String mType;
  late String mPrice;
  late String mTitle;
  String? mDescription;
  late String mJson;

  SkuDetails();

  factory SkuDetails.fromJson(dynamic json) => SkuDetails()
    ..mItemType = json['mItemType']
    ..mSku = json['mSku']
    ..mType = json['mType']
    ..mPrice = json['mPrice']
    ..mTitle = json['mTitle']
    ..mDescription = json['mDescription']
    ..mJson = json['mJson'];

  Map<String, dynamic> toJson() => {
        'mItemType': mItemType,
        'mSku': mSku,
        'mType': mType,
        'mPrice': mPrice,
        'mTitle': mTitle,
        'mDescription': mDescription,
        'mJson': mJson,
      };
}
