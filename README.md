# Stroke Rehabilitation Exoskeleton
## Overview
Exoskeleton's can be used to support reptitive motions used in rehabilitation. For the project 
considering a low cost devlopment of an exoskeleton for such tasks the supporting code (found in 
this repository) can be split into the code to run the exoskeleton, code to test the exoskeleton 
and code to perform analysis on exoskeleton performance.
## Installation
The exoskeleton is controlled by an Arduino Nano Every microcontroller so to run the code it is 
necessary to have the Arduino IDE with the Arduino megaAVR Boards package installed. For an 
exoskeleton that has not been used before ExoProjTestCode.ino should be downloaded and then loaded
to the board before normal use. It is key that the the exoskeleton is free to move during this test.
The expected motion is shown in the 'Testing' section. Once the exoskeleton has shown the expected 
performance 3rdYearProjCode.ino can be loaded to the board. 

To run the analysis code a python interpreter must be installed with the imutils, argparse, time and
cv2 libraries also installed. The program is run from the command line - see 'Analysis' section for
more details. To analyse the outputs of the python code the matlab file  (used with 2023a or later)
is provided
## How to Run the Code
### New exoskeleton testing
The ExoProjTestCode.ino file is simply loaded into the Arduino IDE, an Arduino Nano Every (on the
exoskeleton) is connected with a USB-B cable. The code is then uploarded to the board and power 
provided to the exoskeleton via the DC power socket - both indicating LEDs should now be lit. If no 
motion is seen then the throw switch should be flicked and the reset button pressed on the Arduino 
board.

The code is designed for use from the exoskeleton being fully extended and will move up and down
in the full range of motion before allowing for button control to be used. Once the arm has moved
through it's full range of motion test the button control and ensure it moves using this. The video
below shows the expected sequence of events:
### Normal function
The 3rdYearProjCode.ino is loaded to the Arduino Nano Every board as for ExoProjTestCode.ino. Once 
power is provided to the exoskeleton (both LEDs lit) motion of the arm can then be controlled with the
controller. The video below shows and exoskeleton in action:
### Motion Analysis
Videos take of the exoskeleton in action can be analaysed with object tracking software. Videos must
be taken with the camera parallel to the users arm for optimal output. The analysis is performed from
the command line. Navigate to the folder that holds the python file and enter:
>> python videoTracking3rdYearProj.py --video \videoPath\video.mp4 --tracker MEDIANFLOW

\videoPath\vido.mp4 should be replaced with the path to your video. MEDIANFLOW is the tracker type 
that has worked best with test videos but MIL, TLD, BOOSTING and CSRT are all accepted inputs. You 
will then have to select the object to track - use the hand/controller as the end effector and select
this:

To analyse the output of the object run the generatePlots.m file. This will produce the position plot
and estimations velocity when the length of the video and user's forearm length are inputted. Example
inputs (for the video in 'Normal Function' above) are {VIDEO LENGTH} and {FOREARM LENGTH} giving the 
outputs:

## Added Technical Details
Velocity estimation uses the l = r*\theta equation and v = s/t. A 1D median filter (from a Matlab 
library) is then applied to smooth the curve slightly.

## Future Improvements
