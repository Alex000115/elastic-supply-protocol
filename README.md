# Elastic Supply Protocol

This repository contains a professional implementation of a **Rebase Token**. Unlike standard ERC-20 tokens with a fixed supply, the balance in every holder's wallet changes dynamically when a `rebase` is triggered.

## How Rebase Works
* **Price > Target:** The supply expands (increases). Users see more tokens in their wallets, but their % share of the total supply remains constant.
* **Price < Target:** The supply contracts (decreases). Users see fewer tokens, intended to drive the price back up through scarcity.

## Key Technical Concepts
* **Gons:** Internally, the contract tracks balances in "Gons" (large constant integers). 
* **Fragment Ratio:** A global multiplier converts internal "Gons" to the external "Token" balance shown in UIs.
* **Non-Dilutive:** Because everyone is rebased at the same percentage, nobody is diluted by the supply change.

## Security
* **Access Control:** Only the authorized "Monetary Policy" or "Oracle" contract can trigger a rebase.
* **Max Supply Caps:** Built-in safeguards to prevent runaway inflation/deflation.
