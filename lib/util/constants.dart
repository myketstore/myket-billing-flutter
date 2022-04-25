class Constants {
  // Billing response codes
  static const int BILLING_RESPONSE_RESULT_OK = 0;
  static const int BILLING_RESPONSE_RESULT_USER_CANCELED = 1;
  static const int BILLING_RESPONSE_RESULT_BILLING_UNAVAILABLE = 3;
  static const int BILLING_RESPONSE_RESULT_ITEM_UNAVAILABLE = 4;
  static const int BILLING_RESPONSE_RESULT_DEVELOPER_ERROR = 5;
  static const int BILLING_RESPONSE_RESULT_ERROR = 6;
  static const int BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED = 7;
  static const int BILLING_RESPONSE_RESULT_ITEM_NOT_OWNED = 8;

  // IAB Helper error codes
  static const int IABHELPER_ERROR_BASE = -1000;
  static const int IABHELPER_REMOTE_EXCEPTION = -1001;
  static const int IABHELPER_BAD_RESPONSE = -1002;
  static const int IABHELPER_VERIFICATION_FAILED = -1003;
  static const int IABHELPER_SEND_INTENT_FAILED = -1004;
  static const int IABHELPER_USER_CANCELLED = -1005;
  static const int IABHELPER_UNKNOWN_PURCHASE_RESPONSE = -1006;
  static const int IABHELPER_MISSING_TOKEN = -1007;
  static const int IABHELPER_UNKNOWN_ERROR = -1008;
  static const int IABHELPER_SUBSCRIPTIONS_NOT_AVAILABLE = -1009;
  static const int IABHELPER_INVALID_CONSUMPTION = -1010;

  // Keys for the responses from InAppBillingService
  static const String RESPONSE_CODE = "RESPONSE_CODE";
  static const String RESPONSE_GET_SKU_DETAILS_LIST = "DETAILS_LIST";
  static const String RESPONSE_BUY_INTENT = "BUY_INTENT";
  static const String RESPONSE_INAPP_PURCHASE_DATA = "INAPP_PURCHASE_DATA";
  static const String RESPONSE_INAPP_SIGNATURE = "INAPP_DATA_SIGNATURE";
  static const String RESPONSE_INAPP_ITEM_LIST = "INAPP_PURCHASE_ITEM_LIST";
  static const String RESPONSE_INAPP_PURCHASE_DATA_LIST =
      "INAPP_PURCHASE_DATA_LIST";
  static const String RESPONSE_INAPP_SIGNATURE_LIST =
      "INAPP_DATA_SIGNATURE_LIST";
  static const String INAPP_CONTINUATION_TOKEN = "INAPP_CONTINUATION_TOKEN";

  // Item types
  static const String ITEM_TYPE_INAPP = "inapp";
  static const String ITEM_TYPE_SUBS = "subs";

  // some fields on the getSkuDetails response bundle
  static const String GET_SKU_DETAILS_ITEM_LIST = "ITEM_ID_LIST";
  static const String GET_SKU_DETAILS_ITEM_TYPE_LIST = "ITEM_TYPE_LIST";
}
