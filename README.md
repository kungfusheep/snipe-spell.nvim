# snipe-spell

snipe-spell adds native vim spell check support to ["leath-dub/snipe.nvim"](https://github.com/leath-dub/snipe.nvim) by providing a way to replace the current word with a suggestion from the spell checker.

![output](https://github.com/user-attachments/assets/10c29395-ec60-4595-9f32-c6098ae45fec)

## features

- Replace the current word with a suggestion from the builtin spell checker.

## installation

Use your favorite plugin manager. For example, with here is how you can install the plugin using lazy

```lua
{
    "kungfusheep/snipe-spell.nvim",
    dependencies = "leath-dub/snipe.nvim",
    config = true,
    keys = {
        { "<leader>fs", "<cmd>SnipeSpell <cr>", desc = "Snipe Spellchecker" },
    }
},
```

## vim spell checker

The plugin uses the built-in vim spell checker. You can enable it by setting the `spell` option 

```lua
vim.opt.spell = true
```

There are a bunch of options and defaults you can set to customize the spell checker, like keybindings to navigate the suggestions, the language and more. You can find more information in the vim help `:help spell`.

## Contributing

If you would like to contribute to the project, please feel free to open a pull request or an issue.

## License

This project is licensed under the MIT [license](LICENSE).
