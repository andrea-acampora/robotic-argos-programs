MAX_VELOCITY = 15
PROXIMITY_THRESHOLD = 0.25
N_STEPS = 0
NUM_SENSORS = 24

FRONT_SENSORS = {1, 2, 3, 21, 22, 23, 24}
LEFT_SENSORS = {7, 8, 9, 10, 4, 5, 6}
RIGHT_SENSORS = {15, 16, 17, 18, 19, 20}
BACK_SENSORS = {11, 12, 13, 14}

---  Utility function to search an element in a table
---@param tab any the table on which the elements is searched
---@param val any the searched value
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end


local function goRandom()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
end

local function followTheLight()
	if has_value(FRONT_SENSORS, sensor_with_max_light) then
		robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
	elseif has_value(RIGHT_SENSORS, sensor_with_max_light) then
		robot.wheels.set_velocity(MAX_VELOCITY, 0)
	elseif has_value(LEFT_SENSORS, sensor_with_max_light) then
		robot.wheels.set_velocity(0, MAX_VELOCITY)
	elseif has_value(BACK_SENSORS, sensor_with_max_light) then
		robot.wheels.set_velocity(-MAX_VELOCITY, -MAX_VELOCITY)
	elseif sensor_with_max_light == 0 then
		goRandom()
	end
end

local function manageObstacleAvoidance()
	if has_value(FRONT_SENSORS, sensor_with_max_proximity) then
		log("Obstacle in front of me.. turning right!")
		robot.wheels.set_velocity(MAX_VELOCITY, 0)
	elseif has_value(RIGHT_SENSORS, sensor_with_max_proximity) then
		log("Obstacle on my right.. turning left!")
		robot.wheels.set_velocity(0, MAX_VELOCITY)
	elseif has_value(LEFT_SENSORS, sensor_with_max_proximity) then
		log("Obstacle on my left.. turning right!")
		robot.wheels.set_velocity(MAX_VELOCITY, 0)
	end
end

function init()
	N_STEPS = 0
end

function step()
	N_STEPS = N_STEPS + 1

	max_light = 0
	max_proximity = 0

	sensor_with_max_light = 0
	sensor_with_max_proximity = 0

	for i=1,NUM_SENSORS do
        if robot.light[i].value > max_light then
            sensor_with_max_light = i
            max_light = robot.light[i].value
        end
		if robot.proximity[i].value > max_proximity then
			sensor_with_max_proximity = i
			max_proximity = robot.proximity[i].value
		end
	end

	if max_proximity == 1 then
		log("Crash!")
	end

	if max_proximity < PROXIMITY_THRESHOLD then
		followTheLight()
	else
		manageObstacleAvoidance()
	end

end

function reset()
	robot.wheels.set_velocity(0,0)
	N_STEPS = 0
end

function destroy()
	x = robot.positioning.position.x
    y = robot.positioning.position.y
    d = math.sqrt((1-x)^2 + (-1-y)^2)
    log("distance: "..d)
end
