# Raspberry Pi Setup Guide

## Requirements
- OS: Ubuntu 22.04 Jammy
- Ros2 Humble

## Build your Workspace for devloper pc

Creating the directory
```bash
mkdir -p dev_ws/src
```

Cloning the project
```bash
cd ~/dev_ws/src
git clone https://github.com/attu0/articubot_one.git

```

## Build your Workspace for raspberry pi

Creating the directory
```bash
mkdir -p robot_ws/src
```

Cloning the project
```bash
cd ~/robot_ws/src
git clone https://github.com/attu0/articubot_one.git

```

##### Colcon build
```bash
cd ~/dev_ws
colcon build --symlink-install

```

## Run the project Simulation

##### Source it
```bash
cd ~/dev_ws
source /opt/ros/humble/setup.bash
source install/setup.bash
```

##### ROS Gazebo run with empty world
```bash
ros2 launch articubot_one launch_sim.launch.py 
```

##### ROS Gazebo run with My World
```bash
ros2 launch articubot_one launch_sim.launch.py world:=src/articubot_one/worlds/world.world 
```

##### Launch rviz
```bash
rviz2 -d src/articubot_one/config/main.rviz
```

##### Control the Robot
```bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard --ros-args --remap cmd_vel:=/diff_cont/cmd_vel_unstamped
```

##### Get Image feed
```bash
ros2 run rqt_image_view rqt_image_view
```

##### Get Lidar feed
```bash
ros2 launch articubot_one rplidar.launch.py
```

## Run the Real Robot

##### Source it
```bash
cd ~/robot_ws
source /opt/ros/humble/setup.bash
source install/setup.bash
```

#### Start Robot
```bash
ros2 launch articubot_one launch_robot.launch.py
```

##### Launch rviz
```bash
rviz2 -d src/articubot_one/config/main.rviz
```

##### Control the Robot
```bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard --ros-args --remap cmd_vel:=/diff_cont/cmd_vel_unstamped
```

##### Get Image feed
```bash
ros2 run rqt_image_view rqt_image_view
```

##### Get Lidar feed
```bash
ros2 launch articubot_one rplidar.launch.py
```
