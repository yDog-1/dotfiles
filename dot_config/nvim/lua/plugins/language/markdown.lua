return {
	{
		"ixru/nvim-markdown",
		event = "FileType markdown",
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			preset = "lazy",
			heading = {
				backgrounds = {},
			},
			code = {
				inline_pad = 1,
			},
		},
	},
}
