local Menu = require('snipe.menu')

-- Function to get the misspelled word under the cursor
local function get_misspelled_word()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	local col = cursor_pos[2] + 1 -- Lua indices start at 1

	-- Use Vim's built-in spell checking
	local spell_result = vim.fn.spellbadword(line:sub(col))
	local bad_word = spell_result[1]

	if bad_word == '' then
		vim.notify('No misspelled word under the cursor', vim.log.levels.INFO)
		return nil
	end

	return bad_word
end


-- Function to get spell suggestions for a given word
local function get_spell_suggestions(word)
	if not word then return {} end

	-- Get a list of suggestions
	local suggestions = vim.fn.spellsuggest(word)

	if vim.tbl_isempty(suggestions) then
		vim.notify('No suggestions found', vim.log.levels.INFO)
		return {}
	end

	return suggestions
end



local function open_spell_suggestions_menu()
	local misspelled_word = get_misspelled_word()
	if not misspelled_word then return end

	local suggestions = get_spell_suggestions(misspelled_word)
	if vim.tbl_isempty(suggestions) then return end

	-- limit the number of suggestions to 10
	--
	local menu_items = {}
	for i, suggestion in ipairs(suggestions) do
		if i > 10 then break end

		table.insert(menu_items, suggestion)
	end

	local menu = Menu:new {
		position = "cursor",
		open_win_override = { title = "Spell Suggestions" }
	}

	menu:open(menu_items, function(m, i)
		local suggestion = suggestions[i]
		m:close()

		-- Replace the misspelled word with the selected suggestion
		vim.cmd(string.format("normal! ciw%s", suggestion))
	end)
end

return {

	--- Setup the plugin
	--- @param config ?table?
	--- @return nil
	setup = function(config)
		-- merge config with default keymap
		config = vim.tbl_deep_extend('force', {
			keymap = {
				open_spell_menu = '<leader>fs',
			},
		}, config or {})

		-- Keymap to open the spell menu
		vim.keymap.set('n', config.keymap.open_spell_menu, open_spell_suggestions_menu)

		vim.o.spell = true

		-- register the commands
		vim.api.nvim_create_user_command('SnipeSpell', open_spell_suggestions_menu, { nargs = 0 })
	end
}
