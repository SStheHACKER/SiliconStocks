# FPGA-Accelerated Multi-Algorithm HFT System

This repository hosts the Verilog-based implementation of a **High-Frequency Trading (HFT) system** on the **Nexys A7 FPGA** platform. The design incorporates **four distinct trading algorithms**, supported by a custom **on-chip RAM module**, all orchestrated to deliver high-speed, low-latency decision-making for multiple stock assets.

---

## 🧠 Project Objective

High-frequency trading demands **ultra-low latency**, **parallel processing**, and **robust decision-making**. This project addresses those requirements by leveraging the **hardware acceleration capabilities of FPGAs**, enabling:

- Concurrent execution of multiple HFT strategies.
- Efficient handling of real-time market data.
- Intelligent signal fusion for enhanced trade accuracy.

---

## ⚙️ Key Features

- 🔄 **Multi-Strategy Execution**: Implements **four unique trading algorithms** to extract diverse market insights.
- 🧠 **Integrated Signal Fusion**: Combines individual strategy outputs into a **unified trading decision**.
- 📦 **On-Chip RAM**: High-speed custom RAM module for real-time data access across multiple stock feeds.
- ⚡ **FPGA-Powered Acceleration**: Runs entirely on Nexys A7 FPGA, enabling **parallelism** and **minimum latency**.
- 🔧 **Modular Design**: Fully scalable — new strategies or memory enhancements can be added seamlessly.
- 🛰️ **UART Interface**: Implemented a Verilog-based UART module for **serial communication**, allowing external monitoring or data logging of trading signals.

---

## 🏗️ System Architecture

The system is logically divided into three primary modules:

### 1. 📊 HFT Algorithms Module
- Contains four Verilog-based submodules, each implementing a unique trading strategy.
- Designed to **process market data in parallel**, producing independent signals per algorithm.

### 2. 💾 On-Chip RAM Module
- Custom-designed memory module with high-speed **read/write** capability.
- Supports **multi-stock data handling** and provides immediate access to live market data.

### 3. 🔗 Integration Module
- Collects outputs from all four strategies.
- Applies **fusion logic** to generate a **final consolidated trading signal**.
- Acts as the bridge between decision-making and trading execution.
  
### 4. 🛰️ UART Communication Module (Optional)
- Facilitates serial communication with an external interface.
- Used for logging trade signals or monitoring system output via terminal tools (e.g., PuTTY, serial monitor).


---

## 🖥️ Platform & Tools

- 🔌 **Target Board**: Nexys A7 FPGA
- 🛠️ **Hardware Description Language**: Verilog
- 💻 **Development Suite**: Xilinx Vivado Design Suite

---
