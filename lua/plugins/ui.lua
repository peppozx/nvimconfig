return {
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})

			opts.presets.lsp_doc_border = true
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},

	{
		"snacks.nvim",
		opts = {
			scroll = { enabled = false },
		},
		keys = {},
	},

	-- buffer line
	{
		"akinsho/bufferline.nvim",
		enabled = false,
		event = "VeryLazy",
		dependencies = { "craftzdog/solarized-osaka.nvim" },
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = function()
			local c = require("solarized-osaka.colors").setup()
			local fill = c.base03
			local inactive = c.base02
			local active = c.yellow500 or c.yellow or "#b58900"
			return {
				options = {
					mode = "tabs",
					separator_style = "slant",
					show_buffer_close_icons = false,
					show_close_icon = false,
				},
				highlights = {
					fill = { bg = fill },
					background = { fg = c.base0, bg = inactive },
					tab = { fg = c.base0, bg = inactive },
					tab_selected = { fg = c.base04, bg = active, bold = true },
					tab_separator = { fg = fill, bg = inactive },
					tab_separator_selected = { fg = fill, bg = active, sp = active },
					separator = { fg = fill, bg = inactive },
					separator_visible = { fg = fill, bg = inactive },
					separator_selected = { fg = fill, bg = active },
					buffer_visible = { fg = c.base0, bg = inactive },
					buffer_selected = { fg = c.base04, bg = active, bold = true },
					modified = { fg = c.orange500, bg = inactive },
					modified_visible = { fg = c.orange500, bg = inactive },
					modified_selected = { fg = c.orange500, bg = active },
				},
			}
		end,
	},

	-- filename
	{
		"b0o/incline.nvim",
		dependencies = { "craftzdog/solarized-osaka.nvim" },
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local colors = require("solarized-osaka.colors").setup()
			require("incline").setup({
				highlight = {
					groups = {
						InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
						InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				hide = {
					cursorline = true,
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if vim.bo[props.buf].modified then
						filename = "[+] " .. filename
					end

					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					return { { icon, guifg = color }, { " " }, { filename } }
				end,
			})
		end,
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local LazyVim = require("lazyvim.util")
			opts.sections.lualine_c[4] = {
				LazyVim.lualine.pretty_path({
					length = 0,
					relative = "cwd",
					modified_hl = "MatchParen",
					directory_hl = "",
					filename_hl = "Bold",
					modified_sign = "",
					readonly_icon = " 󰌾 ",
				}),
			}
		end,
	},

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				gitsigns = true,
				tmux = true,
				kitty = { enabled = false, font = "+2" },
			},
		},
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = false,
	},

	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				preset = {
					header = [[
	        ██╗   ██╗ ██████╗  ██╗██████╗
	        ██║   ██║██╔═══██╗███║██╔══██╗
	        ██║   ██║██║   ██║╚██║██║  ██║
	        ╚██╗ ██╔╝██║   ██║ ██║██║  ██║
	         ╚████╔╝ ╚██████╔╝ ██║██████╔╝
	          ╚═══╝   ╚═════╝  ╚═╝╚═════╝
   ]],
				},
			},
		},
	},
}
