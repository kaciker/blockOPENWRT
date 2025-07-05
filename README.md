# blockOPENWRT

# OpenWrt IPSet Internet Control Panel

Este repositorio contiene todo lo necesario para:

✅ Gestionar IPs permitidas en LuCI.  
✅ Bloquear el acceso a Internet a dispositivos no permitidos con botones en LuCI.  
✅ Mantener el sistema tras actualizaciones de OpenWrt (`sysupgrade`).

## Estructura

- `scripts/`: Scripts de control y sincronización con `nftables`.
- `luci/controller/`: Controladores LuCI.
- `luci/model/cbi/`: Modelos y plantillas LuCI.
- `sysupgrade.conf`: Para preservar archivos tras actualizaciones.

## Instalación

1️⃣ Copia `scripts/*` a:
