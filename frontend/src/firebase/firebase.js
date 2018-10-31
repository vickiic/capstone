import firebase from 'firebase/app';
import 'firebase/auth';

const prodConfig = {
    apiKey: "AIzaSyB6d0eWLz0Ury0nKI-Fs7cvlrTyZ8llMdI",
    authDomain: "ithfrontend-d0aa2.firebaseapp.com",
    databaseURL: "https://ithfrontend-d0aa2.firebaseio.com",
    projectId: "ithfrontend-d0aa2",
    storageBucket: "ithfrontend-d0aa2.appspot.com",
    messagingSenderId: "513072734313",
  };
  
  const devConfig = {
    apiKey: YOUR_API_KEY,
    authDomain: YOUR_AUTH_DOMAIN,
    databaseURL: YOUR_DATABASE_URL,
    projectId: YOUR_PROJECT_ID,
    storageBucket: '',
    messagingSenderId: YOUR_MESSAGING_SENDER_ID,
  };

  const config = process.env.NODE_ENV === 'production'
  ? prodConfig
  : devConfig;
  
  if (!firebase.apps.length) {
    firebase.initializeApp(config);
  }

  const auth = firebase.auth();

export {
  auth,
};
