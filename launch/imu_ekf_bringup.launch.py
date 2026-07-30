import os

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():

    package_name = 'articubot_two'

    ekf_config = os.path.join(
        get_package_share_directory(package_name),
        'config',
        'ekf_real.yaml'
    )

    # --- 1. MPU6050 raw driver ---
    # Publishes /imu/data_raw. Runs its ~4s stationary bias calibration on
    # startup — keep the robot still until you see the "Calibration done"
    # log line before the robot starts moving.
    imu_raw_node = Node(
        package='imu_raw',
        executable='mpu6050_publisher',
        name='mpu6050_publisher',
        output='screen',
    )

    # --- 2. Madgwick filter ---
    # Converts /imu/data_raw -> /imu/data with a real orientation quaternion.
    madgwick_node = Node(
        package='imu_filter_madgwick',
        executable='imu_filter_madgwick_node',
        name='imu_filter_madgwick',
        output='screen',
        parameters=[{
            'use_mag': False,
            'publish_tf': False,       # ekf_node owns TF, not this
            'world_frame': 'enu',
            'use_sim_time': False,
            'gain': 0.1,
            'zeta': 0.0,
        }],
        remappings=[
            ('imu/data_raw', '/imu/data_raw'),
            ('imu/data', '/imu/data'),
        ],
    )

    # --- 3. EKF ---
    # Fuses /odom (wheel) + /imu/data (filtered IMU) into /odometry/filtered.
    ekf_node = Node(
        package='robot_localization',
        executable='ekf_node',
        name='ekf_filter_node',
        output='screen',
        parameters=[ekf_config, {'use_sim_time': False}],
        respawn=True,
        respawn_delay=2.0,
    )

    return LaunchDescription([
        imu_raw_node,
        madgwick_node,
        ekf_node,
    ])
