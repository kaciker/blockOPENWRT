module("luci.controller.ipset_allowlist", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/ipset_allowlist") then
        return
    end
    entry({"admin", "network", "ipset_allowlist"}, cbi("ipset_allowlist"), "IPs Permitidas", 90)
end
