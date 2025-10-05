FROM ubuntu:24.04

# --- System deps ---
RUN apt-get update && apt-get install -y \
    curl git pkg-config libssl-dev build-essential libudev-dev clang cmake make \
    && rm -rf /var/lib/apt/lists/*

# --- Install Rust (latest stable) ---
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# --- Solana CLI ---
RUN sh -c "$(curl -sSfL https://release.solana.com/v2.3.12/install)"
ENV PATH="/root/.local/share/solana/install/active_release/bin:${PATH}"

# --- Anchor (build from source for glibc compat) ---
RUN cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.1 anchor-cli --locked

# --- Preload cargo & solana cache dirs for speed ---
RUN anchor --version && solana --version && rustc --version

