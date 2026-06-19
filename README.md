# Raspberry Pi Setup Guide

## Requirements
- OS: Ubuntu 22.04 Jammy
- Ros2 jazzy

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
source /opt/ros/jazzy/setup.bash
source install/setup.bash
```

##### ROS Gazebo run with empty world
```bash
ros2 launch articubot_one launch_sim.launch.py 
```

##### ROS Gazebo run with My World
```bash
ros2 launch articubot_one launch_sim.launch.py use_sim_time:=true
```
##### Launch rviz for noraml
```bash
rviz2 -d src/articubot_one/config/map.rviz
```


##### Launch rviz for navigation
```bash
rviz2 -d src/articubot_one/config/nav.rviz
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

##### for slam
```bash
ros2 launch slam_toolbox online_async_launch.py slam_params_file:=/home/atharv/Desktop/dev_Ws/src/articubot_two/config/mapper_params_online_async.yaml
```

##### for localization
```bash
ros2 launch nav2_bringup localization_launch.py map:=/home/atharv/Desktop/dev_Ws/map_save.yaml params_file:=/home/atharv/Desktop/dev_Ws/src/articubot_two/config/nav2_params_clean.yaml use_sim_time:=true
```

##### for navigation
```bash
ros2 launch articubot_two navigation_launch.py params_file:=/home/atharv/Desktop/dev_Ws/src/articubot_two/config/nav2_params_clean.yaml use_sim_time:=true
```


## Run the Real Robot

##### Source it
```bash
cd ~/robot_ws
source /opt/ros/jazzy/setup.bash
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
