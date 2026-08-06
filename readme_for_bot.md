# System Requirements
- OS: Ubuntu 24.04 Jammy
- Ros2 jazzy

## Build your Workspace for raspberry pi

Creating the directory
```bash
mkdir -p robot_ws/src
```

Cloning the project
```bash
cd ~/robot_ws/src
git clone https://github.com/attu0/articubot_two.git
```

##### Colcon build
```bash
cd ~/dev_ws
colcon build --symlink-install
```

# Run the Real Robot

##### Source it
```bash
cd ~/robot_ws
source /opt/ros/jazzy/setup.bash
source install/setup.bash
```

#### Start Robot
```bash
ros2 launch articubot_two launch_robot.launch.py
```

##### Launch rviz
```bash
rviz2 -d src/articubot_two/config/main.rviz
```

##### Control the Robot
```bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard --ros-args -p stamped:=true -r cmd_vel:=/diff_cont/cmd_vel
```

##### Get Image feed
```bash
ros2 run rqt_image_view rqt_image_view
```
Set it to compressed for faster image, the image will be less detailed

##### Get Lidar feed
```bash
ros2 launch articubot_two rplidar.launch.py
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
ros2 launch articubot_two navigation_launch.py params_file:=src/articubot_two/config/nav2_params.yaml
```
