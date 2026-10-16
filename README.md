# micropocessor-emu8086-asym-071
project micropocesor pada emu8086 mengunakan bahasa tingkat rendah assembly language


## 1. Apa itu Assembly Language?

- Assembly merupakann bahasa pemrograman **level rendah**.
  
Untuk memahaminya, perlu mengetahui struktur dasar komputer.

### Model Komputer Sederhana

| Komponen | Fungsi |
|----------|--------|
| **CPU** | otak komputer; terjadinya komputasi dasar |
| **RAM** | Tempat program dimuat sebelum dieksekusi |
| **System Bus** | jembatan pemnghubung untuk komunikasi |

---

## 2. Di Dalam CPU

### General Purpose Registers (8 register, masing-masing 16-bit)

| Register | Nama Lengkap | Sub-register |
|----------|-------------|--------------|
| **AX** | Accumulator | AH / AL |
| **BX** | Base Address | BH / BL |
| **CX** | Count | CH / CL |
| **DX** | Data | DH / DL |
| **SI** | Source Index | — |
| **DI** | Destination Index | — |
| **BP** | Base Pointer | — |
| **SP** | Stack Pointer | — |

---

### Segment Registers

| Register | Fungsi |
|----------|--------|
| **CS** | segmen program yang sedang berjalan |
| **DS** | tempat variabel didefinisikan |
| **ES** | Extra segment|
| **SS** | segmen stack |
---

### Special Purpose Registers

| Register | Fungsi |
|----------|--------|
| **IP** | Instruction Pointer — selalu berpasangan dengan CS |
| **Flags** | Menentukan kondisi CPU setelah operasi matematika (Overflow, Direction, Interrupt, Trace, Sign, Zero, Auxiliary Carry, Parity, Carry) |

---

## 3. Akses Memori

### Cara Menghitung Physical Address

```
Physical Address = Segment Register × 10h + General Purpose Register
Contoh: DS=1230h, SI=0045h → 1230h × 10h + 45h = 12345h
```

### Register yang Bisa Membentuk Effective Address

Hanya **4 register**: `BX`, `SI`, `DI`, `BP`

**Tabel kombinasi valid:**

```
| BX | SI |          |
| BP | DI | + disp   |
```

- Ambil satu item dari tiap kolom, atau lewati kolom.
- **BX dan BP tidak boleh digabung.**
- **SI dan DI tidak boleh digabung.**

**Contoh mode pengalamatan valid:**
- `[BX+5]`
- `[BX+SI]`
- `[DI+BX-4]`

### Aturan Default Segment

| Kondisi | Segment yang digunakan |
|---------|------------------------|
| Mode dengan `BX`, `SI`, `DI` | **DS** |
| Mode dengan `BP` | **SS** |

### Prefix Tipe Data

| Prefix | Arti | Singkatan (Emu) |
|--------|------|-----------------|
| `byte ptr` | Akses 1 byte | `b.` |
| `word ptr` | Akses 2 byte | `w.` |

```asm
byte ptr [BX]   ; akses byte
word ptr [BX]   ; akses word
```

### Displacement

- **d8**: displacement 8-bit bertanda (contoh: `22`, `55h`, `-1`)
- **d16**: displacement 16-bit bertanda (contoh: `300`, `5517h`, `-259`)
- Bisa berada di dalam atau di luar tanda `[ ]` — hasil machine code sama.

---

## 4. Instruksi MOV

Menyalin nilai dari operand **sumber** ke operand **tujuan**.

### Sintaks yang Didukung

```asm
MOV REG, memory
MOV memory, REG
MOV REG, REG
MOV memory, immediate
MOV REG, immediate
```

**Untuk Segment Registers:**
```asm
MOV SREG, memory
MOV memory, SREG
MOV REG, SREG
MOV SREG, REG
```

`MOV` **tidak bisa** digunakan untuk mengatur nilai `CS` dan `IP`.

### Aturan MOV

- Source dan destination harus **ukuran sama** (byte atau word).
- `REG`: AX, BX, CX, DX, AH, AL, BH, BL, CH, CL, DH, DL, SI, DI, BP, SP
- `SREG`: DS, ES, SS (CS hanya sebagai operand kedua)

### Contoh Program

```asm
ORG 100h            ; diperlukan untuk program .com 1 segmen

MOV AX, 0B800h      ; AX = B800h (alamat video memory)
MOV DS, AX          ; DS = AX
MOV CL, 'A'         ; CL = kode ASCII 'A' (41h)
MOV CH, 1101_1111b  ; CH = nilai biner
MOV BX, 15Eh        ; BX = 15Eh
MOV [BX], CX        ; salin CX ke memori di B800:015E

RET                 ; kembali ke sistem operasi
```

---

## Catatan Singkat

| Simbol | Makna |
|--------|-------|
| `;` | Komentar (diabaikan assembler) |
| `h` / `H` | Nilai heksadesimal |
| `b` / `B` | Nilai biner |
| `ORG 100h` | Direktif awal program `.com` |
