MAX_VELOCITY = 15
N_STEPS = 0
NUM_SENSORS = 24
LEFT_PROXIMITY_SENSORS = {1, 2, 3, 4, 5, 6, 7}
PROXIMITY_THRESHOLD = 0.20

SPONTANEOUS_WALKING_PROB = 0.1
SPONTANEOUS_STOPPING_PROB = 0.01
MAX_STOPPPING_PROB = 0.99
MIN_WALKING_PROB = 0.005
ALFA = 0.1
BETA = 0.05
MAX_RANGE = 35

IS_MOVING = TRUE

-- The lowest layer that is executed only if there are no obstacles
--  and no light source is detected
function randomWalkLayer()
	robot.wheels.set_velocity(robot.random.uniform(0,MAX_VELOCITY), robot.random.uniform(0,MAX_VELOCITY))
end

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

function CountRAB()
    number_robot_sensed = 0
    for i = 1, #robot.range_and_bearing do
        -- for each robot seen, check if it is close enough.
        if robot.range_and_bearing[i].range < MAX_RANGE and robot.range_and_bearing[i].data[1]==1 then
            number_robot_sensed = number_robot_sensed + 1
        end
    end
    return number_robot_sensed
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
		if has_value(LEFT_PROXIMITY_SENSORS, sensor_with_max_proximity) then
			new_left_velocity = MAX_VELOCITY
			new_right_velocity = 0
		else
			new_left_velocity = 0
			new_right_velocity = MAX_VELOCITY
		end
		robot.wheels.set_velocity(new_left_velocity, new_right_velocity)
	else
		return randomWalkLayer()
	end
end

function aggregationLayer()
    N = CountRAB()
    t = robot.random.uniform()
    -- the robot is moving
    if IS_MOVING == true then
        STOPPING_PROB = math.min(MAX_STOPPPING_PROB, SPONTANEOUS_STOPPING_PROB + ALFA * N)
        if t <= STOPPING_PROB then
            IS_MOVING = false
            robot.range_and_bearing.set_data(1,1)
            robot.wheels.set_velocity(0, 0)
            robot.leds.set_all_colors("black")
        else
            IS_MOVING = true
            robot.range_and_bearing.set_data(1,0)
            robot.leds.set_all_colors("yellow")
            return obstacleAvoidanceLayer()
        end
    else -- the robot is stopped
        WALKING_PROB = math.max(MIN_WALKING_PROB, SPONTANEOUS_WALKING_PROB - BETA * N )
        if t <= WALKING_PROB then
            IS_MOVING = true
            robot.range_and_bearing.set_data(1,0)
            robot.leds.set_all_colors("yellow")
            return obstacleAvoidanceLayer()
        else
            IS_MOVING = false
            robot.range_and_bearing.set_data(1,1)
            robot.wheels.set_velocity(0, 0)
            robot.leds.set_all_colors("black")
        end
    end
end

function init()
    N_STEPS = 0
    robot.leds.set_all_colors("yellow")
    IS_MOVING = true
end

function step()
    N_STEPS = N_STEPS + 1
    aggregationLayer()
end

function reset()
    robot.wheels.set_velocity(0,0)
	N_STEPS = 0
end

function destroy()
end