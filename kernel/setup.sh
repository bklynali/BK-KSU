#!/bin/sh
set -eu

GKI_ROOT=$(pwd)
KSU_REMOTE="${KSU_REMOTE:-https://github.com/bklynali/BK-KSU}"
KSU_DIR="$GKI_ROOT/KernelSU"

display_usage() {
    echo "Usage: $0 [--cleanup | <commit-or-tag>]"
    echo "  --cleanup:              Cleans up previous modifications made by the script."
    echo "  <commit-or-tag>:        Sets up or updates the KernelSU to specified tag or commit."
    echo "  -h, --help:             Displays this usage information."
    echo "  (no args):              Sets up or updates the KernelSU environment to the latest tagged version."
}

# Vendor/Samsung GKI trees often have a full kernel at repo root AND a copy under
# common/. Official AOSP GKI only has common/drivers. Hook every tree that exists
# so `make -C .` and bazel //common both compile KernelSU.
collect_driver_dirs() {
    DRIVER_DIRS=""
    if [ -f "$GKI_ROOT/drivers/Makefile" ]; then
        DRIVER_DIRS="$DRIVER_DIRS $GKI_ROOT/drivers"
    fi
    if [ -f "$GKI_ROOT/common/drivers/Makefile" ]; then
        DRIVER_DIRS="$DRIVER_DIRS $GKI_ROOT/common/drivers"
    fi
    if [ -z "$DRIVER_DIRS" ]; then
        echo '[ERROR] "drivers/" directory not found.'
        exit 127
    fi
}

hook_driver_dir() {
    DRIVER_DIR="$1"
    DRIVER_MAKEFILE="$DRIVER_DIR/Makefile"
    DRIVER_KCONFIG="$DRIVER_DIR/Kconfig"

    echo "[+] Hooking $DRIVER_DIR"
    rm -f "$DRIVER_DIR/kernelsu"
    ln -sfn "$KSU_DIR/kernel" "$DRIVER_DIR/kernelsu"
    echo "[+] Symlink $DRIVER_DIR/kernelsu -> $KSU_DIR/kernel"

    grep -q "kernelsu" "$DRIVER_MAKEFILE" \
        || printf "\nobj-\$(CONFIG_KSU) += kernelsu/\n" >> "$DRIVER_MAKEFILE"
    echo "[+] Modified $DRIVER_MAKEFILE"

    grep -q "source \"drivers/kernelsu/Kconfig\"" "$DRIVER_KCONFIG" \
        || sed -i "/endmenu/i\\
source \"drivers/kernelsu/Kconfig\"" "$DRIVER_KCONFIG"
    echo "[+] Modified $DRIVER_KCONFIG"
}

unhook_driver_dir() {
    DRIVER_DIR="$1"
    DRIVER_MAKEFILE="$DRIVER_DIR/Makefile"
    DRIVER_KCONFIG="$DRIVER_DIR/Kconfig"

    [ -L "$DRIVER_DIR/kernelsu" ] && rm "$DRIVER_DIR/kernelsu" && echo "[-] Symlink removed: $DRIVER_DIR/kernelsu"
    grep -q "kernelsu" "$DRIVER_MAKEFILE" && sed -i '/kernelsu/d' "$DRIVER_MAKEFILE" && echo "[-] Makefile reverted: $DRIVER_MAKEFILE"
    grep -q "drivers/kernelsu/Kconfig" "$DRIVER_KCONFIG" && sed -i '/drivers\/kernelsu\/Kconfig/d' "$DRIVER_KCONFIG" && echo "[-] Kconfig reverted: $DRIVER_KCONFIG"
}

perform_cleanup() {
    echo "[+] Cleaning up..."
    collect_driver_dirs
    for DRIVER_DIR in $DRIVER_DIRS; do
        unhook_driver_dir "$DRIVER_DIR"
    done
    if [ -e "$KSU_DIR" ]; then
        rm -rf "$KSU_DIR" && echo "[-] KernelSU directory deleted."
    fi
    if [ -d "$GKI_ROOT/BK-KSU" ]; then
        rm -rf "$GKI_ROOT/BK-KSU" && echo "[-] Leftover BK-KSU clone deleted."
    fi
}

sync_kernelsu_tree() {
    # git clone without a dest dir names the folder BK-KSU, but GKI kbuild expects KernelSU/.
    if [ -d "$GKI_ROOT/BK-KSU" ] && [ ! -e "$KSU_DIR" ]; then
        mv "$GKI_ROOT/BK-KSU" "$KSU_DIR"
        echo "[+] Renamed BK-KSU -> KernelSU."
    fi
    if [ ! -d "$KSU_DIR" ]; then
        git clone "$KSU_REMOTE" "$KSU_DIR" && echo "[+] Repository cloned."
    fi

    cd "$KSU_DIR"
    git stash && echo "[-] Stashed current changes."
    # Avoid GNU grep -P: Android build-tools grep is often first on PATH.
    if git describe --exact-match HEAD >/dev/null 2>&1; then
        git checkout main && echo "[-] Switched to main branch."
    fi
    git pull && echo "[+] Repository updated."
    if [ -z "${1-}" ]; then
        latest=$(git describe --abbrev=0 --tags 2>/dev/null || true)
        if [ -n "$latest" ]; then
            git checkout "$latest" && echo "[-] Checked out latest tag $latest."
        else
            git checkout main && echo "[-] No tags found, using main."
        fi
    else
        git checkout "$1" && echo "[-] Checked out $1." || echo "[-] Checkout default branch"
    fi
    cd "$GKI_ROOT"
}

setup_kernelsu() {
    echo "[+] Setting up KernelSU for GKI..."
    collect_driver_dirs
    sync_kernelsu_tree "${1-}"

    if [ ! -f "$KSU_DIR/kernel/Kconfig" ]; then
        echo "[ERROR] $KSU_DIR/kernel/Kconfig not found."
        exit 1
    fi

    for DRIVER_DIR in $DRIVER_DIRS; do
        hook_driver_dir "$DRIVER_DIR"
    done

    echo "[+] KernelSU is linked into:"
    for DRIVER_DIR in $DRIVER_DIRS; do
        ls -ld "$DRIVER_DIR/kernelsu"
    done
    echo '[+] Done.'
}

if [ "$#" -eq 0 ]; then
    setup_kernelsu
elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    display_usage
elif [ "$1" = "--cleanup" ]; then
    perform_cleanup
else
    setup_kernelsu "$@"
fi
