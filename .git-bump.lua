return {
    uv = function(version, content)
        -- Replace the first comment starting with "Version"
        content = content:gsub("\n# Version: [^\n]+\n", ("\n# Version: %s\n"):format(version), 1)
        return content
    end,

    ["uv.bat"] = function(version, content)
        -- Replace the first comment starting with "Version"
        content = content:gsub("\nrem Version: [^\n]+\n", ("\nrem Version: %s\n"):format(version), 1)
        return content
    end,
}
