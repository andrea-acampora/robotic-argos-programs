# Phototaxis

The idea of the solution is to divide the light sensors into 4 zones: front, back, right and left.

At each step:
- the value of luminosity of all sensors is calculated
- if no sensor detected the light then the robot go randomly
- otherwise the robot will turn into the direction of the sensor with the highest luminosity

The main issue of this solution is that if the robot is very far from the light source then it may continue to go randomly in that area and never get to the source.