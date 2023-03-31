MAX_VELOCITY = 15
PROXIMITY_THRESHOLD = 0.20
N_STEPS = 0
NUM_SENSORS = 24
FRONT_SENSORS = {1, 2, 3, 21, 22, 23, 24}
LEFT_SENSORS = {7, 8, 9, 10, 4, 5, 6}
RIGHT_SENSORS = {15, 16, 17, 18, 19, 20}
BACK_SENSORS = {11, 12, 13, 14}
LEFT_PROXIMITY_SENSORS = {1, 2, 3, 4, 5, 6, 7}

---  Utility function to search an element in a table
---@param tab table the table on which the elements is searched
---@param val number the searched value
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

-- The lowest layer that is executed only if there are no obstacles
--  and no light source is detected
function randomWalkLayer()
	log("Executing randomWalk layer..")
	robot.wheels.set_velocity(robot.random.uniform(0,MAX_VELOCITY), robot.random.uniform(0,MAX_VELOCITY))
end

-- The middle layer that is executed if no obstacle is detected near the footbot
function phototaxisLayer()
	max_light = 0
	sensor_with_max_light = 0
	for i=1,NUM_SENSORS do
		if robot.light[i].value > max_light then
			sensor_with_max_light = i
			max_light = robot.light[i].value
		end
	end
	if max_light > 0 then
		log("Executing phototaxis layer..")
		if has_value(FRONT_SENSORS, sensor_with_max_light) then
			new_left_velocity = MAX_VELOCITY
			new_right_velocity = MAX_VELOCITY
		elseif has_value(RIGHT_SENSORS, sensor_with_max_light) then
			new_left_velocity = MAX_VELOCITY
			new_right_velocity = 0
		elseif has_value(LEFT_SENSORS, sensor_with_max_light) then
			new_left_velocity = 0
			new_right_velocity = MAX_VELOCITY
		elseif has_value(BACK_SENSORS, sensor_with_max_light) then
			new_left_velocity = -MAX_VELOCITY
			new_right_velocity = -MAX_VELOCITY
		end
		robot.wheels.set_velocity(new_left_velocity, new_right_velocity)
	else
		return randomWalkLayer()
	end
end

-- The highest layer which is the first that is executed at every step.
function obstacleAvoidanceLayer()
	max_proximity = 0
	sensor_with_max_proximity = 0
	for i=1,NUM_SENSORS do
		if robot.proximity[i].value > max_proximity then
			sensor_with_max_proximity = i
			max_proximity = robot.proximity[i].value
		end
	end
	if (max_proximity > PROXIMITY_THRESHOLD) then
		log("Executing obstacleAvoidance layer..")
		if has_value(LEFT_PROXIMITY_SENSORS, sensor_with_max_proximity) then
			new_left_velocity = MAX_VELOCITY
			new_right_velocity = 0
		else
			new_left_velocity = 0
			new_right_velocity = MAX_VELOCITY
		end
		robot.wheels.set_velocity(new_left_velocity, new_right_velocity)
	else
		return phototaxisLayer()
	end
end

-- Initliaze the simulation
function init()
	N_STEPS = 0
end


-- At every step the highest layer is executed.
function step()
	N_STEPS = N_STEPS + 1
	obstacleAvoidanceLayer()
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
