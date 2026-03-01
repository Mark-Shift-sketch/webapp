/* SHIPMENT MODAL (DEV) */
function openSendModal() {
    const m = document.getElementById("sendModal");
    if (m) m.style.display = "flex";

    const body = document.getElementById("shipmentBody");
    if (body && body.children.length === 0) addShipmentRow();
}

function closeSendModal() {
    const m = document.getElementById("sendModal");
    if (m) m.style.display = "none";
}

function addShipmentRow() {
    const body = document.getElementById("shipmentBody");
    if (!body) return;

    const tr = document.createElement("tr");
    tr.innerHTML = `
        <td><input type="text" class="tbl-in" name="units[]" /></td>
        <td><input type="text" class="tbl-in" name="item_number[]" /></td>
        <td><input type="text" class="tbl-in" name="location[]" /></td>
        <td><input type="text" class="tbl-in" name="event_description[]" /></td>
        <td><input type="text" class="tbl-in" name="category[]" /></td>
        <td>
            <select class="tbl-in" name="drop_ship[]">
            <option value="NO">No</option>
            <option value="YES">Yes</option>
            </select>
        </td>
        <td><input type="number" class="tbl-in" name="qty_received[]" min="0" /></td>
        <td><input type="text" class="tbl-in" name="uom[]" /></td>
        <td><input type="number" class="tbl-in" name="unit_cost[]" min="0" step="0.01" /></td>
        <td class="text-right">
            <button type="button" class="action-icon-btn icon-delete" onclick="this.closest('tr').remove()">
            <i class="fa-regular fa-trash-can"></i>
            </button>
        </td>
        `;
    body.appendChild(tr);
}

async function submitShipment(e) {
    e.preventDefault();

    const payload = {
        shipment_number: (
            document.getElementById("ship_no")?.value || ""
        ).trim(),
        shipment_date: document.getElementById("ship_date")?.value || "",
        description: (
            document.getElementById("ship_desc")?.value || ""
        ).trim(),
        customer_number: (
            document.getElementById("cust_no")?.value || ""
        ).trim(),
        contact: (document.getElementById("contact")?.value || "").trim(),
        price_list: (
            document.getElementById("price_list")?.value || ""
        ).trim(),
        pending_date: document.getElementById("pending_date")?.value || "",
        reference: (document.getElementById("reference")?.value || "").trim(),
        entry_type: document.getElementById("entry_type")?.value || "",
        items: [],
    };

    document.querySelectorAll("#shipmentBody tr").forEach((tr) => {
        const inputs = tr.querySelectorAll("input, select");
        const row = {};
        inputs.forEach((el) => (row[el.name.replace("[]", "")] = el.value));
        payload.items.push(row);
    });

    if (!payload.shipment_number)
        return alert("Shipment Number is required.");
    if (!payload.shipment_date) return alert("Shipment Date is required.");
    if (!payload.entry_type) return alert("Entry Type is required.");
    if (payload.items.length === 0)
        return alert("Add at least 1 item row.");

    console.log("Shipment payload:", payload);
    alert(
        "Ready to submit (check console). Connect to your API endpoint next.",
    );
    closeSendModal();
}

/* SEND COPY MODAL */
function openSendCopyModal() {
    const m = document.getElementById("sendCopyModal");
    if (m) m.style.display = "flex";

    const body = document.getElementById("sendCopyBody");
    if (body && body.children.length === 0) addSendCopyRow();
}

function closeSendCopyModal() {
    const m = document.getElementById("sendCopyModal");
    if (m) m.style.display = "none";
}

function switchScTab(panelId, btn) {
    document
        .querySelectorAll("#sendCopyModal .sc-panel")
        .forEach((p) => (p.style.display = "none"));
    const panel = document.getElementById(panelId);
    if (panel) panel.style.display = "block";

    document
        .querySelectorAll("#sendCopyModal .sc-tab")
        .forEach((b) => b.classList.remove("active"));
    if (btn) btn.classList.add("active");
}

function addSendCopyRow() {
    const body = document.getElementById("sendCopyBody");
    if (!body) return;

    const tr = document.createElement("tr");
    tr.innerHTML = `
        <td><input class="tbl-in" name="units[]" type="text" /></td>
        <td>
            <select class="tbl-in" name="complete_po[]">
            <option value="NO">No</option>
            <option value="YES">Yes</option>
            </select>
        </td>
        <td><input class="tbl-in" name="item_number[]" type="text" /></td>
        <td><input class="tbl-in" name="item_description[]" type="text" /></td>
        <td><input class="tbl-in" name="location[]" type="text" /></td>
        <td>
            <select class="tbl-in" name="drop_ship[]">
            <option value="NO">No</option>
            <option value="YES">Yes</option>
            </select>
        </td>
        <td><input class="tbl-in" name="qty_received[]" type="number" min="0" /></td>
        <td><input class="tbl-in" name="uom[]" type="text" /></td>
        <td><input class="tbl-in" name="unit_cost[]" type="number" min="0" step="0.01" /></td>
        <td class="text-right">
            <button type="button" class="action-icon-btn icon-delete" onclick="this.closest('tr').remove()">
            <i class="fa-regular fa-trash-can"></i>
            </button>
        </td>
        `;
    body.appendChild(tr);
}

async function submitSendCopy(e) {
    e.preventDefault();

    const payload = {
        receipt_no: (
            document.getElementById("sc_receipt_no")?.value || ""
        ).trim(),
        vendor_name: (
            document.getElementById("sc_vendor_name")?.value || ""
        ).trim(),

        po_number: (
            document.getElementById("sc_po_number")?.value || ""
        ).trim(),
        receipt_date: document.getElementById("sc_receipt_date")?.value || "",
        template: (
            document.getElementById("sc_template")?.value || ""
        ).trim(),
        fob_point: (
            document.getElementById("sc_fob_point")?.value || ""
        ).trim(),
        terms_code: (
            document.getElementById("sc_terms_code")?.value || ""
        ).trim(),
        vendor_acct_set: (
            document.getElementById("sc_vendor_acct_set")?.value || ""
        ).trim(),
        description: (
            document.getElementById("sc_description")?.value || ""
        ).trim(),
        posting_date: document.getElementById("sc_posting_date")?.value || "",
        bill_to: (document.getElementById("sc_bill_to")?.value || "").trim(),
        ship_to: (document.getElementById("sc_ship_to")?.value || "").trim(),

        ship_via: (
            document.getElementById("sc_ship_via")?.value || ""
        ).trim(),
        last_receipt_no: (
            document.getElementById("sc_last_receipt_no")?.value || ""
        ).trim(),
        header_location: (
            document.getElementById("sc_header_location")?.value || ""
        ).trim(),

        reference: (
            document.getElementById("sc_reference")?.value || ""
        ).trim(),
        items: [],
    };

    document.querySelectorAll("#sendCopyBody tr").forEach((tr) => {
        const row = {};
        tr.querySelectorAll("input, select").forEach((el) => {
            row[el.name.replace("[]", "")] = el.value;
        });
        payload.items.push(row);
    });

    if (!payload.vendor_name) return alert("Vendor Name is required.");
    if (payload.items.length === 0)
        return alert("Add at least 1 item row.");

    console.log("Send Copy payload:", payload);
    alert("Saved locally (console). Connect backend later.");
    closeSendCopyModal();
}

/* close modals on outside click */
window.addEventListener("click", (e) => {
    const sendModal = document.getElementById("sendModal");
    if (sendModal && e.target === sendModal) closeSendModal();

    const sendCopyModal = document.getElementById("sendCopyModal");
    if (sendCopyModal && e.target === sendCopyModal) closeSendCopyModal();

    const invModal = document.getElementById("invModal");
    if (invModal && e.target === invModal) closeInvModal();
});

/* DATE + NAV */
function setDates() {
    const dateOptions = {
        weekday: "long",
        year: "numeric",
        month: "long",
        day: "numeric",
    };
    const today = new Date().toLocaleDateString("en-US", dateOptions);
    document
        .querySelectorAll(".current-date-display")
        .forEach((el) => (el.innerText = today));
}

function rememberView(viewName) {
    localStorage.setItem("activeView", viewName);
}

function restoreView() {
    const v = localStorage.getItem("activeView");
    if (v) switchView(v);
}

function switchView(viewName) {
    document
        .querySelectorAll(".view-section")
        .forEach((el) => (el.style.display = "none"));
    document
        .querySelectorAll(".nav-item")
        .forEach((el) => el.classList.remove("active"));

    let viewEl = document.getElementById(`view-${viewName}`);
    let navEl = document.getElementById(`nav-${viewName}`);

    if (!viewEl) {
        viewName = "dashboard";
        viewEl = document.getElementById("view-dashboard");
        navEl = document.getElementById("nav-dashboard");
    }

    rememberView(viewName);

    if (viewEl) viewEl.style.display = "flex";
    if (navEl) navEl.classList.add("active");
}

/* FILTERS */

function filterTable() {
    const q = (document.getElementById("search-input")?.value || "")
        .toLowerCase()
        .trim();

    const status = (document.getElementById("status-filter")?.value || "")
        .toUpperCase()
        .trim();

    const tbody = document.getElementById("requests-table-body");
    if (!tbody) return;

    const rows = tbody.querySelectorAll("tr.request-row");
    let visible = 0;

    rows.forEach((row) => {
        const rowText = (row.innerText || "").toLowerCase();
        const rowStatus = ((row.dataset.status || "") + "")
            .toUpperCase()
            .trim();

        const matchQ = !q || rowText.includes(q);
        const matchS = !status || rowStatus === status;

        const show = matchQ && matchS;
        row.style.display = show ? "" : "none";
        if (show) visible++;
    });

    const badge = document.getElementById("table-count-badge");
    if (badge) badge.textContent = String(visible);
}

document.addEventListener("DOMContentLoaded", () => {
    filterTable();
});

function filterInvMgmt() {
    const q = (
        document.getElementById("inv-mgmt-search")?.value || ""
    ).toLowerCase();
    const rows = document.querySelectorAll(
        "#inv-mgmt-body tr.inv-mgmt-row",
    );

    let visible = 0;
    rows.forEach((row) => {
        const text = (row.textContent || "").toLowerCase();
        const show = text.includes(q);
        row.style.display = show ? "" : "none";
        if (show) visible++;
    });

    const badge = document.getElementById("inv-mgmt-count");
    if (badge) badge.textContent = visible;
}

function filterHistory() {
    const q = (
        document.getElementById("history-search")?.value || ""
    ).toLowerCase();
    const actionFilter = (
        document.getElementById("history-filter")?.value || ""
    )
        .trim()
        .toUpperCase();
    const rows = document.querySelectorAll("#history-body tr.history-row");

    let visible = 0;
    rows.forEach((row) => {
        const text = (row.textContent || "").toLowerCase();
        const action = (row.dataset.action || "").trim().toUpperCase();
        const show =
            text.includes(q) &&
            (actionFilter === "" || action === actionFilter);
        row.style.display = show ? "" : "none";
        if (show) visible++;
    });

    const badge = document.getElementById("history-count");
    if (badge) badge.textContent = visible;
}

function filterInventory() {
    const q = (
        document.getElementById("inv-search")?.value || ""
    ).toLowerCase();
    document
        .querySelectorAll("#inventory-body tr.inv-row")
        .forEach((row) => {
            const name = row.getAttribute("data-name") || "";
            row.style.display = name.includes(q) ? "" : "none";
        });
}

/* APPROVE / REJECT */
function rejectRequest(requestId) {
    const reason = prompt("Please enter the reason for rejection:");
    if (reason === null) return;
    if (reason.trim() === "") return alert("Rejection reason is required.");
    updateStatus(requestId, "rejected", reason);
}

function getCsrfToken() {

    const meta = document.querySelector('meta[name="csrf-token"]');
    if (meta?.content) return meta.content;

    // From any hidden input
    const hidden = document.querySelector('input[name="csrf_token"]');
    if (hidden?.value) return hidden.value;

    return "";
}

async function updateStatus(requestId, status, message = "") {
    const normalizedStatus = String(status).trim().toUpperCase(); // APPROVED / REJECTED
    const csrfToken = getCsrfToken();

    if (!confirm(`Mark request #${requestId} as ${normalizedStatus}?`))
        return;

    try {
        const response = await fetch(`/api/request/${requestId}/status`, {
            method: "POST",
            credentials: "same-origin", 
            headers: {
                "Content-Type": "application/json",
                Accept: "application/json",
                "X-CSRFToken": csrfToken,
                "X-CSRF-Token": csrfToken,
            },
            body: JSON.stringify({
                status: normalizedStatus,
                message: message || "",
            }),
        });

        const text = await response.text();
        let data = {};
        try {
            data = JSON.parse(text);
        } catch (_) {
            console.log("Error ")
        }

        if (!response.ok) {
            // Show actual server error if available
            const msg =
                data.error ||
                data.message ||
                text?.slice(0, 300) ||
                `HTTP ${response.status}`;
            alert("Error: " + msg);
            return;
        }

        alert("Success: " + (data.message || "Updated"));
        location.reload();
    } catch (err) {
        console.error(err);
        alert("Network error. Failed to update status.");
    }
}

function rejectRequest(requestId) {
    const reason = prompt("Please enter the reason for rejection:");
    if (reason === null) return;
    if (reason.trim() === "") return alert("Rejection reason is required.");
    updateStatus(requestId, "REJECTED", reason); // send uppercase
}

/* INVENTORY MODAL (DEV) */
function openInvModal(id = "", name = "", qty = "") {
    const titleEl = document.getElementById("invModalTitle");
    const idEl = document.getElementById("inv_product_id");
    const nameEl = document.getElementById("inv_product_name");
    const qtyEl = document.getElementById("inv_quantity");
    const modal = document.getElementById("invModal");

    if (!modal) return;

    if (titleEl) titleEl.innerText = id ? "Edit Product" : "Add Product";
    if (idEl) idEl.value = id;
    if (nameEl) nameEl.value = name;
    if (qtyEl) qtyEl.value = qty;

    modal.style.display = "flex";
}

function closeInvModal() {
    const modal = document.getElementById("invModal");
    if (modal) modal.style.display = "none";
}

async function saveProduct(e) {
    e.preventDefault();

    const id = (
        document.getElementById("inv_product_id")?.value || ""
    ).trim();
    const product_name = (
        document.getElementById("inv_product_name")?.value || ""
    ).trim();
    const quantity = Number(document.getElementById("inv_quantity")?.value);

    if (!product_name) return alert("Product name is required.");
    if (Number.isNaN(quantity) || quantity < 0)
        return alert("Quantity must be 0 or above.");

    const url = id ? `/api/inventory/${id}` : `/api/inventory`;
    const method = id ? "PUT" : "POST";

    rememberView("inventory");

    try {
        const res = await fetch(url, {
            method,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ product_name, quantity }),
        });

        const data = await res.json().catch(() => ({}));

        if (res.status === 409) {
            alert(data.error || "Product already in inventory.");
            return;
        }

        if (!res.ok) {
            alert(data.error || "Failed to save product.");
            return;
        }

        closeInvModal();
        location.reload();
    } catch (err) {
        console.error(err);
        alert("Network error.");
    }
}

async function deleteProduct(id) {
    if (!confirm("Delete this product?")) return;

    rememberView("inventory");

    try {
        const res = await fetch(`/api/inventory/${id}`, { method: "DELETE" });
        const data = await res.json().catch(() => ({}));
        if (!res.ok) return alert(data.error || "Failed to delete product.");
        location.reload();
    } catch (err) {
        console.error(err);
        alert("Network error.");
    }
}

window.addEventListener("load", () => {
    setDates();
    restoreView();

    if (document.getElementById("search-input")) filterTable();
    if (document.getElementById("inv-mgmt-search")) filterInvMgmt();
    if (document.getElementById("history-search")) filterHistory();

    if (window.lucide) lucide.createIcons();
});
