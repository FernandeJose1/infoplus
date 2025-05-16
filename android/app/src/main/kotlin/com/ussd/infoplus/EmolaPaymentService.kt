package com.ussd.infoplus

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log

class EmolaPaymentService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val paymentData = intent?.getStringExtra("payment_data")
        Log.d("EmolaPaymentService", "Processando pagamento: $paymentData")

        // Aqui você pode implementar lógica de pagamento, por exemplo:
        // - Gerar código USSD específico
        // - Enviar notificação de status
        // Por ora, apenas loga e para o serviço

        stopSelf()
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        // Não usado neste serviço
        return null
    }
}