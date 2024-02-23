functionTags = {}

function addTagToFunction(func, tag)
	--_JPROFILER.push("addTagToFunction")
	functionTags[func] = functionTags[func] or {}
	table.insert(functionTags[func], tag)
	--_JPROFILER.pop("addTagToFunction")
end

function getFunctionsByTag(tag)
	_JPROFILER.push("getFunctionsByTag")
	local functionsWithTag = {}
	for func, tags in pairs(functionTags) do
		for _, t in ipairs(tags) do
			if t == tag then
				table.insert(functionsWithTag, func)
			end
		end
	end
	_JPROFILER.pop("getFunctionsByTag")
	return functionsWithTag
end
