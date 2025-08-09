# MicroPython Pico 2 W — HID Firmware (Starter Repo)

Este repositório gera um firmware MicroPython para **Raspberry Pi Pico / Pico W / Pico 2 W** com **USB HID** (teclado/mouse) habilitado via TinyUSB.

## ⚡️ Como usar (GitHub Actions)
1. Crie um repositório no seu GitHub (vazio).
2. Faça upload de **todos os arquivos deste ZIP** (ou `git push`).
3. Vá em **Actions** → rode o workflow **Build MicroPython RP2 (HID)**.
4. Quando terminar, baixe o artefato **firmware-uf2** → `firmware.uf2`.
5. Coloque o Pico em **BOOTSEL** e copie o `firmware.uf2` para a unidade montada.

> Dica: Se usar `git`, faça `git init`, `git add .`, `git commit -m "init HID"`, `git branch -M main`, `git remote add origin <URL>` e `git push -u origin main`.

## 🛠️ Build local (Linux/WSL)
Requisitos: `git`, `cmake`, `gcc-arm-none-eabi`, `make`, `python3`, `patch`.
```bash
chmod +x build.sh
./build.sh
```
O firmware final fica em: `micropython/ports/rp2/build-PICO/firmware.uf2`.

## 🔧 Ajustes de placa (BOARD)
O comando padrão usa `BOARD=PICO`. Se precisar, tente:
- `BOARD=PICO_W`
- `BOARD=PICO2` (se existir no seu tree)
- ou mantenha `PICO` (geralmente funciona para Pico 2 W).

## 🧪 Exemplo de HID (teclado)
Depois de gravar o firmware, envie `example/main.py` para o Pico e reinicie. Ele pressiona a tecla `A` a cada 2s.

## 📁 O que tem aqui
- `patches/mpconfigport.h.patch` — habilita USB + HID no port RP2 do MicroPython.
- `ports/rp2/CMakeLists.txt.snippet` — ativa `MICROPY_PY_USBHID` no CMake.
- `build.sh` — script de build local (baixa submódulos, aplica patch, compila).
- `.github/workflows/build.yml` — workflow que compila e publica o `.uf2`.
- `example/main.py` — exemplo simples de envio de relatórios HID (teclado).
- `.gitignore` — ignora diretórios de build locais.

## ❗ Observações
- `VID/PID` no patch são genéricos para testes (`0xCafe/0x4011`). Para produto final, use VID/PID próprios.
- APIs exatas de `usb_hid` podem variar conforme o commit do MicroPython. O exemplo cobre os casos mais comuns.
- Se `usb_hid` não aparecer no MicroPython, verifique se as macros/flags foram aplicadas e recompiladas.

Boa diversão! 🎛️
