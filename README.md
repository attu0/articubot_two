<div align="center">

![articubot_two](media/main.png)

# Beam articubot two V2
### Autonomous Precision Agricultural Robot | ROS2 + MoveIt2 + Nav2

[![ROS2](https://img.shields.io/badge/ROS2-Jazzy-blue)](https://docs.ros.org/en/jazzy/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

</div>

---

## Overview

---


## System Architecture

The articubot two V2 is built as a multi-package ROS2 workspace:

```
beam_articubot two_v2/
├── config/         → Nav2 config, SLAM, AMCL, rviz, yaml
├── description/    → URDF/Xacro
├── launch/         → sim, robot, rplidar, slam, amcl, rsp, camera, localization
├── map/            → map
├── media/          → screenshots, GIFs
└── meshes/         → stl files
└── scripts/        → bash files
└── worlds/         → sim worlds
```
---

## Hardware Design

<div align="center">

![Farm Operation](media/real_bot.png)

</div>

The articubot two chassis was designed from scratch in Fusion 360

**Key design decisions:**

- **Differential drive** — 2 large centre drive wheels + 1 front caster roller + 1 rear caster roller.

---

## Simulation

<div align="center">

![RViz LiDAR](media/sim_bot.png)

</div>

**Autonomous Navigation (Nav2)**

![Nav2 Demo](media/nav2.gif)

The robot uses SLAM Toolbox to build a map of the environment on the first run. On subsequent runs, Nav2 localizes using AMCL against the saved map and navigates to waypoints autonomously. The costmap inflates around obstacles to ensure the chassis and arm clear all objects during navigation.

---

## Software Stack

| Component | Technology |
|---|---|
| Framework | ROS2 Humble |
| Simulation | Gazebo Classic |
| Navigation | Nav2 + AMCL |
| Mapping | SLAM Toolbox |
| Motion Planning | OMPL |
| Robot Description | URDF + Xacro |
| Control | ros2_control + diff_drive_controller |

---

## Getting Started

**Prerequisites:**
- Ubuntu 24.04
- ROS2 Jazzy
- Gazebo jetty
- Nav2 Jazzy

**Build:**
```bash
git clone https://github.com/xaatim/Beam-articubot two-V2.git
cd Beam-articubot two-V2
rosdep install --from-paths src --ignore-src -r -y
colcon build
source install/setup.bash
```

**Launch simulation:**
```bash
# Launch Gazebo world with robot
ros2 launch robot_description gazebo.launch.py

# Launch Nav2 with saved map
ros2 launch robot_navigation navigation.launch.py

# Launch MoveIt2
ros2 launch moveit_config moveit.launch.py

# Launch crop detection
ros2 run robot_vision crop_detector_node
```

**Launch using bash:**
```bash
#gazebo and Rviz 
cd src/articubot_two/scripts && ./launch_sim.bash

---

## Beam Robotics Ecosystem

The articubot two V2 is registered and monitored through the **Beam Command Center** — a centralized platform for managing all Beam Robotics products. Each unit is paired via a cryptographic serial key and streams operational data including camera feed, watering logs, water level, battery health, and location to the operator dashboard.

**Other Beam Robotics products:**
- [Smart Agricultural Robot V1](https://github.com/xaatim/Smart-Agricultural-Robot) — field-tested precision dosing prototype
- [Beam Access Control System](https://github.com/xaatim/SmartAccessControl) — biometric access, license plate recognition, surveillance
- [Beam Surveillance Bot](https://github.com/xaatim/Autonomous_security_robot) — autonomous patrol robot with face recognition

---

## Author

**Atharv Mahesh Mudse**

---

*Licensed under the MIT License*