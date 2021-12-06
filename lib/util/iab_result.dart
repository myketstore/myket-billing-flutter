import 'package:myket_iap/util/constants.dart';

class IabResult {
  late int mResponse;
  late String mMessage;

  IabResult();

  factory IabResult.fromJson(dynamic json) => IabResult()
    ..mMessage = json['mMessage']
    ..mResponse = json['mResponse'];

  Map<String, dynamic> toJson() => {
        "mMessage": mMessage,
        "mResponse": mResponse,
      };

  @override
  String toString() {
    return 'IabResult{mResponse: $mResponse, mMessage: $mMessage}';
  }

  bool isSuccess() => mResponse == Constants.BILLING_RESPONSE_RESULT_OK;

  bool isFailure() => !isSuccess();
}
