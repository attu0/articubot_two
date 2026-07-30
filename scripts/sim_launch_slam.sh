#!/bin/bash

# ============================================================
# Articubot Two - Simulation Launcher
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
WORKSPACE_DIR="$(cd "$PACKAGE_DIR/../.." && pwd)"

WORLD_FILE="$PACKAGE_DIR/worlds/world.world"
RVIZ_CONFIG="$PACKAGE_DIR/config/map.rviz"


# ============================================================
# Source ROS 2 and workspace
# ============================================================

source /opt/ros/jazzy/setup.bash

if [ ! -f "$WORKSPACE_DIR/install/setup.bash" ]; then
    echo "Workspace has not been built."
    echo ""
    echo "Run:"
    echo "  cd $WORKSPACE_DIR"
    echo "  colcon build --symlink-install"
    exit 1
fi

source "$WORKSPACE_DIR/install/setup.bash"


# ============================================================
# Cleanup
# ============================================================

cleanup() {
    echo ""
    echo "Cleaning up..."

    kill -INT "$SLAM_PID" 2>/dev/null
    kill -INT "$RVIZ_PID" 2>/dev/null
    kill -INT "$SIM_PID" 2>/dev/null

    wait "$SLAM_PID" 2>/dev/null
    wait "$RVIZ_PID" 2>/dev/null
    wait "$SIM_PID" 2>/dev/null

    echo "Simulation stopped."
    exit 0
}

trap cleanup SIGINT SIGTERM


# ============================================================
# Launch Simulation
# ============================================================

echo "Launching Gazebo simulation..."

ros2 launch articubot_two launch_sim.launch.py \
    use_sim_time:=true \
    world:="$WORLD_FILE" &

SIM_PID=$!


# ============================================================
# Wait for Gazebo
# ============================================================

echo "Waiting 10 seconds for simulation to initialize..."

sleep 10


# ============================================================
# Move Gazebo Camera
# ============================================================

echo "Adjusting camera position..."

gz service \
    -s /gui/move_to/pose \
    --reqtype gz.msgs.GUICamera \
    --reptype gz.msgs.Boolean \
    --timeout 2000 \
    --req "pose: {position: {x: 0.0, y: -2.0, z: 2.0} orientation: {x: -0.2706, y: 0.2706, z: 0.6533, w: 0.6533}}"


# ============================================================
# Launch RViz
# ============================================================

echo "Launching RViz..."

rviz2 \
    -d "$RVIZ_CONFIG" \
    --ros-args \
    -p use_sim_time:=true &

RVIZ_PID=$!

# ============================================================
# Launch SLAM
# ============================================================

echo "Launching SLAM..."

ros2 launch articubot_two online_async_launch.py \
    slam_params_file:="$PACKAGE_DIR/config/mapper_params_online_async.yaml" &

SLAM_PID=$!

# ============================================================
# Launch Teleop
# ============================================================

echo "Launching Teleop..."

gnome-terminal --title="Articubot Teleop" -- bash -c "
source /opt/ros/jazzy/setup.bash
source \"$WORKSPACE_DIR/install/setup.bash\"

ros2 run teleop_twist_keyboard teleop_twist_keyboard \
  --ros-args \
  --remap cmd_vel:=/diff_cont/cmd_vel_unstamped \
"

wait "$SIM_PID" "$RVIZ_PID" "$SLAM_PID"