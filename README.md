# Brain Tumor Detection Using MRI Image Processing

Identifying brain tumors is a crucial challenge in medicine, given the complexity of the brain and the importance of early detection to improve treatments. This study proposes an approach based on MRI image processing techniques to automatically detect and analyze brain tumors through a four-step pipeline: pre-processing to improve visual quality, skull removal (skull stripping) to isolate brain tissue, segmentation of tumor areas, and feature extraction by testural analysis based on the gray-level co-occurrence matrix (GLCM). The results show high accuracy in segmentation and characterization of tumors, distinguishing between benign and malignant forms. The system, tested on MRI images in axial, coronal and sagittal views, proved to be an effective diagnostic aid, reducing the margin of error compared with traditional methods.
## Overview

The project focuses on the following stages:
- **Preprocessing**: Enhances the quality of MRI images through sharpening, noise reduction, and contrast adjustment.
- **Skull Stripping**: Isolates the brain by removing irrelevant skull structures.
- **Segmentation**: Identifies tumor regions using binary thresholding and morphological operations.
- **Feature Extraction**: Calculates texture-based metrics, including contrast, correlation, entropy, energy, and homogeneity, using the Gray Level Co-occurrence Matrix (GLCM).

These methods aim to reduce human error and support medical professionals in tumor detection and classification.

## Repository Structure

- `scripts/`: Contains MATLAB scripts for each stage of the pipeline:
  - `preprocessing.m`: Image enhancement and noise reduction.
  - `skull_stripping.m`: Skull removal and brain isolation.
  - `segmentation.m`: Tumor detection and segmentation.
  - `feature_extraction.m`: GLCM-based feature analysis.
- `README.md`: Documentation for the repository.

## Prerequisites

- MATLAB R2020a or later
- Image Processing Toolbox
