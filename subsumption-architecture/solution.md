# Subsumption architecture

The subsumption architecture of the solution is composed by 3 layers:

1. RandomWalkLayer (lowest layer)
2. PhototaxisLayer (middle layer)
3. ObstacleAvoidanceLayer (highest layer)

At every step the highest layer is executed.
If there are obstacles then it will compute the velocity otherwise it will call the lower layer (phototaxis layer).
In the same way, if the light source is detected then the velocity is computed otherwise it send the randomWalk layer in execution.
In this way, if we want to add a layer we can simply create a new function that at the end calls the previous highest layer and in the step function we have to call the new highest layer.

The logic of the layers is the same as the previous solutions (00-hellorobot folder).