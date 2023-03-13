MAX_VELOCITY = 10
PROXIMITY_THRESHOLD = 0.10
N_STEPS = 0

FRONT_PROXIMITY_SENSORS = {1, 2, 3, 21, 22, 23, 24}
LEFT_PROXIMITY_SENSORS = {7, 8, 9, 10, 4, 5, 6}
RIGHT_PROXIMITY_SENSORS = {15, 16, 17, 18, 19, 20}
BACK_PROXIMITY_SENSORS = {11, 12, 13, 14}

---  Utility function to search an element in an
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

function init()
	N_STEPS = 0
end

function step()
	N_STEPS = N_STEPS + 1
	max_proximity = 0
	sensor_with_max_proximity = 0

	for i = 1, #robot.proximity do
		if robot.proximity[i].value > max_proximity then
			sensor_with_max_proximity = i
			max_proximity = robot.proximity[i].value
		end
	end

	if max_proximity == 1 then
		log("Crash!")
	end

	if max_proximity > PROXIMITY_THRESHOLD then
		if has_value(FRONT_PROXIMITY_SENSORS, sensor_with_max_proximity) then
			log("Obstacle in front of me.. turning right!")
			robot.wheels.set_velocity(MAX_VELOCITY, 0)
		elseif has_value(RIGHT_PROXIMITY_SENSORS, sensor_with_max_proximity) then
			log("Obstacle on my right.. turning left!")
			robot.wheels.set_velocity(0, MAX_VELOCITY)
		elseif has_value(LEFT_PROXIMITY_SENSORS, sensor_with_max_proximity) then
			log("Obstacle on my left.. turning right!")
			robot.wheels.set_velocity(MAX_VELOCITY, 0)
		elseif has_value(BACK_PROXIMITY_SENSORS, sensor_with_max_proximity) then
			log("Obstacle on my back.. going straight!")
			robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
		end

	else
		log("No obstacle near me.. moving randomly")
		left_v = robot.random.uniform(0, MAX_VELOCITY)
		right_v = robot.random.uniform(0,MAX_VELOCITY)
		robot.wheels.set_velocity(left_v, right_v)
	end
end

function reset()
	robot.wheels.set_velocity(0, 0)
	N_STEPS = 0
end

function destroy()
end
