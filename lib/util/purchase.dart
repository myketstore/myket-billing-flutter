class Purchase {
  late String mItemType;
  late String mOrderId;
  late String mPackageName;
  late String mSku;
  late int mPurchaseTime;
  late int mPurchaseState;
  String? mDeveloperPayload;
  late String mToken;
  late String mOriginalJson;
  late String mSignature;

  factory Purchase.fromJson(dynamic json) => Purchase()
    ..mItemType = json['mItemType']
    ..mOrderId = json['mOrderId']
    ..mPackageName = json['mPackageName']
    ..mSku = json['mSku']
    ..mPurchaseTime = json['mPurchaseTime']
    ..mPurchaseState = json['mPurchaseState']
    ..mDeveloperPayload = json['mDeveloperPayload']
    ..mToken = json['mToken']
    ..mOriginalJson = json['mOriginalJson']
    ..mSignature = json['mSignature'];

  Map<String, dynamic> toJson() => {
        'mItemType': mItemType,
        'mOrderId': mOrderId,
        'mPackageName': mPackageName,
        'mSku': mSku,
        'mPurchaseTime': mPurchaseTime,
        'mPurchaseState': mPurchaseState,
        'mDeveloperPayload': mDeveloperPayload,
        'mToken': mToken,
        'mOriginalJson': mOriginalJson,
        'mSignature': mSignature,
      };

  Purchase();

  @override
  String toString() {
    return 'Purchase{mItemType: $mItemType, mOrderId: $mOrderId, mPackageName: $mPackageName, mSku: $mSku, mPurchaseTime: $mPurchaseTime, mPurchaseState: $mPurchaseState, mDeveloperPayload: $mDeveloperPayload, mToken: $mToken, mOriginalJson: $mOriginalJson, mSignature: $mSignature}';
  }
}
