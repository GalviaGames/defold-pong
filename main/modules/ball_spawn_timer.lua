local M = {}

function M.new(delay, ball_pos)
    local currentId = 0

    local state = {
        balls = {},
    }

    local function spawn_ball()
        currentId = currentId + 1
        state.balls[currentId] = factory.create("ball_factory#factory", ball_pos, nil, { ball_id = currentId })
    end

    state.start = function()
        if state.timer ~= nil then
            timer.cancel(state.timer)
        end
        spawn_ball()
        state.timer = timer.delay(delay, true, spawn_ball)
    end

    state.out_of_bounds = function(ball_id)
        if state.balls[ball_id] ~= nil then
            go.delete(state.balls[ball_id])
            state.balls[ball_id] = nil
        end
    end

    state.cancel = function()
        if state.timer ~= nil then
            timer.cancel(state.timer)
            state.timer = nil
        end

        for _, ball in pairs(state.balls) do
            go.delete(ball)
        end
        state.balls = {}
    end

    return state
end

return M
