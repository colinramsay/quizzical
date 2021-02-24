module.exports = {
  // purge: {
  //   mode: 'all',
  //   preserveHtmlElements: false,
  //   enabled: true,
  //   content: [
  //     "../**/*.html.eex",
  //     "../**/*.html.leex",
  //     "../**/views/**/*.ex",
  //     "../**/live/**/*.ex",
  //     "./js/**/*.js"
  //   ]
  // },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms')
  ],
}
