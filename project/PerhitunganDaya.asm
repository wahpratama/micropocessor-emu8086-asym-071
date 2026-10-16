.MODEL SMALL
.STACK 100H

.DATA
    watt    DW 20
    jumlah  DW 3
    jam     DW 5
    hari    DW 30
    energi  DW ?

    garis   DB '====================================', 13, 10, '$'
    judul   DB '     PERHITUNGAN ENERGI LISTRIK', 13, 10, '$'
    label1  DB 'Daya alat (Watt)       : $'
    label2  DB 'Jumlah alat           : $'
    label3  DB 'Jam pemakaian per hari: $'
    label4  DB 'Jumlah hari           : $'
    pisah   DB '------------------------------------', 13, 10, '$'
    hasil   DB 'Total energi          : $'
    satuan  DB ' kWh', 13, 10, '$'
    baris   DB 13, 10, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Hitung energi
    ; Nilai contoh ini menghasilkan 9000 Wh.
    MOV AX, watt
    MUL jumlah
    MUL jam
    MUL hari

    MOV BX, 1000
    DIV BX
    MOV energi, AX

    ; Tampilkan judul
    LEA DX, garis
    CALL CETAK_TEKS
    LEA DX, judul
    CALL CETAK_TEKS
    LEA DX, garis
    CALL CETAK_TEKS

    ; Tampilkan daya
    LEA DX, label1
    CALL CETAK_TEKS
    MOV AX, watt
    CALL CETAK_ANGKA
    CALL BARIS_BARU

    ; Tampilkan jumlah alat
    LEA DX, label2
    CALL CETAK_TEKS
    MOV AX, jumlah
    CALL CETAK_ANGKA
    CALL BARIS_BARU

    ; Tampilkan jam pemakaian
    LEA DX, label3
    CALL CETAK_TEKS
    MOV AX, jam
    CALL CETAK_ANGKA
    CALL BARIS_BARU

    ; Tampilkan jumlah hari
    LEA DX, label4
    CALL CETAK_TEKS
    MOV AX, hari
    CALL CETAK_ANGKA
    CALL BARIS_BARU

    ; Tampilkan hasil
    LEA DX, pisah
    CALL CETAK_TEKS
    LEA DX, hasil
    CALL CETAK_TEKS
    MOV AX, energi
    CALL CETAK_ANGKA
    LEA DX, satuan
    CALL CETAK_TEKS
    LEA DX, garis
    CALL CETAK_TEKS

    ; Keluar ke DOS
    MOV AX, 4C00H
    INT 21H
MAIN ENDP

; Cetak teks berakhiran '$' dari DS:DX
CETAK_TEKS PROC
    PUSH AX
    MOV AH, 09H
    INT 21H
    POP AX
    RET
CETAK_TEKS ENDP

; Pindah ke baris berikutnya
BARIS_BARU PROC
    PUSH DX
    LEA DX, baris
    CALL CETAK_TEKS
    POP DX
    RET
BARIS_BARU ENDP

; Ubah bilangan unsigned di AX menjadi karakter ASCII
; lalu tampilkan digitnya di layar.
CETAK_ANGKA PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    XOR CX, CX
    MOV BX, 10

PECAH_DIGIT:
    XOR DX, DX
    DIV BX              ; AX = hasil bagi, DX = sisa
    PUSH DX
    INC CX
    CMP AX, 0
    JNE PECAH_DIGIT

TAMPIL_DIGIT:
    POP DX
    ADD DL, '0'         ; Ubah digit 0..9 menjadi ASCII
    MOV AH, 02H
    INT 21H
    LOOP TAMPIL_DIGIT

    POP DX
    POP CX
    POP BX
    POP AX
    RET
CETAK_ANGKA ENDP

END MAIN