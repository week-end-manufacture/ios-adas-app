<a name="readme-top"></a>


[![Activity][activity-shield]][activity-url]
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/week-end-manufacture/ios-adas-app">
    <img src="images/logo.png" alt="Logo" width="360" height="360">
  </a>

  <h3 align="center">ios-adas-app</h3>

  <p align="center">
    A deep learning for advanced driver assistance system application project!
    <br />
    <a href="https://github.com/week-end-manufacture/ios-adas-app"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://unluckystrike.com/projects/deep-learning-for-advanced-driver-assistance-system-applications">View Demo</a>
    ·
    <a href="https://github.com/week-end-manufacture/ios-adas-app/issues">Report Bug</a>
    ·
    <a href="https://github.com/Jweek-end-manufacture/ios-adas-app/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://unluckystrike.com/projects/deep-learning-for-advanced-driver-assistance-system-applications)

Through a deep learning model learned through a CNN (Convolution Neural Network), an input image input through a camera module of a mobile device is intended to implement a distance alarm from the vehicle in front of it and an alarm function when a lane is changed.

Here's why:
* The camera of the smartphone and Convolution Neural Network technology, which is mainly used to process images in deep learning, can be used in various fields
* The goal of this project is to implement the ability to process data entered through a mobile device, such as a black box, through a deep learning model to alert the driver

Conclusions:
* Through this project, it was possible to implement a mobile application by exporting a CNN model that detects a vehicle while driving to a mobile device
* When implemented through a deep learning model suitable for a mobile environment, sufficient data sets are required to implement the target function, and tests are specifically required in the actual environment to measure variables between function implementations
* When designed and implemented through object segmentation, it is judged that it will be easy to interact and interpret each object if its performance is valid in a mobile environment

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

* [![Swift][Swift]][Swift-url]
* [![Python][Python]][Python-url]
* [![Tensorflow][Tensorflow]][Tensorflow-url]
* [![C++][C++]][C++-url]
* [![OpenCV][OpenCV]][OpenCV-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple example steps.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.
* The Object Detection API, pycocotools, and TF Slim packages binding
  ```bash
  bash object_detection/dataset_tools/create_pycocotools_package.sh /tmp/pycocotools
  python setup.py sdist
  (cd slim && python setup.py sdist)
  ```
* Training on google cloud using TPU
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

* Training on google cloud using GPU
  * config.yaml
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
  * run
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

* Training on local using GPU
  ```bash
  python object_detection/model_main.py \
      --pipeline_config_path=${YOUR_LOCAL_PATH}/data/pipeline.config \
      --model_dir=${YOUR_LOCAL_PATH}/train/ \
      --num_train_steps=200000 \
      --sample_1_of_n_eval_examples=1 \
      --alsologtostderr
  ```

* Evaluating on google cloud
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

* Turn on tensorboard
  * google cloud.
    ```bash
    tensorboard --logdir=gs://${YOUR_GCS_BUCKET}/train
    ```

  * local.
    ```bash
    tensorboard --logdir=${YOUR_LOCAL_PATH}/train
      ```

### Installation

Perform the following procedure to install the required package.

1. Clone the repo
   ```sh
   git clone https://github.com/week-end-manufacture/ios-adas-app.git
   ```
2. Operating pb file generator
   ```bash
    python object_detection/export_tflite_ssd_graph.py \
    --pipeline_config_path=$CONFIG_FILE \
    --trained_checkpoint_prefix=$CHECKPOINT_PATH \
    --output_directory=$OUTPUT_DIR \
    --add_postprocessing_op=true
    ```
3. Bazeling to make tflite file
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

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

_For more examples, please refer to the [Documentation](https://unluckystrike.com/projects/deep-learning-for-advanced-driver-assistance-system-applications)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [x] Traning cnn model
- [x] Add object detection function
- [x] Add lane detection function

See the [open issues](https://github.com/week-end-manufacture/ios-adas-app/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/amazing-feature`)
3. Commit your Changes (`git commit -m 'feat: Add some amazing-feature'`)
* commit message
  ```git
  <type>[optional scope]: <description>
  
  [optional body]

  [optional footer(s)]
  ```
* commit type
  ```git
  - feat: a commit of the type feat introduces a new feature to the codebase
  - fix: a commit of the type fix patches a bug in your codebase
  ```
4. Push to the Branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

JO HYUK JUN - hyukzuny@gmail.com

Project Link: [https://github.com/week-end-manufacture/ios-adas-app](https://github.com/week-end-manufacture/ios-adas-app)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* > https://medium.com/tensorflow/training-and-serving-a-realtime-mobile-object-detector-in-30-minutes-with-cloud-tpus-b78971cf1193
* > https://towardsdatascience.com/3-steps-to-update-parameters-of-faster-r-cnn-ssd-models-in-tensorflow-object-detection-api-7eddb11273ed
* > https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md
* > https://blog.canapio.com/135
* > https://towardsdatascience.com/real-time-car-pedestrian-lane-detection-using-tensorflow-object-detection-api-and-an-ios-fbb1b7cbb157
* > https://medium.com/@junjiwatanabe/how-to-build-real-time-object-recognition-ios-app-ca85c193865a
* > https://medium.com/onfido-tech/building-a-simple-lane-detection-ios-app-using-opencv-4f70d8a6e6bc

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/week-end-manufacture/ios-adas-app.svg?style=for-the-badge
[contributors-url]: https://github.com/week-end-manufacture/ios-adas-app/graphs/contributors
[activity-shield]: https://img.shields.io/github/commit-activity/m/week-end-manufacture/ios-adas-app.svg?style=for-the-badge
[activity-url]: https://github.com/week-end-manufacture/ios-adas-app/pulse
[forks-shield]: https://img.shields.io/github/forks/week-end-manufacture/ios-adas-app.svg?style=for-the-badge
[forks-url]: https://github.com/week-end-manufacture/ios-adas-app/network/members
[stars-shield]: https://img.shields.io/github/stars/week-end-manufacture/ios-adas-app.svg?style=for-the-badge
[stars-url]: https://github.com/week-end-manufacture/ios-adas-app/stargazers
[issues-shield]: https://img.shields.io/github/issues/week-end-manufacture/ios-adas-app.svg?style=for-the-badge
[issues-url]: https://github.com/week-end-manufacture/ios-adas-app/issues
[license-shield]: https://img.shields.io/github/license/week-end-manufacture/ios-adas-app.svg?style=for-the-badge
[license-url]: https://github.com/week-end-manufacture/ios-adas-app/blob/master/LICENSE
[product-screenshot]: images/screenshot.png
[Tensorflow]: https://img.shields.io/badge/tensorflow-000000?style=for-the-badge&logo=tensorflow&logoColor=white
[Tensorflow-url]: https://www.tensorflow.org/
[OpenCV]: https://img.shields.io/badge/opencv-000000?style=for-the-badge&logo=opencv&logoColor=white
[OpenCV-url]: https://opencv.org
[Swift]: https://img.shields.io/badge/swift-000000?style=for-the-badge&logo=swift&logoColor=white
[Swift-url]: https://developer.apple.com/swift/
[C++]: https://img.shields.io/badge/cpp-000000?style=for-the-badge&logo=cpp&logoColor=white
[C++-url]: https://learn.microsoft.com/ko-kr/cpp/cpp/welcome-back-to-cpp-modern-cpp?view=msvc-170
[Python]: https://img.shields.io/badge/python-000000?style=for-the-badge&logo=python&logoColor=white
[Python-url]: https://www.python.org