from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():

    joy_node = Node(
        package="joy",
        executable="joy_node",
        name="joy_node",
        output="screen",
    )

    teleop_node = Node(
        package="teleop_twist_joy",
        executable="teleop_node",
        name="teleop_twist_joy",
        output="screen",
        remappings=[
            ("cmd_vel", "/diff_cont/cmd_vel_unstamped")
        ],
        parameters=[{
            "axis_linear.x": 1,
            "axis_angular.yaw": 0,
            "scale_linear.x": 0.5,
            "scale_angular.yaw": 1.0,
            "enable_button": 5
        }]
    )

    return LaunchDescription([
        joy_node,
        teleop_node
    ])