import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyBo9n6Ow5Lk4FuRBLl81bawwV0ZPg6z2aM",
  authDomain: "rafiq-app-95bb1.firebaseapp.com",
  projectId: "rafiq-app-95bb1",
  storageBucket: "rafiq-app-95bb1.firebasestorage.app",
  messagingSenderId: "909633604319",
  appId: "1:909633604319:web:29bec0f5d1df239b17b76a",
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db = getFirestore(app);
