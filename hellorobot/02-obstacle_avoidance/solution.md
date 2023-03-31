# Obstacle Avoidance

Similar to the phototaxis exercise the idea of the solution is to divide the proximity sensors into 4 zones: front, back, right and left.

At each step:
- the proximity of all sensors is calculated
- if the greatest proximity detected is lower than a pre-fixed threshold then it means that there's no obstaclethe robot will go randomly
- otherwise if the greatest proximity detected is higher than the threshold:
  - it is possible to obtain the position of the obstacle given the sensor with greater proximity.
  - given the position of the obstacle the robot will go in the opposite direction.
  - If the obstacle is in front of the robot then the robot will turn right trying to avoid it. 

The main issue of this solution is that if the robot is perfectly surrounded by obstacles in all directions then it could get stuck.