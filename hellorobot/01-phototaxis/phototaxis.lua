MAX_VELOCITY = 10
N_STEPS = 0

FRONT_LIGHT_SENSORS = {1, 2, 3, 21, 22, 23, 24}
LEFT_LIGHT_SENSORS = {7, 8, 9, 10, 4, 5, 6}
RIGHT_LIGHT_SENSORS = {15, 16, 17, 18, 19, 20}
BACK_LIGHT_SENSORS = {11, 12, 13, 14}

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

local function goRandom()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
end

function init()
	N_STEPS = 0
end

function step()
	N_STEPS = N_STEPS + 1

	max_light = 0 -- If no light is detected from sensors than this value still remain to 0
	sensor_with_max_light = 0 -- the sensor which detect the highest luminosity
	for i=1,#robot.light do
        if robot.light[i].value > max_light then
            sensor_with_max_light = i
            max_light = robot.light[i].value
        end
	end

	-- Check the direction of the sensor with highest luminosity and make the footbot turn in that direction
	if has_value(FRONT_LIGHT_SENSORS, sensor_with_max_light) then
		robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
	elseif has_value(RIGHT_LIGHT_SENSORS, sensor_with_max_light) then
		robot.wheels.set_velocity(MAX_VELOCITY, 0)
	elseif has_value(LEFT_LIGHT_SENSORS, sensor_with_max_light) then
		robot.wheels.set_velocity(0, MAX_VELOCITY)
	elseif has_value(BACK_LIGHT_SENSORS, sensor_with_max_light) then
		robot.wheels.set_velocity(-MAX_VELOCITY, -MAX_VELOCITY)
	elseif sensor_with_max_light == 0 then -- If no light is detected than the robot go randomly
		goRandom()
	end

end

function reset()
	robot.wheels.set_velocity(0, 0)
	N_STEPS = 0
end

function destroy()
end
