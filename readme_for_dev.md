# Raspberry Pi Setup Guide

# System Requirements
- OS: Ubuntu 24.04 Jammy
- Ros2 jazzy

## Build your Workspace for devloper pc

Creating the directory
```bash
mkdir -p dev_ws/src
```

Cloning the project
```bash
cd ~/dev_ws/src
git clone https://github.com/attu0/articubot_two.git

```


# Run the project Simulation

##### Source it
```bash
cd ~/dev_ws
source /opt/ros/jazzy/setup.bash
source install/setup.bash
```

##### ROS Gazebo run with empty world
```bash
ros2 launch articubot_two launch_sim.launch.py use_sim_time:=true
```

##### ROS Gazebo run with My World
```bash
ros2 launch articubot_two launch_sim.launch.py use_sim_time:=true world:=src/articubot_two/worlds/world.world
```
##### Launch rviz for noraml
```bash
rviz2 -d src/articubot_two/config/main.rviz
```
##### Launch rviz for mapping
```bash
rviz2 -d src/articubot_two/config/map.rviz
```
##### Launch rviz for navigation
```bash
rviz2 -d src/articubot_two/config/nav.rviz
```

##### Control the Robot
```bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard --ros-args --remap cmd_vel:=/diff_cont/cmd_vel_unstamped
```

##### Mapping(SLAM)
```bash
ros2 launch articubot_two online_async_launch.py slam_params_file:=src/articubot_two/config/mapper_params_online_async.yaml
```

##### Localization
```bash
ros2 launch articubot_two localization_launch.py map:=src/articubot_two/map/map_save.yaml params_file:=src/articubot_two/config/nav2_params.yaml
```

##### Navigation
```bash
ros2 launch articubot_two navigation_launch_sim.py params_file:=src/articubot_two/config/nav2_params_sim.yaml use_sim_time:=true
```

##### One cmd
for only sim
```bash
cd src/articubot_two/scripts/ && ./sim_launch.sh
```
for sim slam
```bash
cd src/articubot_two/scripts/ && ./sim_launch_slam.sh
```