-- Queue data structure
local Queue = {}
Queue.__index = Queue

function Queue.new()
  local q = {
    front = {},
    back = {}
  }
  setmetatable(q, Queue)
  return q
end

function Queue:push(elem)
  table.insert(self.back, elem)
end

function Queue:pop()
  if #self.front == 0 then
      if #self.back == 0 then return nil end 
      while #self.back > 0 do
          table.insert(self.front, table.remove(self.back))
      end
  end

  return table.remove(self.front)
end

return Queue