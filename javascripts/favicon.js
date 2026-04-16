// 强制设置 favicon
document.addEventListener('DOMContentLoaded', function() {
  var links = document.querySelectorAll('link[rel="icon"]');
  links.forEach(function(link) {
    link.href = '../../assets/images/favicon.ico';
  });
});