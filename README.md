# Multifocal-Plane-Portrait-Mode
Multifocal Plane Portrait Mode pipeline with Lightfields
Course Project for EE367
![Cover Pic](https://github.com/AdityaDusi97/Multifocal-Plane-Portrait-Mode/blob/master/Final_Pic.png)

This pipeline was created for the course project for course EE 367: Computational Imaging and Display. Detailed report can be found here:
https://drive.google.com/drive/folders/1K5DvM4bD2LaJ8UOMW2sRa3Tgvkz88IcO?usp=sharing

# Requirements:
- MATLAB
- LFToolbox by D. G. Dansereau
- Lyto Illum with calibration data
- Lytro Desktop (Software to extract depth_map)

# Directory Structure:
LFToolBox: All the necessary functions are here

LFToolbox0.3_Samples1
- Cameras: Unique IDs of various cameras along with calibration data
- Images: All  .LFR images and depth maps are placed here
- Demo_*.m; * = {1,2,3}, demp scripts

Go to https://drive.google.com/drive/folders/15ysftRh__TdPL3BhTd19hCv6nD8UmUCc?usp=sharing and download the following folder in the same directory as LFToolBox and LFToolbox0.3_Samples1
More instructions on these are in the *LFToolBox.pdf* document.
Calibration: Calibration Data extracted from the Illum

# Instructions to run:
To demonstrate the working of this pipeline, I have provided 3 demo scripts- Demo_1.m, Demo_2.m & Demo_3.m

Here's how you run the code:
1. Open MATLAB. Make sure you are inside the LFToolBox0.3_Samples1 directory
2. In the MATLAB command line, run the following commands:
```
cd ../LFToolbox/
LFMatlabPathSetup
cd ../LFToolbox0.3_Samples1/
```
This sets up the path for LFToolbox. 

3. Download sample calibration data and images
Download load the following two directories and place them under LFToolbox0.3_Samples1/
- Cameras: Has camera calibration data
```
https://drive.google.com/drive/folders/1Kl4xOK2GKTqQj81ksxoliIt8KkAdx5OJ?usp=sharing
```
- Images: Sample raw and decoded .LFR images used in the demo
```
https://drive.google.com/drive/folders/1HABq45_mEhlmzDXvF0zo7gtLK1AFXb_q?usp=sharing
``` 

4. Run in MATLAB's terminal using the command
```
demo_1.m
```

** Using your own images **
The document titles *LFToolbox.pdf* by D. G. Dansereau has all the details about how to extract RAW lightfield data from the Illum. However, in the interest of the user, I will list the commands here. For camera calibration, please refer to the document mentioned earlier. From here on, I shall assume that the camera has been calibrated.

1. Capture the image in .LFR format using the Illum.
2. Place the .LFR file inside LFToolbox0.3_Samples1/Images/
3. Decode the raw lightfield image by running
```
LFUtilDecodeLytroFolder('Images/<Filename.LFR>')
```
in the MATLAB command line

4. Use Lytro Desktop to Extract the depth map. Place it in the same folder stated above 





