# Composite behaviour

The idea of this solution is to mix the solutions of both exercises and to make some adjustments to avoid the robot  getting stuck.

At each step:
- the proximity of all sensors is calculated
- the luminosity of all sensors is calculated
- if the greatest proximity detected is lower than a pre-fixed threshold then the robot will try to follow the light source like in the phototaxis exercise.
- otherwise if the greatest proximity detected is higher than the threshold then the robot has to manage the obstacle avoidance so it will turn right.

The adjustments made are:
- To avoid the robot to get stuck and so deadlock situations, now the robot can go only right or left.

The main issue of this solution is that if the robot is very far from the light source then it may continue to go randomly in that area and never get to the source.