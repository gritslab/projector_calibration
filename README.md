Matlab Projector Optitrack Calibration
======================================

## To install

  * Navigate to your favorite Matlab folder
  * Clone the following repos

      `git clone https://github.com/gritslab/projector_calibration.git`

      `git clone https://github.com/gritslab/Matlab_TrackablePackage.git +trackable`

      `git clone https://github.com/gritslab/Matlab_QuaternionClass.git @quaternion`

## To calibrate

  * Setup Optitrack with a trackable, given some name say `T1`, and stream the data with VRPN.
  * Open Matlab and run

    `projectorFigCalibrate('T1','192.168.2.145');`

  * Follow the instructions in the Matlab command window.

## To test

  * To test the calibration run

    `projectorFigCalibrateTest('T1','192.168.2.145','projectorFigCalData.mat');`


## To plot

  * Create a figure with the following function command

    `projectorFigure(calibrationFile);`

  * Plot into this figure just like any other figure in Matlab.
