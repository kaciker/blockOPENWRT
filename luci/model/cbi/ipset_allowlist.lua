local uci = require "luci.model.uci".cursor()
local m = Map("ipset_allowlist", "Lista de IPs Permitidas")

local s = m:section(TypedSection, "entry", "IPs Permitidas")
s.template = "cbi/tblsection"
s.addremove = true
s.anonymous = true

local ip = s:option(Value, "ip", "IP")
ip.datatype = "ipaddr"
ip.rmempty = false

local name = s:option(Value, "name", "Nombre de Host")
name.rmempty = true

function name.cfgvalue(self, section)
    local val = Value.cfgvalue(self, section)
    if val and #val > 0 then 
        return val 
    end
    local ip_val = ip:cfgvalue(section)
    if not ip_val or #ip_val == 0 then
        return nil
    end
    local name_found = nil
    uci:foreach("dhcp", "host", function(s)
        if s.ip == ip_val and s.name then
            name_found = s.name
            return false
        end
    end)
    return name_found
end

function m.on_commit(self)
    os.execute("/usr/bin/sync_ipset.sh >/dev/null 2>&1 &")
end

return m
