# Final Project - CS3501: Computer Architecture

## 👥 Team Members

| Name                    | Email                  |
|-------------------------|------------------------|
| Renato García Calle     | renato.garcia@utec.edu.pe |
| Nayeli Guzmán Huayta    | nayeli.guzman@utec.edu.pe  |

---

## ▶️ How to Use

1. Clone this repo:

```bash
git clone https://github.com/nayeli-guzman/multi-cycle.git
cd multi-cycle
```

Open the archive multicycle.xpr

---

## 📚 Overview

This project extends a multicycle ARM-based processor with:

1. **Integer multiplication and division operations**:
   - `MUL`, `UMULL`, `SMULL`, `DIV`
2. **Floating Point Unit (FPU)**:
   - Implemented separately from the ALU.
   - Supports `ADD` and `MUL` for:
     - Single precision (32-bit IEEE-754)
     - Half precision (16-bit IEEE-754)
   - Handles overflow by setting a custom overflow flag.

---

## ⚙️ Implemented Modules

### 🔢 Integer Arithmetic Units
- `MUL` — Signed 32-bit × 32-bit
- `UMULL` — Unsigned 32-bit × 32-bit → 64-bit result
- `SMULL` — Signed 32-bit × 32-bit → 64-bit result
- `DIV` — Integer division with exception/flag for divide-by-zero

### 🧮 Floating Point Unit (FPU)
- Operates independently from the ALU.
- Implements:
  - `FADD` — Floating-point addition
  - `FMUL` — Floating-point multiplication
- Supports:
  - IEEE 754 Single Precision (32-bit)
  - IEEE 754 Half Precision (16-bit)
- Overflow detection: custom flag signal

---

## 🧪 Testbenches

### 🧪 Integer Unit Tests
- Implemented in ARM Assembly:
  - Uses `MUL`, `UMULL`, `SMULL`
- Includes:
  - A meaningful mathematical function
  - Verilog testbench to validate ALU behavior

### 🧪 Floating Point Unit Tests
- Implemented in ARM Assembly:
  - Uses `FADD`, `FMUL`
- Includes:
  - A meaningful FP function (e.g., dot product, average)
  - Verilog testbench to validate FPU behavior


---

## 📅 Deliverables

- ✅ Verilog implementation of all required modules.
- ✅ Assembly programs demonstrating usage of new operations.
- ✅ Testbenches for ALU and FPU.
- ✅ Written report (`report/report.pdf`).
---

## 📝 Notes

- Simulations and synthesis done with **Vivado**.
