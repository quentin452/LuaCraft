functionTags = {}

function addTagToFunction(func, tag)
	--_JPROFILER.push("addTagToFunction")
	functionTags[func] = functionTags[func] or {}
	table.insert(functionTags[func], tag)
	--_JPROFILER.pop("addTagToFunction")
end
function addTagToFunctionWithXYZ(func, tag, x, y, z)
	functionTags[func] = functionTags[func] or {}
	table.insert(functionTags[func], { tag = tag, param1 = x, param2 = y, param3 = z })
end
function getFunctionsByTag(tag)
	--_JPROFILER.push("getFunctionsByTag")
	local functionsWithTag = {}
	for func, tags in pairs(functionTags) do
		for _, t in ipairs(tags) do
			if t == tag then
				table.insert(functionsWithTag, func)
			end
		end
	end
	--_JPROFILER.pop("getFunctionsByTag")
	return functionsWithTag
end
function getFunctionsByTagWithXYZ(tag)
    local functionsWithTag = {}
    for func, tags in pairs(functionTags) do
        for _, t in ipairs(tags) do
            if t.tag == tag then
                table.insert(functionsWithTag, { func = func, params = { x = t.param1, y = t.param2, z = t.param3 } })
            end
        end
    end
    return functionsWithTag
end
