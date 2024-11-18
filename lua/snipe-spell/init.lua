local Menu = require('snipe.menu')

-- get the misspelled word under the cursor
local function get_misspelled_word()
	-- Use Vim's built-in spell checking
	local spell_result = vim.fn.spellbadword()
	local bad_word = spell_result[1]

	if bad_word == '' then
		vim.notify('No misspelled word under the cursor', vim.log.levels.INFO)
		return nil
	end

	return bad_word
end


-- get spell suggestions for a given word
local function get_spell_suggestions(word)
	if not word then return {} end

	-- Get a list of suggestions
	local suggestions = vim.fn.spellsuggest(word, 10, 'best')

	if vim.tbl_isempty(suggestions) then
		vim.notify('No suggestions found', vim.log.levels.INFO)
		return {}
	end

	return suggestions
end


-- open the spell suggestions menu for the word under the cursor
local function open_spell_suggestions_menu()
	local misspelled_word = get_misspelled_word()
	if not misspelled_word then return end

	local suggestions = get_spell_suggestions(misspelled_word)
	if vim.tbl_isempty(suggestions) then return end

	local menu = Menu:new {
		position = "cursor",
		open_win_override = { title = "Spell Suggestions" }
	}

	menu:open(suggestions, function(m, i)
		local suggestion = suggestions[i]
		m:close()

		-- replace the misspelled word with the selected suggestion
		vim.cmd(string.format("normal! ciw%s", suggestion))
	end)
end

return {
	--- setup the plugin
	--- @return nil
	setup = function()
		vim.o.spell = true
		-- register the command
		vim.api.nvim_create_user_command('SnipeSpell', open_spell_suggestions_menu, { nargs = 0 })
	end
}
