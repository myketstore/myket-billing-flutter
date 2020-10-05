class Purchase {
  String mItemType;
  String mOrderId;
  String mPackageName;
  String mSku;
  int mPurchaseTime;
  int mPurchaseState;
  String mDeveloperPayload;
  String mToken;
  String mOriginalJson;
  String mSignature;
  bool mIsAutoRenewing;

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
    ..mSignature = json['mSignature']
    ..mIsAutoRenewing = json['mIsAutoRenewing'];

  Map<String, dynamic> toJson() => {
    'mItemType':mItemType,
    'mOrderId':mOrderId,
    'mPackageName':mPackageName,
    'mSku':mSku,
    'mPurchaseTime':mPurchaseTime,
    'mPurchaseState':mPurchaseState,
    'mDeveloperPayload':mDeveloperPayload,
    'mToken':mToken,
    'mOriginalJson':mOriginalJson,
    'mSignature':mSignature,
    'mIsAutoRenewing':mIsAutoRenewing,
  };

  Purchase();

  @override
  String toString() {
    return 'Purchase{mItemType: $mItemType, mOrderId: $mOrderId, mPackageName: $mPackageName, mSku: $mSku, mPurchaseTime: $mPurchaseTime, mPurchaseState: $mPurchaseState, mDeveloperPayload: $mDeveloperPayload, mToken: $mToken, mOriginalJson: $mOriginalJson, mSignature: $mSignature, mIsAutoRenewing: $mIsAutoRenewing}';
  }
}
