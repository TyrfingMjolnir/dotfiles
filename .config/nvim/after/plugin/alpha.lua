local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
 return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {

    [[          ▀████▀▄▄              ▄█ ]],
    [[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]],
    [[    ▄        █          ▀▀▀▀▄  ▄▀  ]],
    [[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]],
    [[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]],
    [[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]],
    [[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]],
    [[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]],
    [[   █   █  █      ▄▄           ▄▀   ]],

}

 dashboard.section.buttons.val = {
   dashboard.button( "h", "Run health check", ":CheckHealth <CR>" ),
   dashboard.button( "d", "Open dadbod UI", ":DBUI <CR>" ),
   dashboard.button( "p", "Load local postgres into dadbod", ":DB postgresql:///myDBname <CR>" ),
   dashboard.button( "f", "Find file", ":Telescope find_files <CR>" ),
   dashboard.button( "e", "New file", ":ene <BAR> startinsert <CR>" ),
   dashboard.button( "r", "Recently used files", ":Telescope oldfiles <CR>" ),
   dashboard.button( "c", "TS /opt/local/dev/", ":Telescope /opt/local/dev/ <CR>" ),
   dashboard.button( "t", "Find text", ":Telescope live_grep <CR>" ),
   dashboard.button( "c", "Configuration", ":e ~/.config/nvim/init.vim<CR>" ),
   dashboard.button( "q", "Quit Neovim", ":qa<CR>" ),
}

local function footer()
 return "\"They say you're beautiful and they will always let you in,\nbut doors are never open to the child without a trace of sin.\"\n - Ronnie James Dio"
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
