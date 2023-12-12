# GPT Crawler

## Get started

### Running locally

#### Install dependencies

```sh
npm i
```

#### Configure the crawler

The crawler is configured by json files in the jsons folder

#### Run your crawler

```sh
bash crawl.sh {config path} {output path}
```

### Alternative methods

#### [Running in a container with Docker](./containerapp/README.md)

To obtain the `output.json` with a containerized execution. Go into the `containerapp` directory. Modify the `config.ts` same as above, the `output.json`file should be generated in the data folder. Note : the `outputFileName` property in the `config.ts` file in containerapp folder is configured to work with the container.
