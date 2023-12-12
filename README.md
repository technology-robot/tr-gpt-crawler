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

#### Running in a container with Docker

artifact_path="us-central1-docker.pkg.dev/technology-robot/aisha-for-product-recommendation/crawler:latest"
docker build . -t $artifact_path \
    --build-arg="CONF_JSON=jsons/rewe-2023-12-11.json" \
    --build-arg="OUTPUT_CSV_GCS=gs://tr-aisha/product-recommendation/sample-rewe/output.csv"

docker push $artifact_path

gcloud builds submit --tag=$artifact_path

gcloud run jobs create aisha-pd-crawl \
    --image=$artifact_path \
    --region=us-central1 \
    --vpc-connector=egress \
    --vpc-egress=all-traffic
