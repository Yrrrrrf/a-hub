import containerQueries from '@tailwindcss/container-queries';
import forms from '@tailwindcss/forms';
import typography from '@tailwindcss/typography';
import type { Config } from 'tailwindcss';
import daisyui from 'daisyui';

import { availableThemes } from 'rune-lab/themes';

export default {
  content: ['./src/**/*.{html,js,svelte,ts}',
    // * This lines are added to include rune-lab and daisyui components
    './node_modules/rune-lab/dist/**/*.{html,js,svelte,ts}',  // rune-lab components (import styles)
    './node_modules/daisyui/**/*.{html,js,svelte,ts}',  // daisyui components (import styles)
  ],

  theme: {
    extend: {}
  },

  plugins: [
    typography, 
    forms, 
    containerQueries,
    daisyui,
  ],

  daisyui: {
    themes: [...availableThemes],
    themeRoot: "html",
    styled: true,
    utils: true,
    base: true,
    prefix: "",
    logs: true,
    darkTheme: null,
    respectSelectedTheme: false,  // Respect the theme selected by the user
    // rtl: false,  // Whether to add RTL support (Right to Left)
  }
} satisfies Config;
