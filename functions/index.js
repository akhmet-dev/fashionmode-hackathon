const { initializeApp } = require("firebase-admin/app");
const { getMessaging } = require("firebase-admin/messaging");
const {
  onDocumentCreated,
  onDocumentDeleted,
  onDocumentUpdated,
} = require("firebase-functions/v2/firestore");

initializeApp();

const APP_NAME = "AVISHU";
const ANDROID_CHANNEL_ID = "avishu_orders";

function buildMessage({ topic, title, body, data = {} }) {
  return {
    topic,
    notification: {
      title,
      body,
    },
    android: {
      priority: "high",
      notification: {
        channelId: ANDROID_CHANNEL_ID,
        sound: "default",
      },
    },
    apns: {
      headers: {
        "apns-priority": "10",
      },
      payload: {
        aps: {
          sound: "default",
        },
      },
    },
    data: Object.fromEntries(
      Object.entries(data).map(([key, value]) => [key, String(value)]),
    ),
  };
}

async function sendMessages(messages) {
  if (!messages.length) return;
  await Promise.all(messages.map((message) => getMessaging().send(message)));
}

exports.onOrderCreated = onDocumentCreated("orders/{orderId}", async (event) => {
  const order = event.data?.data();
  if (!order) return;

  const messages = [
    buildMessage({
      topic: "role_franchisee",
      title: APP_NAME,
      body: `Новый заказ: ${order.productName}`,
      data: {
        type: "order_created",
        orderId: event.params.orderId,
        status: order.status ?? "placed",
      },
    }),
    buildMessage({
      topic: "role_production",
      title: APP_NAME,
      body: `Новая задача в очереди: ${order.productName}`,
      data: {
        type: "order_created",
        orderId: event.params.orderId,
        status: order.status ?? "placed",
      },
    }),
  ];

  await sendMessages(messages);
});

exports.onOrderUpdated = onDocumentUpdated("orders/{orderId}", async (event) => {
  const before = event.data?.before.data();
  const after = event.data?.after.data();
  if (!before || !after) return;

  if (before.status === after.status) return;

  const statusConfig = {
    sewing: [
      {
        topic: `user_${after.clientId}`,
        body: `Заказ принят в работу: ${after.productName}`,
      },
      {
        topic: "role_franchisee",
        body: `Заказ переведён в пошив: ${after.productName}`,
      },
      {
        topic: "role_production",
        body: `Заказ поступил в пошив: ${after.productName}`,
      },
    ],
    ready: [
      {
        topic: `user_${after.clientId}`,
        body: `Заказ готов: ${after.productName}`,
      },
      {
        topic: "role_franchisee",
        body: `Заказ завершён: ${after.productName}`,
      },
      {
        topic: "role_production",
        body: `Заказ отмечен как готовый: ${after.productName}`,
      },
    ],
  };

  const recipients = statusConfig[after.status] ?? [];
  const messages = recipients.map((recipient) =>
    buildMessage({
      topic: recipient.topic,
      title: APP_NAME,
      body: recipient.body,
      data: {
        type: "order_status_changed",
        orderId: event.params.orderId,
        status: after.status,
      },
    }),
  );

  await sendMessages(messages);
});

exports.onOrderDeleted = onDocumentDeleted("orders/{orderId}", async (event) => {
  const order = event.data?.data();
  if (!order) return;

  const messages = [
    buildMessage({
      topic: `user_${order.clientId}`,
      title: APP_NAME,
      body: `Заказ отменён: ${order.productName}`,
      data: {
        type: "order_deleted",
        orderId: event.params.orderId,
      },
    }),
    buildMessage({
      topic: "role_franchisee",
      title: APP_NAME,
      body: `Заказ отменён клиентом: ${order.productName}`,
      data: {
        type: "order_deleted",
        orderId: event.params.orderId,
      },
    }),
    buildMessage({
      topic: "role_production",
      title: APP_NAME,
      body: `Заказ снят с производства: ${order.productName}`,
      data: {
        type: "order_deleted",
        orderId: event.params.orderId,
      },
    }),
  ];

  await sendMessages(messages);
});
