#!/bin/bash

# ============================================================
# Articubot Two - Simulation Launcher
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
WORKSPACE_DIR="$(cd "$PACKAGE_DIR/../.." && pwd)"

WORLD_FILE="$PACKAGE_DIR/worlds/world.world"
RVIZ_CONFIG="$PACKAGE_DIR/config/main.rviz"


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

    kill -INT "$SIM_PID" 2>/dev/null
    kill -INT "$RVIZ_PID" 2>/dev/null

    sleep 3

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

echo "Waiting 25 seconds for simulation to initialize..."

sleep 25


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


echo ""
echo "=============================================="
echo " Articubot Two Simulation Running"
echo "=============================================="
echo ""
echo "Teleop:"
echo ""
echo "ros2 run teleop_twist_keyboard teleop_twist_keyboard \\"
echo "  --ros-args \\"
echo "  --remap cmd_vel:=/diff_cont/cmd_vel_unstamped"
echo ""
echo "Press Ctrl+C to stop."
echo "=============================================="


wait