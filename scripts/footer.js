// Update footer year dynamically
document.addEventListener('DOMContentLoaded', function() {
  const currentYear = new Date().getFullYear();
  const footerElements = document.querySelectorAll('.site-footer-text');
  footerElements.forEach(function(element) {
    element.textContent = '© ToadVille Bay Ltd 2019-' + currentYear;
  });
});
