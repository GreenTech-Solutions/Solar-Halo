-- halo-terminal used to pay for charging directly as a tertiary consumer, which
-- left it unable to run (including discharging) once the network was out of
-- power. It's now a small primary consumer, and charging is paid for by a
-- hidden tertiary halo-terminal-charger linked to the terminal. Give every
-- already-placed terminal its charger.

local terminal_control = require("terminal.control")

terminal_control.ensure_all_helpers()
