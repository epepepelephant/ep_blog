// KaTeX 渲染脚本 - 确保在 body 加载后执行
setTimeout(function() {
  if (typeof renderMathInElement === 'function') {
    renderMathInElement(document.body, {
      delimiters: [
        {left: "$$", right: "$$", display: true},
        {left: "$", right: "$", display: false}
      ],
      throwOnError: false,
      errorCallback: function(msg) {
        console.error('KaTeX Error:', msg);
      }
    });
    console.log('KaTeX rendering applied');
  } else {
    console.error('renderMathInElement not found');
  }
}, 500);