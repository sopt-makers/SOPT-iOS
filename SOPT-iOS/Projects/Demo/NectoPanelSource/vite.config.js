import { defineConfig } from "vite";

// 빌드 결과는 Demo 타겟이 폴더 참조로 번들에 넣는 ../NectoPanel 로 나간다.
export default defineConfig({
  base: "./",
  build: {
    outDir: "../NectoPanel",
    emptyOutDir: true,
    rollupOptions: {
      output: {
        entryFileNames: "assets/[name].js",
        chunkFileNames: "assets/[name].js",
        assetFileNames: "assets/[name].[ext]",
      },
    },
  },
});
