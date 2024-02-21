--
-- classic
--
-- Copyright (c) 2014, rxi
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
--

-- Create a new table for the Object class
local Object = {}
-- Set the metatable for the Object table to itself to allow inheritance
Object.__index = Object

-- Constructor function for creating a new Object instance
function Object:new()
end

-- Extend the Object class to create a subclass
function Object:extend()
  local cls = {}
  -- Copy the functions from the parent class to the subclass
  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end

-- Implement interface methods from one or more classes into the current class
function Object:implement(...)
  for _, cls in pairs({...}) do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == "function" then
        self[k] = v
      end
    end
  end
end

-- Check if an object belongs to a specific class
function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end

-- Return a string representation of the object
function Object:__tostring()
  return "Object"
end

-- Call operator overload to create a new instance of the class
function Object:__call(...)
  local obj = setmetatable({}, self)
  obj:new(...)
  return obj
end

-- Return the Object class
return Object