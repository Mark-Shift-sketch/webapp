import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import pytest
from main import app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as c:
        yield c
        


def test_login_page_loads(client):
    r = client.get("/login")
    assert r.status_code == 200
    
def test_redirect_when_not_logged_in(client):
    r = client.get("/udashboard", follow_redirects=False)
    assert r.status_code in (301, 302)
    

    

    

    