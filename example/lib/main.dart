import 'package:flutter/material.dart';
import 'package:myket_iap/myket_iap.dart';
import 'package:myket_iap/util/iab_result.dart';
import 'package:myket_iap/util/inventory.dart';
import 'package:myket_iap/util/purchase.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const int TANK_MAX = 4;
  static const String SKU_GAS = "gas";
  static const String SKU_PREMIUM = "premium";

  bool _loading = true;
  int _tank = 0;
  bool _isPremium = false;

  @override
  void initState() {
    initIab();
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    MyketIAP.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Visibility(
            visible: !_loading,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/title.png",
                  width: 150,
                ),
                SizedBox(height: 8),
                Image.asset(
                  _isPremium ? "assets/premium.png" : "assets/free.png",
                  width: 150,
                ),
                SizedBox(height: 32),
                Image.asset(
                  getGasImage(),
                  width: 250,
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: drive,
                      child: Image.asset(
                        "assets/drive.png",
                        width: 150,
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: buyGas,
                      child: Image.asset(
                        "assets/buy_gas.png",
                        width: 150,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: upgrade,
                      child: Image.asset(
                        "assets/upgrade_app.png",
                        width: 150,
                      ),
                    ),
                  ],
                )
              ],
            )),
          ),
          Visibility(
            child: Center(
              child: Image.asset(
                "assets/wait.png",
                width: 200,
              ),
            ),
            visible: _loading,
          )
        ],
      ),
    );
  }

  initIab() async {
    var rsa =
        "MIGeMA0GCSqGSIb3DQEBAQUAA4GMADCBiAKBgOW5KR56WBWCb5K+yyVDnh/7op0FY4zmM93CWz3xFhgUJe2WXM/8MgpTHiDxrj2Mkgt9bg30qZDtT8gzDHiTgNv6G7pZBDWuyKEariGbbQgoCoeaq3GBcNsQf418jsvOfPjzZ7Rpcl/+9ZPsp1kbJVOmZxnwAZx/wnkUduwfuf8hAgMBAAE=";
    var iabResult = await MyketIAP.init(rsaKey: rsa, enableDebugLogging: true);
    if (iabResult?.isFailure() == true) {
      // Oh noes, there was a problem.
      complain("Problem setting up in-app billing: $iabResult");
      return;
    }

    try {
      // IAB is fully set up. Now, let's get an inventory of stuff we own.
      print("Setup successful. Querying inventory.");
      var queryInventoryMap =
          await MyketIAP.queryInventory(querySkuDetails: false);
      IabResult inventoryResult = queryInventoryMap[MyketIAP.RESULT];
      Inventory inventory = queryInventoryMap[MyketIAP.INVENTORY];
      print("Query inventory finished.");
      // Is it a failure?
      if (inventoryResult.isFailure()) {
        complain("Failed to query inventory: $inventoryResult");
        return;
      }
      print("Query inventory was successful.");
      /*
       * Check for items we own. Notice that for each purchase, we check
       * the developer payload to see if it's correct! See
       * verifyDeveloperPayload().
       */
      // Do we have the premium upgrade?
      Purchase premiumPurchase = inventory.mPurchaseMap[SKU_PREMIUM];
      setState(() => _isPremium =
          (premiumPurchase != null && verifyDeveloperPayload(premiumPurchase)));
      print("User is ${_isPremium ? "PREMIUM" : "NOT PREMIUM"}");

      // Check for gas delivery -- if we own gas, we should fill up the tank immediately
      Purchase gasPurchase = inventory.mPurchaseMap[SKU_GAS];
      if (gasPurchase != null && verifyDeveloperPayload(gasPurchase)) {
        print("We have gas. Consuming it.");
        await consumeGas(gasPurchase);
        setState(() => _loading = false);
      }
    } catch (e) {
      complain(
          "Error querying inventory. Another async operation in progress.");
    }

    setState(() => _loading = false);
  }

  String getGasImage() {
    switch (_tank) {
      case 1:
        return "assets/gas1.png";
      case 2:
        return "assets/gas2.png";
      case 3:
        return "assets/gas3.png";
      case 4:
        return "assets/gas4.png";
      case 0:
      default:
        return "assets/gas0.png";
    }
  }

  complain(String message) {
    alert("Error: $message");
  }

  alert(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(message),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OK"))
              ],
            ));
  }

  /// User clicked the "Upgrade to Premium" button.
  upgrade() async {
    print("Upgrade button clicked; launching purchase flow for upgrade.");
    setState(() => _loading = true);

    /* TODO: for security, generate your payload here for verification. See the comments on
     *        verifyDeveloperPayload() for more info. Since this is a SAMPLE, we just use
     *        an empty string, but on a production app you should carefully generate this. */
    String payload = "";

    try {
      var purchaseResultMap =
          await MyketIAP.launchPurchaseFlow(sku: SKU_PREMIUM, payload: payload);
      IabResult purchaseResult = purchaseResultMap[MyketIAP.RESULT];
      Purchase purchase = purchaseResultMap[MyketIAP.PURCHASE];
      if (purchaseResult.isFailure()) {
        complain("Error purchasing: $purchaseResult");
        setState(() => _loading = false);
        return;
      }

      if (!verifyDeveloperPayload(purchase)) {
        complain("Error purchasing. Authenticity verification failed.");
        setState(() => _loading = false);
        return;
      }

      print("Purchase successful.");
      // bought the premium upgrade!
      print("Purchase is premium upgrade. Congratulating user.");
      alert("Thank you for upgrading to premium!");
      setState(() {
        _isPremium = true;
        _loading = false;
      });
      saveData();
    } catch (e) {
      complain(
          "Error launching purchase flow. Another async operation in progress.");
      setState(() => _loading = false);
    }
  }

  /// User clicked the "Buy Gas" button
  buyGas() async {
    if (_tank >= TANK_MAX) {
      complain("Your tank is full. Drive around a bit!");
      return;
    }

    // launch the gas purchase UI flow.
    setState(() => _loading = true);
    print("Launching purchase flow for gas.");

    /* TODO: for security, generate your payload here for verification. See the comments on
     *        verifyDeveloperPayload() for more info. Since this is a SAMPLE, we just use
     *        an empty string, but on a production app you should carefully generate this. */
    String payload = "";

    try {
      var purchaseResultMap =
          await MyketIAP.launchPurchaseFlow(sku: SKU_GAS, payload: payload);
      IabResult purchaseResult = purchaseResultMap[MyketIAP.RESULT];
      Purchase purchase = purchaseResultMap[MyketIAP.PURCHASE];
      if (purchaseResult.isFailure()) {
        complain("Error purchasing: $purchaseResult");
        setState(() => _loading = false);
        return;
      }

      if (!verifyDeveloperPayload(purchase)) {
        complain("Error purchasing. Authenticity verification failed.");
        setState(() => _loading = false);
        return;
      }

      print("Purchase successful.");

      // bought 1/4 tank of gas. So consume it.
      print("Purchase is gas. Starting gas consumption.");
      await consumeGas(purchase);
      setState(() => _loading = false);
    } catch (e) {
      complain(
          "Error launching purchase flow. Another async operation in progress.");
      setState(() => _loading = false);
    }
  }

  Future consumeGas(Purchase purchase) async {
    try {
      var consumeResultMap = await MyketIAP.consume(purchase: purchase);
      IabResult consumeResult = consumeResultMap[MyketIAP.RESULT];
      Purchase consumePurchase = consumeResultMap[MyketIAP.PURCHASE];
      print(
          "Consumption finished. Purchase: $consumePurchase, result: $consumeResult");

      // We know this is the "gas" sku because it's the only one we consume,
      // so we don't check which sku was consumed. If you have more than one
      // sku, you probably should check...
      if (consumeResult.isSuccess()) {
        // successfully consumed, so we apply the effects of the item in our
        // game world's logic, which in our case means filling the gas tank a bit
        print("Consumption successful. Provisioning.");
        setState(() => _tank = _tank == TANK_MAX ? TANK_MAX : _tank + 1);
        saveData();
        alert("You filled 1/4 tank. Your tank is now  $_tank/4 full!");
      } else {
        complain("Error while consuming: $consumeResult");
      }
      print("End consumption flow.");
    } catch (e) {
      complain("Error consuming gas. Another async operation in progress.");
      setState(() => _loading = false);
    }
  }

  /// Drive button clicked. Burn gas!
  drive() {
    if (_tank <= 0) {
      print("tank ");
      alert("Oh, no! You are out of gas! Try buying some!");
    } else {
      setState(() => --_tank);
      saveData();
      alert("Vroooom, you drove a few miles.");
      print("Vrooom. Tank is now $_tank");
    }
  }

  saveData() async {
    /*
     * WARNING: on a real application, we recommend you save data in a secure way to
     * prevent tampering.
     */
    print("Saved data: tank = $_tank");
    print("Saved data: premium = $_isPremium");
  }

  loadData() async {
    /*
     * WARNING: on a real application, we recommend you load data in a secure way to
     * prevent tampering.
     */
  }

  /// Verifies the developer payload of a purchase.
  bool verifyDeveloperPayload(Purchase p) {
    String payload = p.mDeveloperPayload;

    /*
     * TODO: verify that the developer payload of the purchase is correct. It will be
     * the same one that you sent when initiating the purchase.
     *
     * WARNING: Locally generating a random string when starting a purchase and
     * verifying it here might seem like a good approach, but this will fail in the
     * case where the user purchases an item on one device and then uses your app on
     * a different device, because on the other device you will not have access to the
     * random string you originally generated.
     *
     * So a good developer payload has these characteristics:
     *
     * 1. If two different users purchase an item, the payload is different between them,
     *    so that one user's purchase can't be replayed to another user.
     *
     * 2. The payload must be such that you can verify it even when the app wasn't the
     *    one who initiated the purchase flow (so that items purchased by the user on
     *    one device work on other devices owned by the user).
     *
     * Using your own server to store and verify developer payloads across app
     * installations is recommended.
     */

    return true;
  }
}
