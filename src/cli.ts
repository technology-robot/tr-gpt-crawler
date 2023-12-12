#!/usr/bin/env node

import { program } from "commander";
import { Config } from "./config.js";
import { crawl, write } from "./core.js";
import { createRequire } from "node:module";

const require = createRequire(import.meta.url);
const { version, description } = require("../../package.json");
import fs from 'fs';

const messages = {
  config: "What is the path of the configuration?",
  output: "What is the output path?"
};

async function handler(args: { config: fs.PathOrFileDescriptor; output: fs.PathOrFileDescriptor }) {
  let options = JSON.parse(
    fs.readFileSync(args.config, 'utf8'));

  options.outputFileName = args.output;

  try {
    const {
      url,
      match,
      matchToCrawl,
      maxPagesToCrawl: maxPagesToCrawlStr,
      waitForSelectorTimeout,
      selector,
      outputFileName,
    } = options;

    // @ts-ignore
    const maxPagesToCrawl = parseInt(maxPagesToCrawlStr, 10);

    let config: Config = {
      url,
      match,
      matchToCrawl,
      maxPagesToCrawl,
      waitForSelectorTimeout,
      selector,
      outputFileName,
    };

    await crawl(config);
    await write(config);
  } catch (error) {
    console.log(error);
  }
}

program.version(version).description(description);

program
.requiredOption("-c, --config <string>", messages.config)
.requiredOption("-o, --output <string>", messages.output)
.action(handler);

program.parse();
