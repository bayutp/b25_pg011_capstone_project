// web/firebase-messaging-sw.js
importScripts("https://www.gstatic.com/firebasejs/10.12.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyApOLtNO91nAB7yCzAugk47tGKpDcIJ4zk",
    authDomain: "capstone-project-c0f48.firebaseapp.com",
    projectId: "capstone-project-c0f48",
    storageBucket: "capstone-project-c0f48.firebasestorage.app",
    messagingSenderId: "439975735447",
    appId: "1:439975735447:web:90506fa8895040817b39d2",
    measurementId: "G-W7J90GGN0E"
});

const messaging = firebase.messaging();

// Optional: handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log("Received background message: ", payload);
  self.registration.showNotification(payload.notification.title, {
    body: payload.notification.body,
    icon: "/icons/Icon-192.png",
  });
});
