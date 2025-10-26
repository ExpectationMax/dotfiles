return {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
        require('window-picker').setup({
            hint = 'floating-big-letter',
            show_prompt = false,
            filter_rules = {
                autoselect_one = true,
                include_current_win = true,
                include_unfocusable_windows = false,
            }
        })
    end
}
