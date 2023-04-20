# Swarm Robotics

The general idea of the solution is to use the *Subsumption Architecture* as the main control architecture of the footbot and to add an **Aggregation Layer** with maximum priority.

The aggregation layer is responsible to calculate the walking or stopping probability depending on the robot current state.
If the robot doesn't have to aggregate with other robot then it will call the *ObstacleAvoidance Layer* with the same behavoiur as the previous exercises.

