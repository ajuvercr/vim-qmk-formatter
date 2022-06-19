local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

local get_master_node = function()
    local node = ts_utils.get_node_at_cursor()
    if node == nil then
        error("No Treesitter parser found")
    end

    local history = { nil, nil, node }

    while (node ~= nil and node:type() ~= 'initializer_pair') do
        history[1] = history[2]
        history[2] = history[3]

        node = node:parent()
        history[3] = node
    end

    if node == nil then
        return nil
    end

    local arr_decl = history[1]:prev_named_sibling()

    return history[1], arr_decl
end


local get_node_text = function(bufnr, node)
    local sr, sc, er, ec = node:range()
    return vim.api.nvim_buf_get_text(bufnr, sr, sc, er, ec, {})[1]
end

local get_lenghts = function(bufnr, children)
    local lenghts = {}

    for i = 1, 10 do
        lenghts[i] = 0
    end

    for i = 1, 4 do
        for j = 1, 10 do
            local child = children[i][j]
            if child ~= 0 and child ~= nil then
                local child_name = get_node_text(bufnr, child)
                local len = string.len(child_name)

                if lenghts[j] < len then
                    lenghts[j] = len
                end
            end
        end
    end

    return lenghts
end

local get_children_matrix = function(node)
    local out = {}
    local k = 0

    for _ = 1, 3 do
        local current = {}

        for _ = 1, 10 do
            local child = node:named_child(k)
            while child:type() == 'comment' do
                k = k + 1
                child = node:named_child(k)
            end
            table.insert(current, child)
            k = k + 1
        end

        table.insert(out, current)
    end

    local current = {}

    for _ = 1, 3 do
        table.insert(current, 0)
    end

    for _ = 1, 4 do
        local child = node:named_child(k)
        while child:type() == 'comment' do
            k = k + 1
            child = node:named_child(k)
        end
        table.insert(current, child)
        k = k + 1
    end
    table.insert(out, current)

    return out
end

M.format_keymap = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local node = get_master_node()
    if node == nil then
        print("No applicable node found!")
        return
    end

    local children = get_children_matrix(node)
    local lenghts = get_lenghts(bufnr, children)

    local lines = { '(' }

    for i = 1, 4 do
        local builder = {}
        for j = 1, 10 do
            local child = children[i][j]
            if child ~= 0 and child ~= nil then
                local child_name = get_node_text(bufnr, child)
                local len = string.len(child_name)

                table.insert(builder, child_name)
                table.insert(builder, string.rep(" ", lenghts[j] - len))
                if i ~= 4 or j ~= 7 then
                    table.insert(builder, ", ")
                end

                if j == 5 then
                    table.insert(builder, "/*  */ ")
                end
            else
                table.insert(builder, string.rep(" ", lenghts[j] + 2))
            end
        end

        if i == 4 then
            table.insert(builder, ")")
        end
        table.insert(lines, table.concat(builder, ""))
    end

    local sr, sc, er, ec = node:range()

    vim.api.nvim_buf_set_text(bufnr, sr, sc, er, ec, lines)
end

return M
