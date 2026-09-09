import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://phx.tools',
  output: 'static',
  publicDir: './static',
  compressHTML: false,
  devToolbar: { enabled: false },
});
