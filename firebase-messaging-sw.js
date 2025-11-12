importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// Configuração do Firebase (copiada de firebase_options.dart - Web)
firebase.initializeApp({
  apiKey: "AIzaSyD25JZdaoYY2TUIKr3Ey3ylS9r-xrQ0d8U",
  authDomain: "alanocryptofx-v2.firebaseapp.com",
  projectId: "alanocryptofx-v2",
  storageBucket: "alanocryptofx-v2.firebasestorage.app",
  messagingSenderId: "508290889017",
  appId: "1:508290889017:web:4e7b52875cfee66008e4e8"
});

const messaging = firebase.messaging();

// Handler para notificações em background
messaging.onBackgroundMessage((payload) => {
  console.log('📬 Notificação FCM recebida (background):', payload);

  const notificationTitle = payload.notification?.title || 'AlanoCryptoFX';
  const notificationOptions = {
    body: payload.notification?.body || 'Nova notificação',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: payload.data?.type || 'default',
    data: payload.data,
    requireInteraction: false,
    vibrate: [200, 100, 200],
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});

// Quando usuário clica na notificação
self.addEventListener('notificationclick', (event) => {
  console.log('🔔 Notificação FCM clicada:', event.notification.tag);
  event.notification.close();

  const type = event.notification.data?.type;
  let targetUrl = '/';

  // Definir URL de destino baseado no tipo
  switch (type) {
    case 'signal':
      targetUrl = '/#signals';
      break;
    case 'post':
    case 'alano_post':
      targetUrl = '/#posts';
      break;
    default:
      targetUrl = '/';
  }

  // Abrir app ou focar na aba já aberta
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      // Verificar se já existe uma janela aberta
      for (let i = 0; i < clientList.length; i++) {
        const client = clientList[i];
        if (client.url.includes(self.location.origin) && 'focus' in client) {
          return client.focus().then(() => {
            // Enviar mensagem para o cliente com a URL de destino
            if ('postMessage' in client) {
              client.postMessage({
                type: 'NOTIFICATION_CLICK',
                url: targetUrl,
                data: event.notification.data
              });
            }
          });
        }
      }
      // Se não houver janela aberta, abrir uma nova
      if (clients.openWindow) {
        return clients.openWindow(targetUrl);
      }
    })
  );
});

// Quando o service worker é instalado
self.addEventListener('install', (event) => {
  console.log('✅ Service Worker FCM instalado');
  self.skipWaiting();
});

// Quando o service worker é ativado
self.addEventListener('activate', (event) => {
  console.log('✅ Service Worker FCM ativado');
  event.waitUntil(clients.claim());
});
