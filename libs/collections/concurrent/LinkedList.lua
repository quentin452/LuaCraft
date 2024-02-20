-- Linked list implementation
LinkedList = {}

function LinkedList:new()
    local list = { first = nil, last = nil }
    setmetatable(list, self)
    self.__index = self
    return list
end

function LinkedList:pushFirst(value)
    local node = { value = value, next = nil, prev = nil }
    if not self.first then
        self.first = node
        self.last = node
    else
        node.next = self.first
        self.first.prev = node
        self.first = node
    end
end

function LinkedList:pushLast(value)
    local node = { value = value, next = nil, prev = nil }
    if not self.first then
        self.first = node
        self.last = node
    else
        self.last.next = node
        node.prev = self.last
        self.last = node
    end
end

function LinkedList:popFirst()
    if not self.first then return nil end
    local value = self.first.value
    if self.first == self.last then
        self.first = nil
        self.last = nil
    else
        self.first = self.first.next
        self.first.prev = nil
    end
    return value
end

function LinkedList:count()
    local count = 0
    local current = self.first
    while current do
        count = count + 1
        current = current.next
    end
    return count
end