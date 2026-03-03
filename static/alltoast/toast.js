document.addEventListener("DOMContentLoaded", function () {

    const flashes = document.querySelectorAll("#flash-messages div");

    flashes.forEach(flash => {

        const message = flash.dataset.message;
        const category = flash.dataset.category;

        Swal.fire({
            toast: true,
            position: 'top-end',
            icon: category || 'success',
            title: message,
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true
        });

    });

});
setTimeout(() => {
    document.querySelectorAll(".alert").forEach((el) => {
        el.style.opacity = "0";
        setTimeout(() => el.remove(), 300);
    });
}, 3000);
