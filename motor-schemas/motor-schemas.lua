MAX_VELOCITY = 15

PROXIMITY_THRESHOLD = 0.20
LIGHT_THRESHOLD = 0.01

N_STEPS = 0
EMPTY_VECTOR = {length = 0.0, angle =  0.0}

local vector = require "vector"


function avoidObstacleMotorSchema()
	v = EMPTY_VECTOR
	proximity, proximity_angle = obstaclePerceptualSchema()
	if (proximity > PROXIMITY_THRESHOLD) then
		v.angle = (-(proximity_angle/math.abs(proximity_angle))*math.pi + proximity_angle)
		v.length = v.length
	end
	return v
end

function followTheLightMotorSchema()
	v = EMPTY_VECTOR
	light, light_angle = lightPerceptualSchema()
	if (light > LIGHT_THRESHOLD) then
		v.angle = light_angle
		v.length = 1 - light
	end
	return v
end

function randomWalkMotorSchema()
	v = EMPTY_VECTOR
	proximity, _ = obstaclePerceptualSchema()
	light, _ = lightPerceptualSchema()
	if (proximity < PROXIMITY_THRESHOLD ) and (light < LIGHT_THRESHOLD) then
		v.length, v.angle = randomWalkPerceptualSchema()
	end
	return v
end

function lightPerceptualSchema()
	max_light = 0
	sensor_with_max_light = 0
	for i=1,#robot.light do
        if robot.light[i].value > max_light then
            sensor_with_max_light = i
            max_light = robot.light[i].value
       
		end
	end
	if max_light >= LIGHT_THRESHOLD then
		return max_light, robot.light[sensor_with_max_light].angle
	else
		return 0.0, 0.0
	end
end

function obstaclePerceptualSchema()
	max_proximity = 0
	sensor_with_max_proximity = 0
	for i=1,#robot.proximity do
        if robot.proximity[i].value > max_proximity then
            sensor_with_max_proximity = i
            max_proximity = robot.proximity[i].value
        end
	end
	if max_proximity >= PROXIMITY_THRESHOLD then
		return max_proximity, robot.proximity[sensor_with_max_proximity].angle
	else
		return 0.0, 0.0
	end
end

function randomWalkPerceptualSchema()
	return 1, robot.random.uniform(-math.pi / 2, math.pi / 2)
end


-- Initliaze the simulation
function init()
	N_STEPS = 0
	L = robot.wheels.axis_length
end

-- Utility function to calculate left and right wheels velocities from translational and angular velocity
function calculateWheelVelocities(translational_velocity, angular_velocity)
	left_v = translational_velocity - L / 2 * angular_velocity
	right_v = translational_velocity + L / 2 * angular_velocity
	return left_v, right_v
end


function step()
	N_STEPS = N_STEPS + 1
	motor_schemas = {
		randomWalkMotorSchema(),
		followTheLightMotorSchema(),
		avoidObstacleMotorSchema()
	}
	vector_result = EMPTY_VECTOR
	for i = 1, #motor_schemas do 
		vector_result = vector.vec2_polar_sum(vector_result, motor_schemas[i])
	end
	left_v, right_v = calculateWheelVelocities(vector_result.length, vector_result.angle)
	robot.wheels.set_velocity(left_v, right_v)
end

-- Reset the simulation
function reset()
	robot.wheels.set_velocity(0,0)
	N_STEPS = 0
end

-- The distance between the 
function destroy()
	x = robot.positioning.position.x
    y = robot.positioning.position.y
    d = math.sqrt((1-x)^2 + (-1-y)^2)
    log("distance: "..d)
end
