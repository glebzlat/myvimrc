return {
  "glepnir/dashboard-nvim",
  config = function()
    local db = require "dashboard"
    db.custom_header = {
      "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
      "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
      "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
      "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
    }
    db.custom_center = {
      {
        desc = "File browser",
        action = "Telescope file_browser",
      },
      {
        desc = "Find file",
        action = "Telescope find_files",
      },
      {
        desc = "Git status",
        action = "Telescope git_status",
      },
      {
        desc = "Open terminal",
        action = "ToggleTerm",
      },
    }
  end,
}
