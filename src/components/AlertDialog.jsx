export default function AlertDialog({ open, title = "Error", message, onClose }) {
  if (!open) return null;

  return (
    <div className="dialog-backdrop" onClick={onClose}>
      <div className="dialog" onClick={(e) => e.stopPropagation()}>
        <h3>{title}</h3>
        <p>{message}</p>
        <div className="dialog-actions">
          <button onClick={onClose}>OK</button>
        </div>
      </div>
    </div>
  );
}
