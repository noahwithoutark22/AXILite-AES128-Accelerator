# AXILite-AES128-Accelerator
A high-performance, fully pipelined AES-128 encryption engine designed for cryptographic workloads. Developed for the UDYAM' 26 I-CHIP competition, this IP core achieves a throughput of 4 Gbps by utilizing an 11-stage architectural pipeline.

## Key Features

- **Fully Pipelined Architecture**
  - 11-stage pipeline
  - Throughput: **1 block per clock cycle**
  - Sustains high-speed operation (~4 Gbps @ 125 MHz)

- **Optimized S-Box (No LUTs)**
  - Implemented using **composite field arithmetic (GF((2⁴)²))**
  - Eliminates BRAM usage
  - Reduces area and improves timing
  - Based on recursive subfield inversion 
  
- **AXI-Lite Compatible Interface**
  - 32-bit memory-mapped interface
  - Internal **128-bit datapath with automatic serialization/deserialization**
  - Efficient controller for data movement and synchronization

## Architecture Overview

- **Pipeline Stages**
  - Initial AddRoundKey
  - 9 full AES rounds
  - Final round (no MixColumns)

- **On-the-fly Key Expansion**
  - Fully pipelined and synchronized with data path
  - No precomputed key storage

- **Modes Supported**
  - ECB
  - CTR (with nonce + counter)

## Design Highlights

- Zero-cost operations using **bit-level transformations**
- Parallel propagation of **data + round keys**
- Stall-safe pipeline with valid signal tracking
- Efficient MixColumns using XOR + shift (no multipliers)

## Encryption Results

### ECB Mode

#### Test Image 1

| Original Image | Encrypted Image |
|:--------------:|:---------------:|
| <img src="result%20images/orig750.png" width="800"> | <img src="result%20images/encr750.png" width="800"> |

---

#### Test Image 2

| Original Image | Encrypted Image |
|:--------------:|:---------------:|
| <img src="result%20images/duck1.png" width="800"> | <img src="result%20images/duckecb.png" width="800"> |

---

### CTR Mode

#### Test Image 

| Original Image | Encrypted Image |
|:--------------:|:---------------:|
| <img src="result%20images/duck1.png" width="800"> | <img src="result%20images/duck2cntr.png" width="800"> |



