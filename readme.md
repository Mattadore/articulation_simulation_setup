Setup notes:

Create a new catkin workspace, and place this repo inside the src directory.
Make sure to source the new repo AFTER ros hydro in your .bashrc

Go into setup_repos and run setupscript.sh (FROM INSIDE OF THE SETUP_REPOS FOLDER).

Go to the root of the workspace and attempt a catkin_make, and install any remaining dependencies that cause the make to fail.

This script changes a launch file in your pr2_moveit_config. A backup is saved, however, in the sensor_manager_backup folder.
If you need to restore it, simply replace the modified one with the backup.

This package ties together several other versions of several different packages to help create a working environment
for anyone wanting to work on the PR2 articulation simulation.

To start the simulation, use the command "roslaunch articulation_simulation start_simulation.launch"
To start the movement routines, use the command "roslaunch articulation_simulation start_movement.launch"

Implementation notes:
Main package that ties everything together is the movement routines kit.
For movement routines kit, several different nodes are launched together to allow for automatic bagfile generation.
These nodes all communicate over a "flowManager" topic that allows appropriate sequencing of events.

Adding Alvar tags:
Documentation for vr_track_alvar is contained within

The Alvar object can be changed by uploading a new URDF file, an appropriate controller, and adding references to its tags into vr_track_alvar,
as well as adding it to the launch file for the simulation.
