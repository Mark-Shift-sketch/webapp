import os
import sys
import pytest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

os.environ.setdefault("SECRET_KEY", "test-secret-key")
os.environ.setdefault("SESSION_COOKIE_SECURE", "false")

@pytest.fixture
def app():
    import importlib

    # Change THIS if your file is not main.py
    module_name = "main"   # <-- if your file is app.py, set "app"

    mod = importlib.import_module(module_name)

    flask_app = getattr(mod, "app")  # expects `app = Flask(__name__)`
    flask_app.config.update(
        TESTING=True,
        WTF_CSRF_ENABLED=False,
    )
    return flask_app

@pytest.fixture
def client(app):
    return app.test_client()