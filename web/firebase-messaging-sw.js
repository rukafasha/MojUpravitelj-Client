importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-messaging.js");

//Using singleton breaks instantiating messaging()
// App firebase = FirebaseWeb.instance.app;


firebase.initializeApp({
    apiKey: 'AIzaSyCpvL9-ZaqGrKyHaMFWpZIj_8LzsolXZww',
    appId: '1:616816988843:web:8ecdbf08cbd1d161459dee',
    messagingSenderId: '616816988843',
    projectId: 'flutter-notification1',
    authDomain: 'flutter-notification1.firebaseapp.com',
    storageBucket: 'flutter-notification1.appspot.com',
    measurementId: 'G-W75NX9RSZ7',
});

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});