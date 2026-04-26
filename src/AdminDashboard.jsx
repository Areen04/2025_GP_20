import { useEffect, useMemo, useState } from "react";
import {
  collection,
  collectionGroup,
  onSnapshot,
  query,
  where,
  doc,
  updateDoc,
} from "firebase/firestore";
import { signOut } from "firebase/auth";
import { useNavigate } from "react-router-dom";
import { auth, db } from "./firebase";
import "./AdminDashboard.css";

function ErrorModal({ open, message, onClose }) {
  if (!open) return null;
  return (
    <div className="modalOverlay" onClick={onClose}>
      <div className="modalCard" onClick={(e) => e.stopPropagation()}>
        <div className="modalTitle">Error</div>
        <div className="modalMsg">{message}</div>
        <button className="modalBtn" onClick={onClose}>
          OK
        </button>
      </div>
    </div>
  );
}

export default function AdminDashboard() {
  const navigate = useNavigate();

  const [parentsCount, setParentsCount] = useState(0);
  const [activeDoctorsCount, setActiveDoctorsCount] = useState(0);
  const [childrenCount, setChildrenCount] = useState(0);
  const [doctors, setDoctors] = useState([]);

  const [errOpen, setErrOpen] = useState(false);
  const [errMsg, setErrMsg] = useState("");

  const [rejectingId, setRejectingId] = useState(null);
  const [rejectReasons, setRejectReasons] = useState({});

  const showError = (msg) => {
    setErrMsg(msg || "Something went wrong.");
    setErrOpen(true);
  };

  useEffect(() => {
    const unsubParents = onSnapshot(
      collection(db, "parents"),
      (snap) => setParentsCount(snap.size),
      (e) => showError(e.message)
    );

    const qActiveDocs = query(
      collection(db, "users"),
      where("role", "==", "doctor"),
      where("status", "==", "approved")
    );

    const unsubDocs = onSnapshot(
      qActiveDocs,
      (snap) => setActiveDoctorsCount(snap.size),
      (e) => showError(e.message)
    );

    const qChildren = query(collectionGroup(db, "children"));

    const unsubChildren = onSnapshot(
      qChildren,
      (snap) => setChildrenCount(snap.size),
      (e) => showError(e.message)
    );

    return () => {
      unsubParents();
      unsubDocs();
      unsubChildren();
    };
  }, []);

  useEffect(() => {
    const qDoctors = query(
      collection(db, "users"),
      where("role", "==", "doctor")
    );

    const unsub = onSnapshot(
      qDoctors,
      (snap) => {
        const rows = snap.docs.map((d) => ({ id: d.id, ...d.data() }));
        setDoctors(rows);
      },
      (e) => showError(e.message)
    );

    return () => unsub();
  }, []);

  const pendingCount = doctors.filter((d) => d.status === "pending").length;

  const overviewCards = useMemo(() => {
    return [
      { label: "Total Registered Parents", value: parentsCount, icon: "👥" },
      { label: "Active Doctors", value: activeDoctorsCount, icon: "🩺" },
      { label: "Children Profiles", value: childrenCount, icon: "👶" },
      { label: "Pending Doctor Requests", value: pendingCount, icon: "⏳" },
    ];
  }, [parentsCount, activeDoctorsCount, childrenCount, pendingCount]);

  const handleAccept = async (userId) => {
    try {
      await updateDoc(doc(db, "users", userId), {
        status: "approved",
        rejectionReason: "",
      });
    } catch (e) {
      showError(e.message);
    }
  };

  const openRejectBox = (userId) => {
    setRejectingId(userId);
  };

  const handleRejectReasonChange = (userId, value) => {
    setRejectReasons((prev) => ({
      ...prev,
      [userId]: value,
    }));
  };

  const submitReject = async (userId) => {
    const reason = rejectReasons[userId]?.trim();

    if (!reason) {
      showError("Rejection reason is required.");
      return;
    }

    try {
      await updateDoc(doc(db, "users", userId), {
        status: "rejected",
        rejectionReason: reason,
        rejectedAt: new Date(),
      });

      setRejectingId(null);
      setRejectReasons((prev) => ({
        ...prev,
        [userId]: "",
      }));
    } catch (e) {
      showError(e.message);
    }
  };

  const cancelReject = (userId) => {
    setRejectingId(null);
    setRejectReasons((prev) => ({
      ...prev,
      [userId]: "",
    }));
  };

  const handleLogout = async () => {
    try {
      await signOut(auth);
      navigate("/", { replace: true });
    } catch (e) {
      showError(e.message);
    }
  };

  return (
    <div className="dashPage">
      <ErrorModal
        open={errOpen}
        message={errMsg}
        onClose={() => setErrOpen(false)}
      />

      <div className="dashWrap">
        <div className="dashTopBar">
          <div className="brand">
            <div className="logoCircle" aria-hidden="true">
              <img src="/logo.png" alt="" />
            </div>
          </div>

          <button className="logoutBtn" onClick={handleLogout}>
            Logout
          </button>
        </div>

        <div className="dashTitle">Admin Dashboard</div>

        <div className="sectionTitle">Overview</div>

        <div className="cardsGrid">
          {overviewCards.map((c) => (
            <div className="statCard" key={c.label}>
              <div className="statLabel">{c.label}</div>
              <div className="statRow">
                <div className="statValue">
                  {Number(c.value).toLocaleString()}
                </div>
                <div className="statIcon" aria-hidden="true">
                  {c.icon}
                </div>
              </div>
            </div>
          ))}
        </div>

        <div className="sectionTitle">Doctor Registration Requests</div>

        <div className="tableCard">
          <div className="tableHead">
            <div>Doctor Name</div>
            <div>Email</div>
            <div>Document Type</div>
            <div>Document Number</div>
            <div className="actionsCol">Status / Actions</div>
          </div>

          {doctors.length === 0 ? (
            <div className="emptyState">No doctor requests.</div>
          ) : (
            doctors.map((d) => (
              <div className="tableRow" key={d.id}>
                <div>{d.fullName || "-"}</div>
                <div className="muted">{d.email || "-"}</div>
                <div>{d.docType || "-"}</div>
                <div className="muted">{d.docNumber || "-"}</div>

                <div className="actionsCol">
                  {d.status === "pending" ? (
                    rejectingId === d.id ? (
                      <div className="rejectReasonBox">
                        <label className="rejectReasonLabel">Reason:</label>

                        <textarea
                          className="rejectReasonInput"
                          value={rejectReasons[d.id] || ""}
                          onChange={(e) =>
                            handleRejectReasonChange(d.id, e.target.value)
                          }
                          placeholder="Enter your reason"
                          rows={2}
                        />

                        <div className="rejectReasonActions">
                          <button
                            className="btnReject"
                            onClick={() => submitReject(d.id)}
                          >
                            Send
                          </button>

                          <button
                            className="btnReject"
                            onClick={() => cancelReject(d.id)}
                          >
                            Cancel
                          </button>
                        </div>
                      </div>
                    ) : (
                      <>
                        <button
                          className="btnAccept"
                          onClick={() => handleAccept(d.id)}
                        >
                          Accept
                        </button>
                        <button
                          className="btnReject"
                          onClick={() => openRejectBox(d.id)}
                        >
                          Reject
                        </button>
                      </>
                    )
                  ) : (
                    <span
                      className={
                        d.status === "approved"
                          ? "statusApproved"
                          : "statusRejected"
                      }
                    >
                      {d.status === "approved" ? "Accepted" : "Rejected"}
                    </span>
                  )}
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}