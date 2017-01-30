
declare -r PROJECT=$(gcloud config list project --format "value(core.project)")
declare -r JOB_ID="yelp_restaurant_photo_classification_$(date +%Y%m%d_%H%M%S)"
declare -r BUCKET="gs://yelp_restaurant_photo_classification"
declare -r GCS_PATH="${BUCKET}/yelp_restaurant_photo_classification"
declare -r DICT_FILE=gs://yelp_restaurant_photo_classification/labels/dict.txt

declare -r MODEL_NAME=yelp_classifier
declare -r VERSION_NAME=v1

echo
echo "Using job id: " $JOB_ID
set -v -e


gcloud beta ml jobs submit training "$JOB_ID" \
  --module-name trainer.task \
  --package-path /home/slalomconsultingsf/git/cloudml-samples/yelp_restaurant_photo_classification/trainer \
  --staging-bucket "$BUCKET" \
  --region us-central1 \
  -- \
  --output_path "${GCS_PATH}/training" \
  --eval_data_paths "${GCS_PATH}/preproc/eval*" \
  --train_data_paths "${GCS_PATH}/preproc/train*"

