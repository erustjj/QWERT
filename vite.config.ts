import { vitePlugin as remix } from "@remix-run/dev";
import { defineConfig } from "vite";
import tsconfigPaths from "vite-tsconfig-paths";
import { netlifyPlugin } from "@remix-run/netlify"; // Netlify adapter'ı import et

export default defineConfig({
  plugins: [
    remix({
      future: {
        v3_fetcherPersist: true,
        v3_relativeSplatPath: true,
        v3_throwAbortReason: true,
      },
      // Netlify adapter'ını burada kullan
      buildEnd: async (args) => {
        if (args.primary) {
          await netlifyPlugin({
            // Adapter seçenekleri buraya gelebilir, şimdilik varsayılanlar yeterli
          }).buildEnd(args);
        }
      },
    }),
    tsconfigPaths(),
  ],
});
