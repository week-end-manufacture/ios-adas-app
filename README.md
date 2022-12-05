# ios-adas-app
### Deep Learning for Advanced Driver Assistance System Application

<br>
<br>

<br>
<br>

## The Object Detection API, pycocotools, and TF Slim packages binding.
```bash
bash object_detection/dataset_tools/create_pycocotools_package.sh /tmp/pycocotools
python setup.py sdist
(cd slim && python setup.py sdist)
```

<br>
<br>

## Training on google cloud using TPU.
- runtime version: 1.4 이상일 경우 python 3 사용 기본적으로 python 2.7 사용
주의해서 사용해야한다. mobilenet v1 은 python 2.7로 가능하지만 mobilenet v2 는 python 3 이상 에서 실행해야한다.
- [Detail Info](https://cloud.google.com/ml-engine/docs/tensorflow/environment-overview?hl=ko)


```bash
gcloud ml-engine jobs submit training `whoami`_object_detection_`date +%s` \
--job-dir=gs://${YOUR_GCS_BUCKET}/train \
--packages dist/object_detection-0.1.tar.gz,slim/dist/slim-0.1.tar.gz,/tmp/pycocotools/pycocotools-2.0.tar.gz \
--module-name object_detection.model_tpu_main \
--runtime-version 1.13 \
--scale-tier BASIC_TPU \
--region us-central1 \
-- \
--model_dir=gs://${YOUR_GCS_BUCKET}/train \
--tpu_zone us-central1 \
--pipeline_config_path=gs://${YOUR_GCS_BUCKET}/data/pipeline.config
```

<br>
<br>

## Training on google cloud using GPU.
- config.yaml 파일을 생성해야한다.

```vi
trainingInput:
  scaleTier: CUSTOM
  # Configure a master worker with 4 K80 GPUs
  masterType: complex_model_m_gpu
  # Configure 9 workers, each with 4 K80 GPUs
  workerCount: 9
  workerType: complex_model_m_gpu
  # Configure 3 parameter servers with no GPUs
  parameterServerCount: 3
  parameterServerType: large_model
```

<br>

```bash
gcloud ml-engine jobs submit training object_detection_`date +%m_%d_%Y_%H_%M_%S` \
    --python-version 3.5 \
    --runtime-version 1.13 \
    --job-dir=gs://${YOUR_GCS_BUCKET}/train \
    --packages dist/object_detection-0.1.tar.gz,slim/dist/slim-0.1.tar.gz,/tmp/pycocotools/pycocotools-2.0.tar.gz \
    --module-name object_detection.model_main \
    --region us-central1 \
    --config /tmp/config.yaml \
    -- \
    --model_dir=gs://${YOUR_GCS_BUCKET}/train \
    --pipeline_config_path=gs://${YOUR_GCS_BUCKET}/data/pipeline.config
```

<br>
<br>

## Training on local using GPU.

```bash
python object_detection/model_main.py \
    --pipeline_config_path=${YOUR_LOCAL_PATH}/data/pipeline.config \
    --model_dir=${YOUR_LOCAL_PATH}/train/ \
    --num_train_steps=200000 \
    --sample_1_of_n_eval_examples=1 \
    --alsologtostderr
```

<br>
<br>

## Evaluating on google cloud.

```bash
gcloud ml-engine jobs submit training `whoami`_object_detection_eval_validation_`date +%s` \
--job-dir=gs://${YOUR_GCS_BUCKET}/train \
--packages dist/object_detection-0.1.tar.gz,slim/dist/slim-0.1.tar.gz,/tmp/pycocotools/pycocotools-2.0.tar.gz \
--module-name object_detection.model_main \
--runtime-version 1.13 \
--scale-tier BASIC_GPU \
--region us-central1 \
-- \
--model_dir=gs://${YOUR_GCS_BUCKET}/train \
--pipeline_config_path=gs://${YOUR_GCS_BUCKET}/data/pipeline.config \
--checkpoint_dir=ggs://${YOUR_GCS_BUCKET}/train

```

<br>
<br>

## Turn on tensorboard.
- google cloud.
```bash
tensorboard --logdir=gs://${YOUR_GCS_BUCKET}/train
```

<br>

- local.
```bash
tensorboard --logdir=${YOUR_LOCAL_PATH}/train
```

<br>
<br>

## Operating pb file generator.
```bash
python object_detection/export_tflite_ssd_graph.py \
--pipeline_config_path=$CONFIG_FILE \
--trained_checkpoint_prefix=$CHECKPOINT_PATH \
--output_directory=$OUTPUT_DIR \
--add_postprocessing_op=true
```

<br>
<br>

## Bazeling to make tflite file.

```bash
bazel run -c opt tensorflow/lite/toco:toco -- \
--input_file=$OUTPUT_DIR/tflite_graph.pb \
--output_file=$OUTPUT_DIR/detect.tflite \
--input_shapes=1,300,300,3 \
--input_arrays=normalized_input_image_tensor \
--output_arrays='TFLite_Detection_PostProcess','TFLite_Detection_PostProcess:1','TFLite_Detection_PostProcess:2','TFLite_Detection_PostProcess:3'  \
--inference_type=QUANTIZED_UINT8 \
--mean_values=128 \
--std_values=128 \
--change_concat_input_ranges=false \
--allow_custom_ops
```

<br>
<br>

## Reference.
> https://medium.com/tensorflow/training-and-serving-a-realtime-mobile-object-detector-in-30-minutes-with-cloud-tpus-b78971cf1193


> https://towardsdatascience.com/3-steps-to-update-parameters-of-faster-r-cnn-ssd-models-in-tensorflow-object-detection-api-7eddb11273ed


> https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md


> https://blog.canapio.com/135


> https://towardsdatascience.com/real-time-car-pedestrian-lane-detection-using-tensorflow-object-detection-api-and-an-ios-fbb1b7cbb157


> https://medium.com/@junjiwatanabe/how-to-build-real-time-object-recognition-ios-app-ca85c193865a


> https://medium.com/onfido-tech/building-a-simple-lane-detection-ios-app-using-opencv-4f70d8a6e6bc