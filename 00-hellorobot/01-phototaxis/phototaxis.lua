MOVE_STEPS = 15
MAX_VELOCITY = 10

N_STEPS = 0


function init()
	left_v = robot.random.uniform(0, MAX_VELOCITY)
	right_v = robot.random.uniform(0, MAX_VELOCITY)
	robot.wheels.set_velocity(left_v, right_v)
	N_STEPS = 0
end


function step()
	N_STEPS = N_STEPS + 1
	nord_light = robot.light[1].value + robot.light[24].value
	south_light = robot.light[12].value + robot.light[13].value
	east_light = robot.light[18].value + robot.light[19].value
	west_light = robot.light[6].value + robot.light[7].value
	max_light = math.max(nord_light, south_light, east_light, west_light)

	if N_STEPS % MOVE_STEPS == 0 then
		if nord_light  == max_light then
			goNord()
		end
		if south_light  == max_light then
			goSouth()
		end
		if east_light  == max_light then
			goEast()
		end
		if west_light  == max_light then
			goWest()
		end
	end

	function goNord()
		robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
	end

	function goSouth()
		robot.wheels.set_velocity(-MAX_VELOCITY, -MAX_VELOCITY)
	end

	function goEast()
		robot.wheels.set_velocity(MAX_VELOCITY, 0)
	end

	function goWest()
		robot.wheels.set_velocity(0, MAX_VELOCITY)
	end

end

function reset()
	left_v = robot.random.uniform(0, MAX_VELOCITY)
	right_v = robot.random.uniform(0, MAX_VELOCITY)
	robot.wheels.set_velocity(left_v, right_v)
	N_STEPS = 0
end


function destroy()
end
