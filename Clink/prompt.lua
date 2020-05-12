local colors = {}

colors.BLACK   = 0
colors.RED     = 1
colors.GREEN   = 2
colors.YELLOW  = 3
colors.BLUE    = 4
colors.MAGENTA = 5
colors.CYAN    = 6
colors.WHITE   = 7

colors.DEFAULT = 9
colors.BOLD    = 1

set_color = function (fore, back, bold)
    fore = fore or colors.DEFAULT
    back = (back or colors.DEFAULT) + 10
    bold = bold and colors.BOLD or 22

    return "\x1b[3"..fore..";"..bold..";4"..back.."m"
end

color_text = function (text, fore, back, bold)
    if not text then
        return text
    end

    return set_color(fore, back, bold)..text..set_color()
end


function git_prompt_filter()
    if clink.prompt.value:sub(-1) == ">" then
        clink.prompt.value = clink.prompt.value:sub(0, #clink.prompt.value - 1)
    end

    local git_branch = ""
    local added = 0
    local deleted = 0
    local modified = 0
    local new = 0

    for line in io.popen("git -c color.status=false status --short --branch --porcelain 2>nul"):lines() do
        local m = line:match("^## (.+)$")
        if m then
            git_branch = m
        end

        if (line:match("^%s*M ")) then
            modified = modified + 1
        end

        if (line:match("^%s*A ")) then
            added = added + 1
        end

        if (line:match("^%s*D ")) then
            deleted = deleted + 1
        end

        if (line:match("^%s*%?%? ")) then
            new = new + 1
        end
    end

    local git_status = ""
    if added + new > 0 then
        git_status = git_status .. color_text(" +" .. (added + new), colors.GREEN)
    end
    if modified > 0 then
        git_status = git_status .. color_text(" ~" .. modified, colors.YELLOW)
    end
    if deleted > 0 then
        git_status  = git_status .. color_text(" -" .. deleted, colors.RED)
    end

    if git_branch ~= "" then
        git_branch = git_branch:gsub("%.%.%.", " -> ")
        git_branch = git_branch .. git_status
        git_branch = " (" .. git_branch .. ")"
        git_branch = color_text(git_branch, colors.YELLOW, colors.DEFAULT, colors.BOLD)
    end
    
    clink.prompt.value = clink.prompt.value .. git_branch .. "\nλ " 
    clink.prompt.value = color_text(clink.prompt.value, colors.CYAN, colors.DEFAULT, colors.BOLD)

    return false
end

clink.prompt.register_filter(git_prompt_filter, 50)