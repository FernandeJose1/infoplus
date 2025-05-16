package com.ussd.infoplus

import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class USSDHandler: FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel : MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.ussd.infoplus/payment")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "sendUssd" -> {
                val code: String? = call.argument("code")
                if (code != null) {
                    sendUssd(code, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Código USSD ausente", null)
                }
            }
            "startPayment" -> {
                // Pode implementar aqui lógica específica de pagamento
                result.success("startPayment não implementado no USSDHandler")
            }
            else -> result.notImplemented()
        }
    }

    private fun sendUssd(code: String, result: MethodChannel.Result) {
        try {
            val uri = Uri.parse("tel:" + Uri.encode(code))
            val intent = Intent(Intent.ACTION_CALL, uri)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            result.success("USSD enviado: $code")
        } catch (e: Exception) {
            result.error("USSD_ERROR", e.localizedMessage, null)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}