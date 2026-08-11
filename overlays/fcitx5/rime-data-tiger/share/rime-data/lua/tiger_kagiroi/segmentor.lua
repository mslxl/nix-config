-- Keep the whole raw alphabetic input in one segment. This prevents the
-- ordinary abc segmentor from splitting long romaji at Tiger code boundaries.
local M = {}

function M.func(segmentation, env)
  local start = segmentation:get_current_start_position()
  local input = segmentation.input
  if start >= #input then
    return true
  end
  local remaining = input:sub(start + 1)
  if not remaining:match("^[a-z]+$") then
    return true
  end
  local segment = Segment(start, #input)
  segment.tags = Set({ "abc", "tiger_kagiroi" })
  segmentation:add_segment(segment)
  segmentation:forward()
  return false
end

return M
