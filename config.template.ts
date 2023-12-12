import { Config } from "./src/config";

export const defaultConfig: Config = {
  url: "https://www.aldi-onlineshop.de",
  match: [
    "https://www.aldi-onlineshop.de/p/**",
  ],
  matchToCrawl: [
    "https://www.aldi-onlineshop.de/p/**",
    "https://www.aldi-onlineshop.de/c/**",
  ],
  maxPagesToCrawl: 100_000_000_000_000,
  waitForSelectorTimeout: 3000,
  selector: ".blended",
  outputFileName: "outputs/output-aldi.js",
};
