import hljs from 'highlight.js';

export default {
  init() {
    // Initializes Highlight JS.
    document.querySelectorAll('pre code.language-html').forEach((el) => {
      el.innerHTML = el.innerHTML
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
    });

    document.querySelectorAll('pre code').forEach((el) => {
      hljs.highlightElement(el);
    });
  },
};
