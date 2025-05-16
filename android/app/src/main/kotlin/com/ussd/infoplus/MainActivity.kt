package com.ussd.infoplus

import android.content.Intent
import android.os.Bundle
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var phoneStateListener: PhoneStateListener
    private val CHANNEL = "com.ussd.infoplus/payment"
    private lateinit var ussdHandler: USSDHandler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Registrar o plugin USSDHandler
        ussdHandler = USSDHandler()
        ussdHandler.onAttachedToEngine(flutterEngine.dartExecutor.binaryMessenger as io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startPayment" -> {
                    val intent = Intent(this, EmolaPaymentService::class.java).apply {
                        action = "PROCESS_PAYMENT"
                        putExtra("payment_data", call.arguments.toString())
                    }
                    startService(intent)
                    result.success("Pagamento iniciado")
                }
                "startUSSDListener" -> {
                    // Se precisar ouvir resposta USSD, implementar aqui
                    result.success("Listener iniciado")
                }
                else -> result.notImplemented()
            }
        }

        phoneStateListener = object : PhoneStateListener() {
            override fun onCallStateChanged(state: Int, phoneNumber: String?) {
                // Pode implementar lógica para chamadas aqui, se quiser
            }
        }

        val tm = getSystemService(TELEPHONY_SERVICE) as TelephonyManager
        tm.listen(phoneStateListener, PhoneStateListener.LISTEN_CALL_STATE)
    }

    override fun onDestroy() {
        super.onDestroy()
        val tm = getSystemService(TELEPHONY_SERVICE) as TelephonyManager
        tm.listen(phoneStateListener, PhoneStateListener.LISTEN_NONE)
    }
}