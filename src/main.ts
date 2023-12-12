import { defaultConfig } from "../config.template.js";
import { crawl, write } from "./core.js";

await crawl(defaultConfig);
await write(defaultConfig);
