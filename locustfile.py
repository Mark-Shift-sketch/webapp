from locust import HttpUser, task, between

class WebUser(HttpUser):
    host="http://127.0.0.1:5000"
    wait_time = between(1, 2)
    @task(2)
    def open_login(self):
        self.client.get("/login")
    @task(1)
    def open_home(self):
        self.client.get("/")