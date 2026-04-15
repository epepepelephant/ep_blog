// 强制设置 favicon - 在页面加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
  // 创建新的 favicon 链接
  var link = document.createElement('link');
  link.rel = 'icon';
  link.href = 'assets/images/favicon.ico';
  link.type = 'image/x-icon';

  // 移除旧的 favicon 链接
  var oldLinks = document.querySelectorAll('link[rel="icon"], link[rel="shortcut icon"], link[rel="apple-touch-icon"]');
  oldLinks.forEach(function(el) {
    el.parentNode.removeChild(el);
  });

  // 添加新的 favicon
  document.head.appendChild(link);

  console.log('Favicon set to favicon.ico');
});