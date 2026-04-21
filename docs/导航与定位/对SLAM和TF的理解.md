## 1.TF
- TF即transform，对于机器人来讲，TF树是机器人获取空间位置关系的重要系统
- TF树的本质是一个**带有时间戳的、动态的坐标系关系网络**，它确保了机器人系统中每一个部件（车身、传感器）以及机器人与环境（地图）之间的相对位置和朝向关系是清晰、一致且可追溯的。
## 2.SLAM
- 一个标准的SLAM TF树结构遵循 `map`→ `odom`→ `base_link`→ `sensor_link`的链条
	- map  即世界地图坐标系  是通过初始位姿来设置的（可以是手动，也可以是定位算法），是一个固定的坐标系
	- odom 即里程计坐标系  由里程计节点发布，这个节点是map节点的映射，是小车在运动后，认为自己出发点所在的位置
	- base_link 即底盘中心
	- sesor_link 即传感器安装的坐标系
### 2.1.`map`→ `odom`
- 这部分TF变换主要由定位算法（比如说amcl，slam_toolbox，gicp等）来发布，用来修正odom的误差，这种是低频的
	- 定位算法的原理本质上就是根据传感器的数据，算出来机器人在地图上的实际位置，然后反推`map`→ `odom`的误差，最后广播TF变换来修正误差
	- 每一种定位算法算机器人的绝对位置的方法都很不一样
		- amcl就是根据广撒点，根据概率来算出绝对位置
		- slam_toolbox基于图优化，简单来讲就是选取机器人经过的几个点作为观测点，并分析观测点周围的数据来分析当前的位置
		- GICP基于点云匹配，立志于让点云数据和地图数据完全一致，然后分析绝对位置

- 广播：就是通过前面的定位算法，来发布TF消息就可以
``` cpp

void SlamToolbox::publishTransformLoop(
  const double & transform_publish_period)
/*****************************************************************************/
{
  if (transform_publish_period == 0) {
    return;
  }

  rclcpp::Rate r(1.0 / transform_publish_period);
  while (rclcpp::ok()) {
    boost::this_thread::interruption_point();
    {
      boost::mutex::scoped_lock lock(map_to_odom_mutex_);
      rclcpp::Time scan_timestamp = scan_header.stamp;
      // Avoid publishing tf with initial 0.0 scan timestamp
      if (scan_timestamp.seconds() > 0.0 && !scan_header.frame_id.empty()) {
        geometry_msgs::msg::TransformStamped msg;
        msg.transform = tf2::toMsg(map_to_odom_);
        msg.child_frame_id = odom_frame_;
        msg.header.frame_id = map_frame_;
        if (restamp_tf_) {
          msg.header.stamp = now() + transform_timeout_;
        } else {
          msg.header.stamp = scan_timestamp + transform_timeout_;
        }
        tfB_->sendTransform(msg);
      }
    }
    r.sleep();
  }
}
```
### 2.2.`odom`→ `base_link`
- 这部分TF变化由`robot_localizition`或者是里程计源来高频发布，用来计算机器人相对于自认为的起点行走的距离
	- 如果直接由里程计源来发布，那就是直接就是积分编码器的数据来算出小车现在行走的距离，但是里程计打滑会造成误差
	- 如果通过`robot_localizition`来发布，就可以结合里程计直走很准和imu对于yaw角敏感的特点，把数据用协方差合理的揉在一起
### 2.3.`base_link`→ `sensor_link`
- 这部分是固定的，就是机器人各个传感器到底盘的距离
- 通常根据URDF或者TF广播直接设置