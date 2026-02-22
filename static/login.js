function TTP(fieldId, togleId) {
    const field = document.getElementById(fieldId);
    const toggle = document.getElementById(togleId)?.querySelector("img");
    if (!field || !toggle) return;

    if (field.type === "password") {
    field.type = "text";
    toggle.src = "/static/hide.png";
    toggle.alt = "Hide Password";
    } else {
    field.type = "password";
    toggle.src = "/static/eye.png";
    toggle.alt = "Show Password";
}
}


const email = document.getElementById("email").value;

fetch("/send-otp", {
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded"
    },
    body: new URLSearchParams({
        email: email
    })
})
.then(res => res.text())
.then(data => {
    alert(data);
});