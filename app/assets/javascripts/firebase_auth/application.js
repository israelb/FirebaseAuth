// Importar Firebase
import { initializeApp } from "firebase/app";
import { getAuth, signInWithPopup, GoogleAuthProvider } from "firebase/auth";

console.log("FirebaseAuth application.js loaded");

// importados
document.addEventListener("turbo:load", () => {
  console.log("Turbo loaded");
  const app = initializeApp(window.firebaseConfig);
  const auth = getAuth(app);

  window.handleGoogleLogin = async function() {
    const provider = new GoogleAuthProvider();

    try {
      const result = await signInWithPopup(auth, provider);
      const idToken = await result.user.getIdToken();
      await sendIdTokenToServer(idToken);
    } catch (error) {
      console.error('Error logging in with Google:', error);
    }
  };

  window.sendIdTokenToServer = async function(idToken) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    const response = await fetch('/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
        'X-Requested-With': 'XMLHttpRequest',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ id_token: idToken })
    });

    if (response.ok) {
      console.log('Login successful:', response);
      const data = await response.json();
      window.location.href = data.redirect_url;
    } else {
      const data = await response.json();
      console.error('Login failed:', data.error);
    }
  };
});