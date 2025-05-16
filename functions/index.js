const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Função para validar um voucher simples
exports.validateVoucher = functions.https.onCall(async (data, context) => {
  const pin = data.pin;
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Requer autenticação");
  }

  const snapshot = await admin.firestore().collection("vouchers").doc(pin).get();
  if (!snapshot.exists || snapshot.data().used === true) {
    return { valid: false };
  }

  await snapshot.ref.update({ used: true });
  return { valid: true };
});

// Função para sincronizar dados pendentes (exemplo)
exports.syncData = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Usuário não autenticado");
  }
  const pendingItems = data.items;
  for (const item of pendingItems) {
    await admin.firestore().collection("synced_items").doc(item.id).set(item);
  }
  return { success: true };
});