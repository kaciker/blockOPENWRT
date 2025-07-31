#!/bin/sh

# Configuración
IPSET_NAME="permitidas"
NFT_TABLE="fw4"
NFT_CHAIN="forward"
WAN_IF="eth0"
LOG_PREFIX="BLOCK_FW4 "
LOG_LEVEL="info"

# Cargar módulo de log si falta
modprobe nf_log_ipv4 2>/dev/null

activar() {
    echo "[+] Activando bloqueo solo para IPs de ipset @$IPSET_NAME..."

    nft flush chain inet $NFT_TABLE $NFT_CHAIN

    # Permitir conexiones ya establecidas y relacionadas
    nft add rule inet $NFT_TABLE $NFT_CHAIN ct state established,related accept comment "perm_established"

    # Permitir IPs en ipset
    nft add rule inet $NFT_TABLE $NFT_CHAIN ip saddr @$IPSET_NAME accept comment "perm_ipset_allow"

    # Registrar y bloquear lo demás
    nft add rule inet $NFT_TABLE $NFT_CHAIN oifname "$WAN_IF" log prefix "$LOG_PREFIX" level $LOG_LEVEL flags all
    nft add rule inet $NFT_TABLE $NFT_CHAIN oifname "$WAN_IF" drop comment "perm_block_wan"

    echo "[OK] Bloqueo ACTIVADO: solo las IPs en @$IPSET_NAME tienen salida a WAN."
}

desactivar() {
    echo "[+] Desactivando bloqueo, devolviendo acceso total..."

    nft flush chain inet $NFT_TABLE $NFT_CHAIN
    nft add rule inet $NFT_TABLE $NFT_CHAIN ct state established,related accept
    nft add rule inet $NFT_TABLE $NFT_CHAIN accept

    echo "[OK] Bloqueo DESACTIVADO: todos tienen acceso a Internet."
}

case "$1" in
    activar) activar ;;
    desactivar) desactivar ;;
    *)
        echo "Uso: $0 {activar|desactivar}"
        exit 1
        ;;
esac
