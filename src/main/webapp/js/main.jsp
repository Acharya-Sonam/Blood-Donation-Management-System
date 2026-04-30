// Auto-dismiss alerts after 5 seconds 
(function () {
    var alerts = document.querySelectorAll('.alert');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity    = '0';
            setTimeout(function () {
                alert.style.display = 'none';
            }, 500);
        }, 5000);
    });
})();

// Confirm on all delete / reject buttons 
(function () {
    var dangerForms = document.querySelectorAll(
        'form[data-confirm], .confirm-action'
    );
    dangerForms.forEach(function (form) {
        form.addEventListener('submit', function (e) {
            var msg = form.dataset.confirm || 'Are you sure?';
            if (!confirm(msg)) {
                e.preventDefault();
            }
        });
    });
})();

// Character counter for textarea fields 
(function () {
    var textareas = document.querySelectorAll('textarea[maxlength]');
    textareas.forEach(function (ta) {
        var max = ta.getAttribute('maxlength');
        var counter = document.createElement('small');
        counter.className = 'field-hint';
        counter.textContent = '0 / ' + max + ' characters';
        ta.parentNode.insertBefore(counter, ta.nextSibling);

        ta.addEventListener('input', function () {
            counter.textContent = ta.value.length + ' / ' + max + ' characters';
        });
    });
})();

// Reusable table search function 
function searchTable(input, tableId) {
    var filter = input.value.toLowerCase();
    var table = document.getElementById(tableId);
    if (!table) return;
    var rows = table.getElementsByTagName('tr');
    for (var i = 1; i < rows.length; i++) {
        var text = rows[i].textContent.toLowerCase();
        rows[i].style.display = text.includes(filter) ? '' : 'none';
    }
}

//Highlight active nav link based on current URL 
(function () {
    var links   = document.querySelectorAll('.sidebar-nav a');
    var current = window.location.pathname;
    links.forEach(function (link) {
        if (link.getAttribute('href') &&
            current.includes(link.getAttribute('href'))) {
            link.classList.add('active');
        }
    });
})();
