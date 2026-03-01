# --- Fake DB layer (mock get_connection -> FakeConn -> FakeCursor) ---

class FakeCursor:
    def __init__(self):
        self._last_result = None
        self._fetch_queue = []

    def execute(self, query, params=None):
        q = " ".join(str(query).split()).lower()

        # 1) request_types (udashboard)
        if "from request_types" in q:
            self._last_result = [
                {
                    "request_type_id": 1,
                    "type_name": "Leave Form",
                    "template_filename": "leave.pdf",
                    "template_mode": "upload",
                },
                {
                    "request_type_id": 2,
                    "type_name": "Purchase Request",
                    "template_filename": "pr.pdf",
                    "template_mode": "annotate",
                },
            ]
            return

        # 2) recent_requests (udashboard)
        if "from requests r" in q and "join users u" in q and "limit 200" in q:
            self._last_result = [
                {
                    "request_id": 101,
                    "created_at": "2026-02-24 10:00:00",
                    "filename": "file1.pdf",
                    "email": "user1@phinmaed.com",
                    "dept_name": "GSD",
                    "type_name": "Leave Form",
                    "status_name": "PENDING",
                    "stage_position_id": 1,
                },
                {
                    "request_id": 102,
                    "created_at": "2026-02-24 11:00:00",
                    "filename": None,
                    "email": "user2@phinmaed.com",
                    "dept_name": "GSD",
                    "type_name": "Purchase Request",
                    "status_name": "APPROVED",
                    "stage_position_id": 1,
                },
            ]
            return

        # 3) counts (udashboard) -> returns {"c": number}
        if "select count(*) as c" in q:
            if "status_name='pending'" in q:
                self._fetch_queue = [{"c": 1}]
            elif "status_name='approved'" in q:
                self._fetch_queue = [{"c": 1}]
            elif "status_name='rejected'" in q:
                self._fetch_queue = [{"c": 0}]
            else:
                self._fetch_queue = [{"c": 0}]
            return

        # 4) approvals_today (udashboard)
        if "from request_actions" in q and "action='approved'" in q and "as c" in q:
            self._fetch_queue = [{"c": 1}]
            return

        # 5) history_rows (udashboard)
        if "from request_actions" in q and "order by" in q:
            self._last_result = [
                {
                    "request_id": 101,
                    "action": "APPROVED",
                    "actor_email": "approver@phinmaed.com",
                    "message": "ok",
                    "created_at": "2026-02-24 12:00:00",
                }
            ]
            return

        self._last_result = []
        self._fetch_queue = []

    def fetchall(self):
        return self._last_result or []

    def fetchone(self):
        if self._fetch_queue:
            return self._fetch_queue.pop(0)
        return {"c": 0, "count": 0}

    def close(self):
        pass


class FakeConn:
    def cursor(self, dictionary=True):
        return FakeCursor()

    def close(self):
        pass


def fake_get_connection():
    return FakeConn()


# ----------------- TESTS -----------------

def test_login_page_loads(client):
    r = client.get("/login")
    assert r.status_code == 200


def test_redirect_when_not_logged_in(client):
    r = client.get("/udashboard", follow_redirects=False)
    assert r.status_code in (301, 302)
    assert "/login" in (r.headers.get("Location", "") or "")


def test_udashboard_loads_when_logged_in_with_mocked_db(client, monkeypatch):
    import main
    monkeypatch.setattr(main, "get_connection", fake_get_connection)

    with client.session_transaction() as sess:
        sess["email"] = "dev@example.com"
        sess["role"] = "dev"
        sess["dept"] = "GSD"
        sess["position_id"] = 1
        sess["position"] = "Developer"

    r = client.get("/udashboard")
    assert r.status_code == 200

    body = r.get_data(as_text=True).lower()
    assert "dashboard" in body


def test_activity_logs_requires_login(client):
    r = client.get("/api/activity_logs")
    assert r.status_code == 200
    data = r.get_json()
    assert data["success"] is False