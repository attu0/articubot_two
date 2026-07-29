from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():

    madgwick_node = Node(
        package='imu_filter_madgwick',
        executable='imu_filter_madgwick_node',
        name='imu_filter_madgwick',
        output='screen',
        parameters=[{
            'use_mag': False,          # MPU6050 has no magnetometer
            'publish_tf': False,       # EKF/robot_localization handles TF, not this
            'world_frame': 'enu',      # ROS REP-103 convention
            'use_sim_time': False,     # physical robot, no /clock topic
            # gain/zeta control how fast the filter trusts accel over gyro.
            # Defaults are reasonable; lower gain = smoother but slower to
            # correct, higher gain = more responsive but noisier. Tune only
            # if orientation looks laggy or jittery once running.
            'gain': 0.1,
            'zeta': 0.0,
        }],
        remappings=[
            ('imu/data_raw', '/imu/data_raw'),
            ('imu/data', '/imu/data'),
        ],
    )

    return LaunchDescription([
        madgwick_node
    ])