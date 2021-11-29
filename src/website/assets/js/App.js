/* eslint-env browser */

document.addEventListener('DOMContentLoaded', () => {
  // Initializes navbar-specific behaviours.
  const navBarWrapSelector = document.querySelector('#navbar-wrap');
  const navBarSelector = document.querySelector('nav.navbar');
  const navBarSticky = navBarSelector.offsetTop;

  window.addEventListener('scroll', () => {
    if (window.scrollY > navBarSticky) {
      navBarWrapSelector.classList.add('sticky');
    } else {
      navBarWrapSelector.classList.remove('sticky');
    }
  });

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
});
