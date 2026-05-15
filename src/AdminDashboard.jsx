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

  const [statusFilter, setStatusFilter] = useState("all");

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
      { label: "Verified Doctors", value: activeDoctorsCount, icon: "🩺" },
      { label: "Children Profiles", value: childrenCount, icon: "👶" },
      { label: "Pending Verification Requests", value: pendingCount, icon: "⏳" },
    ];
  }, [parentsCount, activeDoctorsCount, childrenCount, pendingCount]);

  const filteredDoctors = useMemo(() => {
    return [...doctors]
      .sort((a, b) => {
        const aTime = a.createdAt?.seconds || 0;
        const bTime = b.createdAt?.seconds || 0;
        return bTime - aTime;
      })
      .filter((d) => {
        if (statusFilter === "all") return true;
        return d.status === statusFilter;
      });
  }, [doctors, statusFilter]);

  const handleVerify = async (userId) => {
    try {
      await updateDoc(doc(db, "users", userId), {
        status: "approved",
        rejectionReason: "",
        verifiedAt: new Date(),
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

  const submitNotVerified = async (userId) => {
    const reason = rejectReasons[userId];

    if (!reason) {
      showError("Please select a reason.");
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

  const getStatusLabel = (status) => {
    if (status === "approved") return "Information Verified";
    if (status === "rejected") return "Information Not Verified";
    return "Pending Verification";
  };

  const getStatusClass = (status) => {
    if (status === "approved") return "statusApproved";
    if (status === "rejected") return "statusRejected";
    return "statusPending";
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

        <div className="sectionTitle">
          Healthcare Practitioner Information Verification
        </div>

        <div className="filterRow">
          <label className="filterLabel">Status:</label>
          <select
            className="statusFilter"
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
          >
            <option value="all">All Requests</option>
            <option value="pending">Pending Verification</option>
            <option value="approved">Information Verified</option>
            <option value="rejected">Information Not Verified</option>
          </select>
        </div>

        <div className="tableCard">
          <div className="tableHead">
            <div>Doctor Name</div>
            <div>Email</div>
            <div>Document Type</div>
            <div>Document Number</div>
            <div className="actionsCol">Status / Actions</div>
          </div>

          {filteredDoctors.length === 0 ? (
            <div className="emptyState">No requests found.</div>
          ) : (
            filteredDoctors.map((d) => (
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

                        <select
                          className="rejectReasonInput"
                          value={rejectReasons[d.id] || ""}
                          onChange={(e) =>
                            handleRejectReasonChange(d.id, e.target.value)
                          }
                        >
                          <option value="">Select a reason</option>
                          <option value="The provided information does not match the official records.">
                            Information does not match official records
                          </option>
                        </select>

                        <div className="rejectReasonActions">
                          <button
                            className="btnReject"
                            onClick={() => submitNotVerified(d.id)}
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
                          onClick={() => handleVerify(d.id)}
                        >
                          Information Verified
                        </button>

                        <button
                          className="btnReject"
                          onClick={() => openRejectBox(d.id)}
                        >
                          Information Not Verified
                        </button>
                      </>
                    )
                  ) : (
                    <span className={getStatusClass(d.status)}>
                      {getStatusLabel(d.status)}
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