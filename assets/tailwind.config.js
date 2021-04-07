module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {
      opacity: ['disabled'],
    },
  },
  modules: {
    display: ['responsive', 'empty'],
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('tailwindcss-empty')(),
  ],
}
