# FPGA-Accelerated Multi-Algorithm HFT System

This repository contains the implementation of a high-frequency trading (HFT) system on Nexys A7 FPGA. The design integrates **four distinct HFT algorithms** along with a custom **on-chip RAM module** that efficiently stores and processes data for multiple stocks. The integrated output from these algorithms aims to enhance trading decisions by leveraging the unique strengths of each strategy.

## Overview

High-frequency trading requires rapid data processing and decision-making with ultra-low latency. This project targets these requirements by:
- **Utilizing FPGA hardware** for high-speed parallel processing.
- **Implementing four independent HFT algorithms** to analyze real-time market data.
- **Integrating a dedicated on-chip RAM module** for efficient data storage and retrieval.
- **Fusing algorithm outputs** to generate a consolidated trading signal, enhancing overall system performance and robustness.

## Features

- **Multiple HFT Strategies:** Four independent algorithms, each designed to capture different market signals.
- **On-Chip RAM Module:** Custom memory block optimized for rapid storage and access of multi-stock data.
- **Integrated Decision Making:** Combines algorithm outputs to provide a more accurate and reliable trading signal.
- **FPGA Implementation:** Achieves ultra-low latency processing essential for high-frequency trading environments.
- **Modular and Scalable:** Easily extendable architecture for future enhancements and additional algorithms.

## System Architecture

The design is partitioned into three primary modules:

1. **HFT Algorithms Module**
   - Contains four Verilog files, each implementing a unique trading strategy.
   - Processes incoming market data in parallel to generate individual trading signals.

2. **On-Chip RAM Module**
   - Designed to store data for multiple stocks with high-speed read/write capabilities.
   - Ensures that real-time data is readily available for algorithm processing.

3. **Integration Module**
   - Merges outputs from the four algorithms using a configurable fusion logic.
   - Provides a consolidated decision output to the trading interface.

The entire system is synthesized and deployed on a Nexys A7 FPGA, harnessing its parallel processing power for real-time applications.
