package ir.mservices.myketiap

import android.app.Activity
import android.content.Context
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import ir.myket.billingclient.IabHelper
import ir.myket.billingclient.util.IabResult
import ir.myket.billingclient.util.Inventory
import ir.myket.billingclient.util.Purchase


/** MyketPlugin */
class MyketPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null
    private val gson: Gson = Gson()
    private var mHelper: IabHelper? = null

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "myket")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> {
                val publicKey = call.argument<String>("rsa")
                val enableDebugLogging = call.argument<Boolean>("enableDebugLogging")
                mHelper = IabHelper(context, publicKey)
                mHelper?.enableDebugLogging(enableDebugLogging == true)
                mHelper?.startSetup {
                    result.success(gson.toJson(it, IabResult::class.java))
                }
            }
            "launchPurchaseFlow" -> {
                val sku = call.argument<String>("sku")
                val payload = call.argument<String>("payload")
                val onIabPurchaseFinishedListener = IabHelper.OnIabPurchaseFinishedListener { purchaseResult: IabResult, purchase: Purchase? ->
                    result.success(mapOf("result" to gson.toJson(purchaseResult, IabResult::class.java),
                            "purchase" to gson.toJson(purchase, Purchase::class.java)))
                }
                mHelper?.launchPurchaseFlow(activity, sku, onIabPurchaseFinishedListener, payload)
            }
            "consume" -> {
                val purchase = gson.fromJson(call.argument<String>("purchase"), Purchase::class.java)
                mHelper?.consumeAsync(purchase) { p: Purchase?, consumeResult: IabResult ->
                    result.success(mapOf("result" to gson.toJson(consumeResult, IabResult::class.java),
                            "purchase" to gson.toJson(p, Purchase::class.java)))
                }
            }
            "getPurchase" -> {
                val sku = call.argument<String>("sku")
                val querySkuDetails = call.argument<Boolean>("querySkuDetails")
                mHelper?.queryInventoryAsync(querySkuDetails == true, arrayListOf(sku))
                { iabResult: IabResult, inventory: Inventory? ->
                    val purchase = inventory?.getPurchase(sku)
                    result.success(mapOf("result" to gson.toJson(iabResult, IabResult::class.java),
                            "purchase" to gson.toJson(purchase, Purchase::class.java)))
                }
            }
            "queryInventory" -> {
                val querySkuDetails = call.argument<Boolean>("querySkuDetails")
                val skus = call.argument<List<String>>("skus")
                mHelper?.queryInventoryAsync(querySkuDetails == true, skus)
                { iabResult: IabResult, inventory: Inventory? ->
                    result.success(mapOf("result" to gson.toJson(iabResult, IabResult::class.java),
                            "inventory" to gson.toJson(inventory, Inventory::class.java)))
                }
            }
            "dispose" -> {
                mHelper?.dispose()
            }
            "subscriptionsSupported" -> {
                result.success(mHelper?.subscriptionsSupported())
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        mHelper?.dispose()
        mHelper = null
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}
}
