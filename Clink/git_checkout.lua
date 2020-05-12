-- Ctrl-Q in conemu to reload Clink Lua scripts
-- Clink match generators: https://github.com/mridgers/clink/blob/master/docs/clink.md#user-content-match-generators
-- Strings: http://lua-users.org/wiki/StringLibraryTutorial
-- Patterns: http://lua-users.org/wiki/PatternsTutorial
-- Escaping: http://www.lua.org/pil/20.2.html
-- local: http://www.lua.org/pil/4.2.html

-- git commands which will autocomplete branch names after them:
local git_commands = {"checkout", "co", "merge", "branch -d", "branch -D"}

function git_checkout_match_generator(text, first, last)
	local commandLine = rl_state.line_buffer
	--print("git_checkout_match_generator", text, first, last, "commandLine:", commandLine)--debug

	-- match "git rebase" parameters
	if commandLine:find("git rebase ", 1, true) == 1 then
		local matchedRebaseParam = false
		for _,rebaseParam in pairs({"--continue", "--skip", "--abort"}) do
			if rebaseParam:find(text, 1, true) then
				clink.add_match(rebaseParam)
				matchedRebaseParam = true
			end
		end
		if matchedRebaseParam then
			return true
		end
	end

	local matchedCommand = false
	
	for _,command in pairs(git_commands) do
		local commandFirst, commandLast = commandLine:find("git " .. command .. " ", 1, true) -- use plain-text find, so I don't have to escape "-" in the list of commands above
		if commandFirst == 1 then -- the command must start at the beginning of the line (and I couldn't just use ^ in the pattern, since I used plain-text find)
			matchedCommand = true
			break
		end
	end
	
	local matchedBranches = false
	
	if matchedCommand then
		for line in io.popen("git branch -a 2>nul"):lines() do
			local branch = line:match("[%* ] (.+)$")
			if not branch:find("HEAD", 1, true) then
				branch = string.gsub(branch, "remotes/origin/", "")
				if branch:find(text, 1, true) then
					matchedBranches = true
					clink.add_match(branch)
				end
			end
		end
	end
	
	return matchedBranches
end

clink.register_match_generator(git_checkout_match_generator, 10)