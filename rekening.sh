#!/bin/bash

# ====================================================
# Script Pencatat Rekening (Rekening Number)
# Untuk Termux & Kali Linux
# ====================================================

# Konfigurasi file
DATA_FILE="$HOME/.rekening_data.txt"
SANDI_FILE="$HOME/.rekening_sandi.hash"
LOG_FILE="$HOME/.rekening_log.txt"

# Warna
PINK='\033[1;35m'
NC='\033[0m'
MERAH='\033[1;31m'
HIJAU='\033[1;32m'
KUNING='\033[1;33m'

# Fungsi untuk menampilkan logo
tampil_logo() {
    clear
    echo -e "${PINK}    ██████╗ ███████╗██╗  ██╗███████╗███╗    ██╗██╗███╗   ██╗ ██████╗     ${NC}"
    echo -e "${PINK}    ██╔══██╗██╔════╝██║ ██╔╝██╔════╝████╗  ██║██║████╗  ██║██╔════╝     ${NC}"
    echo -e "${PINK}    ██████╔╝█████╗  █████╔╝ █████╗  ██╔██╗ ██║██║██╔██╗ ██║██║  ███╗    ${NC}"
    echo -e "${PINK}    ██╔══██╗██╔══╝  ██╔═██╗ ██╔══╝  ██║╚██╗██║██║██║╚██╗██║██║   ██║    ${NC}"
    echo -e "${PINK}    ██║  ██║███████╗██║  ██╗███████╗██║ ╚████║██║██║ ╚████║╚██████╔╝    ${NC}"
    echo -e "${PINK}    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ${NC}"
    echo -e "${PINK}                                 N U M B E R                            ${NC}"
    echo -e "${KUNING}             >>>-{ where anonymous : created by Laksamana }-<<<${NC}"
    echo ""
}

buat_sandi_baru() {
    local sandi1 sandi2
    while true; do
        echo -n "Masukkan sandi baru (minimal 4 karakter): "
        read -s sandi1
        echo
        echo -n "Ulangi sandi baru: "
        read -s sandi2
        echo
        if [[ ${#sandi1} -lt 4 ]]; then
            echo -e "${MERAH}Sandi minimal 4 karakter!${NC}"
        elif [[ "$sandi1" != "$sandi2" ]]; then
            echo -e "${MERAH}Sandi tidak cocok!${NC}"
        else
            echo -n "$sandi1" | sha256sum | cut -d' ' -f1 > "$SANDI_FILE"
            echo -e "${HIJAU}Sandi berhasil disimpan!${NC}"
            return 0
        fi
    done
}

verifikasi_sandi() {
    if [[ ! -f "$SANDI_FILE" ]]; then
        echo -e "${KUNING}Belum ada sandi. Silakan buat sandi terlebih dahulu.${NC}"
        buat_sandi_baru
        return 0
    fi
    local sandi_input
    local stored_hash=$(cat "$SANDI_FILE")
    local percobaan=0
    local max_percobaan=3
    while [[ $percobaan -lt $max_percobaan ]]; do
        echo -n "Masukkan sandi: "
        read -s sandi_input
        echo
        local input_hash=$(echo -n "$sandi_input" | sha256sum | cut -d' ' -f1)
        if [[ "$input_hash" == "$stored_hash" ]]; then
            echo -e "${HIJAU}Berhasil!${NC}"
            return 0
        else
            percobaan=$((percobaan+1))
            echo -e "${MERAH}Sandi salah! Sisa percobaan: $((max_percobaan-percobaan))${NC}"
        fi
    done
    return 1
}

catat_rekening() {
    echo "=== CATAT NOMOR REKENING / DANA ==="
    local tgl=$(date "+%Y-%m-%d %H:%M:%S")
    read -p "Atas nama = " atas_nama
    read -p "Bang = " bang
    read -p "Nomor rekening = " nomor_rek
    if [[ -z "$atas_nama" || -z "$bang" || -z "$nomor_rek" ]]; then
        echo -e "${MERAH}Semua field harus diisi!${NC}"
        return 1
    fi
    echo "$tgl|$atas_nama|$bang|$nomor_rek" >> "$DATA_FILE"
    echo -e "${HIJAU}Data berhasil disimpan!${NC}"
}

lihat_semua() {
    if [[ ! -f "$DATA_FILE" || ! -s "$DATA_FILE" ]]; then
        echo -e "${MERAH}Belum ada data rekening.${NC}"
        return
    fi
    echo "=== DAFTAR SEMUA NOMOR REKENING ==="
    echo "------------------------------------------------------------------"
    printf "%-3s | %-19s | %-15s | %-10s | %-15s\n" "No" "Tanggal" "Atas Nama" "Bang" "Nomor Rekening"
    echo "------------------------------------------------------------------"
    local no=1
    while IFS='|' read -r tgl nama bang norek; do
        printf "%-3s | %-19s | %-15s | %-10s | %-15s\n" "$no" "$tgl" "$nama" "$bang" "$norek"
        no=$((no+1))
    done < "$DATA_FILE"
}

lihat_berdasarkan_nama() {
    if [[ ! -f "$DATA_FILE" || ! -s "$DATA_FILE" ]]; then
        echo -e "${MERAH}Belum ada data rekening.${NC}"
        return
    fi
    read -p "Masukkan nama yang dicari: " cari_nama
    echo "------------------------------------------------------------------"
    local no=1
    while IFS='|' read -r tgl nama bang norek; do
        if [[ "$nama" == *"$cari_nama"* ]]; then
            printf "%-3s | %-19s | %-15s | %-10s | %-15s\n" "$no" "$tgl" "$nama" "$bang" "$norek"
            no=$((no+1))
        fi
    done < "$DATA_FILE"
}

menu_lihat() {
    echo "1. Lihat semua\n2. Cari nama"
    read -p "Pilihan: " pil
    case $pil in
        1) lihat_semua ;;
        2) lihat_berdasarkan_nama ;;
    esac
}

hapus_rekening() {
    lihat_semua
    read -p "Nomor hapus: " nh
    sed -i "${nh}d" "$DATA_FILE"
    echo "Data dihapus."
}

ubah_sandi() {
    buat_sandi_baru
}

menu_utama() {
    while true; do
        tampil_logo
        echo "1. Catat  2. Lihat  3. Hapus  4. Sandi  5. Exit"
        read -p "Pilih: " p
        case $p in
            1) verifikasi_sandi && catat_rekening ;;
            2) verifikasi_sandi && menu_lihat ;;
            3) verifikasi_sandi && hapus_rekening ;;
            4) verifikasi_sandi && ubah_sandi ;;
            5) exit 0 ;;
        esac
        read -p "Enter..."
    done
}

menu_utama
