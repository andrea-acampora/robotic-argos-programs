# Motor Schemas

The solution of the exercise is based on the motor schemas architecture.

The behaviours involved are:

- *AvoidObstacleMotorSchema*
- *FollowTheLightMotorSchema*
- *RandomWalkMotorSchema*

Each motor schema is initiliazed as an empty vector (length = 0.0 and angle = 0.0) and then, depending on its internal perceptual schema it contributes to the resulting vector.
Every behaviour can only return the vector with length and angle or an empty vector.
Examples:
- If there isn't an obstacle near the robot AND it cannot see the light source the vector of these behaviours will be empty and in this case only the random walk motor schema will contribute to the result vector.
- If there's an obstacle OR if the robot can see the light source then the random walk motor schema will return an empty vector so it will not contribute to the result vector.
- If there is an obstacle AND the robot can see the light source then the 2 behaviours will both contribute to the result vector.

At every step, the 3 motor schemas are computed and then added to form the result vector necessary to compute left and right wheel velocities.

