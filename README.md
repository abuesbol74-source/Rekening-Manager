# Rekening-Manager 🏦
Script Bash sederhana dan aman untuk mencatat nomor rekening atau saldo digital (DANA/DLL) langsung dari terminal. Dilengkapi dengan enkripsi password menggunakan SHA-256.

---

## 🚀 Cara Instalasi & Penggunaan

### 1. Kloning Repositori
Langkah pertama untuk kedua platform (Termux & Kali):
```bash
git clone https://github.com/abuesbol74-source/Rekening-Manager.git
cd Rekening-Manager
chmod +x rekening.sh
```

---

### 📱 Khusus Pengguna TERMUX
1. **Pindahkan ke folder bin:**
   ```bash
   mv rekening.sh $PREFIX/bin/rekening
   ```
2. **Berikan izin eksekusi:**
   ```bash
   chmod +x $PREFIX/bin/rekening
   ```
3. **Jalankan script:**
   ```bash
   rekening
   ```

---

### 🐉 Khusus Pengguna KALI LINUX
1. **Pindahkan ke folder local bin:**
   ```bash
   sudo mv rekening.sh /usr/local/bin/rekening
   ```
2. **Berikan izin eksekusi:**
   ```bash
   sudo chmod +x /usr/local/bin/rekening
   ```
3. **Jalankan script:**
   ```bash
   rekening
   ```

---

## 🔒 Fitur Keamanan
* **SHA-256 Hashing**: Kata sandi di-hash untuk keamanan ekstra.
* **Local Data**: Data tersimpan secara lokal.

**Created by LAKSAMANA DZU NUR NAIN**