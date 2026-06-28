// Update footer year
function updateFooterYear() {
    const footerYearElements = document.querySelectorAll('.site-footer-text');
    const currentYear = new Date().getFullYear();
    footerYearElements.forEach(element => {
        element.textContent = `© ToadVille Bay 2019–${currentYear}`;
    });
}

// Update year when page loads
document.addEventListener('DOMContentLoaded', updateFooterYear);