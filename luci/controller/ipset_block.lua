module("luci.controller.ipset_block", package.seeall)

function index()
    entry({"admin", "network", "ipset_block"}, template("ipset_block_control"), "Bloqueo Internet", 91)
end
