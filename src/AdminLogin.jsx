import { useState } from "react";
import { signInWithEmailAndPassword } from "firebase/auth";
import { useNavigate } from "react-router-dom";
import { auth } from "./firebase";
import AlertDialog from "./components/AlertDialog";
import "./styles/admin.css";

export default function AdminLogin() {
  const navigate = useNavigate();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const [dialogOpen, setDialogOpen] = useState(false);
  const [dialogMsg, setDialogMsg] = useState("");

  const showError = (msg) => {
    setDialogMsg(msg || "An error occurred.");
    setDialogOpen(true);
  };

  const handleLogin = async (e) => {
    e.preventDefault();

    const e1 = email.trim();

    if (!e1 || !password) {
      showError("Please enter email and password.");
      return;
    }

    // ✅ طلبك: الأدمن لازم يكون هذا فقط
    if (e1 !== "admin@gmail.com" || password !== "Aa123456") {
      showError("Incorrect email or password.");
      return;
    }

    setLoading(true);
    try {
      await signInWithEmailAndPassword(auth, e1, password);

      // ✅ success: no alert
      navigate("/dashboard", { replace: true });
    } catch (err) {
      const code = err?.code || "";
      if (code.includes("auth/invalid-credential") || code.includes("auth/wrong-password")) {
        showError("Incorrect email or password.");
      } else if (code.includes("auth/user-not-found")) {
        showError("Admin account not found.");
      } else {
        showError(err?.message || "An error occurred.");
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-page">
      <div className="login-card">
        <div className="login-title">Admin Login</div>
        <div className="login-sub">Please enter your credentials to access the portal.</div>

        <form className="login-form" onSubmit={handleLogin}>
          <div className="form-group">
            <label className="label">Username or Email</label>
            <input
              className="input"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder=""
              autoComplete="username"
            />
          </div>

          <div className="form-group">
            <label className="label">Password</label>
            <input
              className="input"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder=""
              autoComplete="current-password"
            />
          </div>

          <button className="btn" disabled={loading}>
            {loading ? "Logging in..." : "Login"}
          </button>
        </form>
      </div>

      <AlertDialog
        open={dialogOpen}
        title="Error"
        message={dialogMsg}
        onClose={() => setDialogOpen(false)}
      />
    </div>
  );
}
