/* eslint-env browser */

import feather from 'feather-icons';
import hljs from 'highlight.js';

import controllers from './controllers/index.js';
import DOMRouter from './core/DOMRouter.js';

const router = new DOMRouter(controllers);

document.addEventListener('DOMContentLoaded', () => {
  // Initializes navbar-specific behaviours.
  const navBarWrapSelector = document.querySelector('#navbar-wrap');

  function updateNavBarStickyState() {
    // Treat negative scroll (Firefox overscroll) as "at top".
    const atTop = window.scrollY <= 0;
    navBarWrapSelector.classList.toggle('sticky', !atTop);
  }

  window.addEventListener('scroll', updateNavBarStickyState, { passive: true });
  updateNavBarStickyState();

  // Initializes responsive-specific behaviours.
  const largeDevicesWidth = 1025;
  const navBarMenu = document.querySelector('#navbar-wrap .navbar-menu');
  const navBarToggler = document.querySelector('.navbar-burger');

  function toggleAction(ev) {
    ev.stopImmediatePropagation();
    navBarMenu.classList.toggle('opened');
    document.body.classList.toggle('navbar-menu-opened');
    navBarToggler.classList.toggle('is-active');
  }

  function closeNavBar(ev) {
    ev.stopImmediatePropagation();
    if (!ev.target.closest('.navbar-toggler, .navbar-menu')) {
      navBarMenu.classList.remove('opened');
      document.body.classList.remove('navbar-menu-opened');
      navBarToggler.classList.remove('is-active');
    }
  }

  window.addEventListener('resize', () => {
    if (window.innerWidth <= largeDevicesWidth) {
      navBarToggler.addEventListener('click', (ev) => toggleAction(ev));
      document.addEventListener('click', (ev) => closeNavBar(ev));
    }
  });
  window.dispatchEvent(new Event('resize'));

  // Initializes feather icons.
  feather.replace();

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

  // Initializes the DOM router. The DOM router is used to execute specific portions of JS code for
  // each specific page.
  router.init();
});
