# \# Day 12 — Ring Counter and Johnson Counter

# 

# <p align="center">

# &#x20; <b>Digital VLSI • Verilog RTL • Sequential Logic • Functional Verification • Cadence Genus</b>

# </p>

# 

# <p align="center">

# &#x20; <code>Specification → RTL → Simulation → Synthesis → Technology Mapping → Timing → Power → PPA</code>

# </p>

# 

# \---

# 

# \# 1. Project Information

# 

# | Parameter | Details |

# |---|---|

# | \*\*Project\*\* | Day 12 — Ring Counter and Johnson Counter |

# | \*\*Domain\*\* | Digital VLSI / RTL Design |

# | \*\*Design Type\*\* | Sequential Logic |

# | \*\*HDL\*\* | Verilog HDL |

# | \*\*Synthesis Tool\*\* | Cadence Genus 21.14-s082\_1 |

# | \*\*Technology Library\*\* | `tsmc18` |

# | \*\*Top Module\*\* | `ring\_johnson\_counter\_top` |

# | \*\*Counter Types\*\* | Ring Counter and Johnson Counter |

# | \*\*Reset Variants\*\* | RTL, synchronous reset, asynchronous reset |

# | \*\*Simulation Tool\*\* | Cadence Xcelium (`ncsim`) |

# | \*\*Waveform Database\*\* | `waves.shm` |

# | \*\*Simulation Result\*\* | PASS — 0 reported errors |

# | \*\*Synthesis Analysis\*\* | Hierarchy, cell mapping, area, power, and timing |

# | \*\*Project Status\*\* | Functional simulation and synthesis analysis completed |

# 

# \---

# 

# \# 2. Project Overview

# 

# A \*\*Ring Counter\*\* and a \*\*Johnson Counter\*\* are sequential circuits constructed using flip-flops connected as shift registers with feedback.

# 

# A ring counter feeds the output of its final stage directly back to its first stage. A Johnson counter feeds the inverted output of its final stage back to its first stage.

# 

# This project implements and analyzes both counter architectures using Verilog HDL.

# 

# The project includes:

# 

# \- Ring counter RTL implementation.

# \- Johnson counter RTL implementation.

# \- Synchronous-reset counter variants.

# \- Asynchronous-reset counter variants.

# \- Self-checking functional simulation.

# \- Reset behavior verification.

# \- State-sequence verification.

# \- Comparison between corresponding implementations.

# \- Cadence Genus synthesis and technology mapping.

# \- Cell-area analysis.

# \- Power analysis.

# \- Timing-report interpretation.

# 

# The objective is to understand the functional differences between these counters and examine their synthesized implementation using a standard-cell technology library.

# 

# \---

# 

# \# 3. Objective

# 

# The main objectives of this project are:

# 

# 1\. Understand sequential logic and shift-register-based counters.

# 2\. Understand ring-counter architecture.

# 3\. Understand Johnson-counter architecture.

# 4\. Analyze feedback connections in both counter types.

# 5\. Understand synchronous and asynchronous reset behavior.

# 6\. Implement counter logic using synthesizable Verilog.

# 7\. Verify expected counter state sequences.

# 8\. Compare RTL and alternate counter implementations.

# 9\. Verify reset values and state transitions.

# 10\. Analyze simulation waveforms using the SHM database.

# 11\. Synthesize the design using Cadence Genus.

# 12\. Analyze the technology-mapped standard cells.

# 13\. Compare the reported cell areas of the implementations.

# 14\. Understand register, logic, and clock power contributions.

# 15\. Interpret timing slack and identify the type of reported timing path.

# 16\. Document the RTL-to-standard-cell synthesis results.

# 

# \---

# 

# \# 4. Ring Counter Concept

# 

# A \*\*Ring Counter\*\* is a sequential circuit in which the output of the last flip-flop is connected directly to the input of the first flip-flop.

# 

# A logic `1` circulates through the register while the remaining bits contain `0` in the intended one-hot sequence.

# 

# For a 4-bit ring counter, the sequence exercised in this project is:

# 

# ```text

# 0001 → 0010 → 0100 → 1000 → 0001 → ...

# ```

# 

# At every active clock edge, the stored pattern shifts to the next position.

# 

# \### Conceptual Hardware

# 

# ```text

# &#x20;         ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐

# &#x20;    ┌───►│ DFF │──►│ DFF │──►│ DFF │──►│ DFF │───┐

# &#x20;    │    └─────┘   └─────┘   └─────┘   └─────┘   │

# &#x20;    └─────────────────────────────────────────────┘

# ```

# 

# The final-stage output is fed back directly to the first stage.

# 

# \### Basic Operation

# 

# ```text

# Initial State = 0001

# 

# Clock 1 → 0010

# Clock 2 → 0100

# Clock 3 → 1000

# Clock 4 → 0001

# ```

# 

# The counter repeats the same four-state sequence when initialized to the intended one-hot state.

# 

# \---

# 

# \# 5. Johnson Counter Concept

# 

# A \*\*Johnson Counter\*\*, also called a twisted-ring counter, is a shift-register counter in which the inverted output of the final stage is fed back to the first stage.

# 

# For the 4-bit Johnson counter in this project, the tested sequence is:

# 

# ```text

# 0000 → 0001 → 0011 → 0111 → 1111

# &#x20;    → 1110 → 1100 → 1000 → 0000 → ...

# ```

# 

# The register first fills with `1`s and then shifts the `1`s out until the state returns to `0000`.

# 

# \### Conceptual Hardware

# 

# ```text

# &#x20;         ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐

# &#x20;    ┌───►│ DFF │──►│ DFF │──►│ DFF │──►│ DFF │───┐

# &#x20;    │    └─────┘   └─────┘   └─────┘   └─────┘   │

# &#x20;    └─────────────────────────────── NOT ◄────────┘

# ```

# 

# The feedback path contains an inversion.

# 

# \### Basic Operation

# 

# ```text

# Initial State = 0000

# 

# Clock 1 → 0001

# Clock 2 → 0011

# Clock 3 → 0111

# Clock 4 → 1111

# Clock 5 → 1110

# Clock 6 → 1100

# Clock 7 → 1000

# Clock 8 → 0000

# ```

# 

# A correctly implemented n-bit Johnson counter can produce up to `2n` states in its intended sequence. The supplied simulation confirms the eight-state sequence for this 4-bit implementation.

# 

# \---

# 

# \# 6. Ring Counter vs. Johnson Counter

# 

# | Feature | Ring Counter | Johnson Counter |

# |---|---|---|

# | Feedback | Direct feedback | Inverted feedback |

# | Reset state used | `0001` | `0000` |

# | Tested sequence length | 4 states | 8 states |

# | State pattern | One-hot bit circulates | Ones fill and then shift out |

# | Feedback inversion | Not required | Required |

# | Main consideration | Correct initialization | Correct feedback and initialization |

# 

# \### Main Difference

# 

# The main architectural difference is the feedback connection.

# 

# ```text

# Ring Counter:

# Last-stage output → First-stage input

# 

# Johnson Counter:

# Inverted last-stage output → First-stage input

# ```

# 

# This difference changes the state sequence generated by the counter.

# 

# \---

# 

# \# 7. Reset Principle

# 

# The project contains synchronous-reset and asynchronous-reset variants.

# 

# Reset initializes the counter to its intended starting state.

# 

# | Counter | Synchronous Reset State | Asynchronous Reset State |

# |---|---|---|

# | Ring Counter | `0001` | `0001` |

# | Johnson Counter | `0000` | `0000` |

# 

# \### Synchronous Reset

# 

# A synchronous reset is applied at the active clock edge.

# 

# ```text

# Reset asserted

# &#x20;     ↓

# Active clock edge

# &#x20;     ↓

# Counter enters reset state

# ```

# 

# \### Asynchronous Reset

# 

# An asynchronous reset can change the stored state independently of the active clock edge, subject to the reset polarity and sensitivity specified in the RTL.

# 

# ```text

# Reset asserted

# &#x20;     ↓

# Counter enters reset state

# ```

# 

# \### Important Observation

# 

# The supplied simulation confirms matching reset values for the synchronous and asynchronous variants of each counter.

# 

# However, the reset mechanisms remain different and should be analyzed separately when considering timing, reset release, and standard-cell mapping.

# 

# \---

# 

# \# 8. Hardware Architecture

# 

# The project contains multiple implementations of the two counter architectures.

# 

# ```text

# &#x20;             ring\_johnson\_counter\_top

# &#x20;                        |

# &#x20;         ┌──────────────┴──────────────┐

# &#x20;         |                             |

# &#x20;   Ring Counter                  Johnson Counter

# &#x20;         |                             |

# &#x20;    ┌────┼────┐                  ┌────┼────┐

# &#x20;    |    |    |                  |    |    |

# &#x20;   RTL  Sync Async              RTL  Sync Async

# ```

# 

# \### Main Hardware Components

# 

# \- Flip-flops for state storage.

# \- Clock input for sequential state updates.

# \- Reset logic.

# \- Direct feedback connection for the ring counter.

# \- Inverted feedback connection for the Johnson counter.

# \- Supporting logic introduced during synthesis and technology mapping.

# 

# \---

# 

# \# 9. Logical Hierarchy

# 

# The reported Genus hierarchy contains the following modules:

# 

# ```text

# ring\_johnson\_counter\_top

# │

# ├── JOHNSON\_ASYNC

# │   └── johnson\_counter\_async

# │

# ├── JOHNSON\_RTL

# │   └── johnson\_counter\_rtl

# │

# ├── JOHNSON\_SYNC

# │   └── johnson\_counter\_sync

# │

# ├── RING\_ASYNC

# │   └── ring\_counter\_async

# │

# ├── RING\_RTL

# │   └── ring\_counter\_rtl

# │

# └── RING\_SYNC

# &#x20;   └── ring\_counter\_sync

# ```

# 

# \### Reported Hierarchy Results

# 

# | Implementation | Reported Cell Count | Reported Cell Area |

# |---|---:|---:|

# | `JOHNSON\_ASYNC` / `johnson\_counter\_async` | 9 | 312.682 |

# | `JOHNSON\_RTL` / `johnson\_counter\_rtl` | 6 | 239.501 |

# | `JOHNSON\_SYNC` / `johnson\_counter\_sync` | 9 | 259.459 |

# | `RING\_ASYNC` / `ring\_counter\_async` | 8 | 299.376 |

# | `RING\_RTL` / `ring\_counter\_rtl` | 6 | 242.827 |

# | `RING\_SYNC` / `ring\_counter\_sync` | 8 | 256.133 |

# | \*\*Top-level `ring\_johnson\_counter\_top`\*\* | \*\*46\*\* | \*\*1609.978\*\* |

# 

# \### Important Observation

# 

# The top-level module contains all reported implementations.

# 

# Therefore, the top-level area represents the reported combined design, not the area of only one isolated ring counter or Johnson counter.

# 

# Hierarchy entries must not be summed blindly because parent and child reports can represent overlapping portions of the design.

# 

# \---

# 

# \# 10. Functional Specification

# 

# \## Inputs

# 

# | Signal | Description |

# |---|---|

# | `clk` | Clock input for sequential state updates |

# | `reset` | Reset control defined by the corresponding RTL |

# | Other controls | Any implementation-specific signals defined in the RTL |

# 

# \## Outputs

# 

# | Counter | Description |

# |---|---|

# | Ring counter state | Current 4-bit ring-counter state |

# | Johnson counter state | Current 4-bit Johnson-counter state |

# 

# \## Expected Functional Behavior

# 

# \### Ring Counter

# 

# ```text

# Reset State = 0001

# 

# 0001 → 0010 → 0100 → 1000 → 0001

# ```

# 

# \### Johnson Counter

# 

# ```text

# Reset State = 0000

# 

# 0000 → 0001 → 0011 → 0111 → 1111

# &#x20;    → 1110 → 1100 → 1000 → 0000

# ```

# 

# \### Reset Behavior

# 

# \- Ring counter reset state: `0001`.

# \- Johnson counter reset state: `0000`.

# \- Synchronous and asynchronous variants use matching reset values.

# \- The simulation compares corresponding implementations.

# 

# Exact signal names and reset polarity should be checked against the RTL source when reproducing the design.

# 

# \---

# 

# \# 11. RTL Design

# 

# The RTL describes the sequential state transitions of both counter architectures.

# 

# \### Ring Counter Logic

# 

# Conceptually:

# 

# ```text

# Initialize counter to 0001

# &#x20;            ↓

# Wait for active clock edge

# &#x20;            ↓

# Shift the stored pattern

# &#x20;            ↓

# Feed the last stage back to the first

# &#x20;            ↓

# Repeat the sequence

# ```

# 

# \### Johnson Counter Logic

# 

# Conceptually:

# 

# ```text

# Initialize counter to 0000

# &#x20;            ↓

# Wait for active clock edge

# &#x20;            ↓

# Shift the stored pattern

# &#x20;            ↓

# Invert the last-stage feedback

# &#x20;            ↓

# Repeat the sequence

# ```

# 

# \### Important RTL Concepts

# 

# \- Sequential `always` blocks.

# \- Positive-edge-triggered state updates.

# \- Nonblocking assignments for sequential state.

# \- Reset priority and reset sensitivity.

# \- Shift-register operation.

# \- Direct feedback and inverted feedback.

# \- State retention between active clock edges.

# 

# The precise RTL implementation should be reviewed directly from the source files before making claims about coding style or inferred hardware.

# 

# \---

# 

# \# 12. Verification Strategy

# 

# The project uses a self-checking testbench to verify the expected functional behavior.

# 

# The supplied simulation log contains eight main test sections.

# 

# 1\. NOT-gate checks.

# 2\. D flip-flop reset and data-capture checks.

# 3\. 4-bit shift-register checks.

# 4\. Ring-counter sequence checks.

# 5\. Johnson-counter sequence checks.

# 6\. Asynchronous-reset checks.

# 7\. Synchronous-reset checks.

# 8\. Reset-value consistency checks.

# 

# \### Verification Flow

# 

# ```text

# Initialize Testbench

# &#x20;        ↓

# Check Basic Logic

# &#x20;        ↓

# Check DFF Behavior

# &#x20;        ↓

# Check Shift Register

# &#x20;        ↓

# Verify Ring Counter Sequence

# &#x20;        ↓

# Verify Johnson Counter Sequence

# &#x20;        ↓

# Verify Reset Variants

# &#x20;        ↓

# Compare Corresponding Outputs

# &#x20;        ↓

# Report PASS / FAIL

# ```

# 

# \---

# 

# \# 13. Ring Counter Verification

# 

# The testbench checks the ring counter reset state and its state transitions.

# 

# \### Expected Sequence

# 

# | Step | Expected State |

# |---:|---|

# | Reset | `0001` |

# | 1 | `0010` |

# | 2 | `0100` |

# | 3 | `1000` |

# | 4 | `0001` |

# 

# \### Verification Result

# 

# The supplied simulation log reports that:

# 

# \- The synchronous ring counter resets to `0001`.

# \- The RTL ring counter resets to `0001`.

# \- The expected ring-counter sequence is observed.

# \- Corresponding implementation comparisons pass.

# 

# \*\*Result: PASS\*\*

# 

# This result applies to the scenarios exercised in the supplied simulation.

# 

# \---

# 

# \# 14. Johnson Counter Verification

# 

# The testbench checks the Johnson counter reset state and the expected eight-state sequence.

# 

# \### Expected Sequence

# 

# | Step | Expected State |

# |---:|---|

# | Reset | `0000` |

# | 1 | `0001` |

# | 2 | `0011` |

# | 3 | `0111` |

# | 4 | `1111` |

# | 5 | `1110` |

# | 6 | `1100` |

# | 7 | `1000` |

# | 8 | `0000` |

# 

# \### Verification Result

# 

# The supplied simulation log reports that:

# 

# \- The synchronous Johnson counter resets to `0000`.

# \- The RTL Johnson counter resets to `0000`.

# \- The expected Johnson-counter sequence is observed.

# \- Corresponding implementation comparisons pass.

# 

# \*\*Result: PASS\*\*

# 

# \---

# 

# \# 15. Reset Verification

# 

# The simulation exercises synchronous and asynchronous reset behavior for both counter architectures.

# 

# | Test | Ring Counter | Johnson Counter |

# |---|---|---|

# | Synchronous reset | `0001` | `0000` |

# | Asynchronous reset | `0001` | `0000` |

# | Reset-value consistency | PASS | PASS |

# | Variant comparison in supplied tests | PASS | PASS |

# 

# \### Synchronous Reset

# 

# The simulation checks reset behavior in relation to the clock edge.

# 

# \### Asynchronous Reset

# 

# The simulation checks reset behavior without requiring the reset assertion to coincide with an active clock edge.

# 

# \### Important Limitation

# 

# The log supports the reset scenarios exercised by the testbench. It does not, by itself, establish exhaustive reset-release coverage or formal equivalence between all implementations.

# 

# \---

# 

# \# 16. Overall Verification Results

# 

# The supplied simulation log reports the following final status:

# 

# ```text

# DAY 12 SELF-CHECKING TEST COMPLETE

# 

# DAY 12 PASS - ALL TESTS PASSED

# 

# Total Errors = 0

# 

# $finish at 228 ns

# ```

# 

# \### Verification Summary

# 

# | Verification Item | Result |

# |---|---|

# | NOT-gate checks | PASS |

# | DFF reset and capture checks | PASS |

# | Shift-register checks | PASS |

# | Ring-counter sequence | PASS |

# | Johnson-counter sequence | PASS |

# | Asynchronous-reset checks | PASS |

# | Synchronous-reset checks | PASS |

# | Reset-value consistency | PASS |

# | Total reported errors | 0 |

# | Simulation completion time | 228 ns |

# 

# The testbench completed with zero reported errors.

# 

# This is evidence for the tested scenarios, not a claim of exhaustive functional coverage, formal verification, or post-route sign-off.

# 

# \---

# 

# \# 17. Simulation and Waveforms

# 

# The simulation was run using Cadence Xcelium (`ncsim`).

# 

# The waveform database was created as:

# 

# ```text

# waves.shm

# ```

# 

# The testbench probes signals under the `day12\_tb` hierarchy.

# 

# \### Recommended Waveform Checks

# 

# 1\. Confirm reset assertion and release.

# 2\. Confirm the ring counter begins at `0001`.

# 3\. Confirm the ring counter cycles through its four expected states.

# 4\. Confirm the Johnson counter begins at `0000`.

# 5\. Confirm the Johnson counter cycles through its eight expected states.

# 6\. Compare the outputs of corresponding RTL and reset variants.

# 7\. Inspect reset assertion relative to the clock.

# 8\. Check that each state transition occurs at the intended clock event.

# 

# The simulation log confirms the reported test results. Detailed waveform timing measurements should only be added after inspecting the actual SHM waveform database.

# 

# \---

# 

# \# 18. Synthesis Flow

# 

# The project uses Cadence Genus for RTL synthesis and technology mapping.

# 

# ```text

# &#x20;               Verilog RTL

# &#x20;                   |

# &#x20;                   v

# &#x20;             Elaboration

# &#x20;                   |

# &#x20;                   v

# &#x20;            Generic Logic

# &#x20;                   |

# &#x20;                   v

# &#x20;              Optimization

# &#x20;                   |

# &#x20;                   v

# &#x20;           Technology Mapping

# &#x20;                   |

# &#x20;                   v

# &#x20;            TSMC18 Cells

# &#x20;                   |

# &#x20;         +---------+---------+

# &#x20;         |         |         |

# &#x20;         v         v         v

# &#x20;        Area     Timing     Power

# ```

# 

# \### Synthesis Environment

# 

# | Parameter | Value |

# |---|---|

# | Synthesis tool | Cadence Genus |

# | Tool version | 21.14-s082\_1 |

# | Technology library | `tsmc18` |

# | Top module | `ring\_johnson\_counter\_top` |

# 

# The reported synthesis results are used to analyze the combined hierarchy and its mapped standard cells.

# 

# \---

# 

# \# 19. Technology Mapping

# 

# The technology-mapping report contains the following standard cells.

# 

# | Standard Cell | Instances | Reported Area |

# |---|---:|---:|

# | `DFFHQX1` | 2 | 106.445 |

# | `DFFHQXL` | 1 | 53.222 |

# | `DFFRHQX1` | 7 | 488.981 |

# | `DFFSXL` | 1 | 63.202 |

# | `DFFTRX1` | 7 | 395.842 |

# | `DFFTRXL` | 6 | 339.293 |

# | `INVX1` | 4 | 26.611 |

# | `INVXL` | 15 | 99.792 |

# | `NOR2X1` | 1 | 9.979 |

# | `OR2X2` | 2 | 26.611 |

# | \*\*Total\*\* | \*\*46\*\* | \*\*1609.978\*\* |

# 

# \### Mapping Observation

# 

# The mapped design contains sequential cells, inverters, and logic cells.

# 

# The reported mapping indicates that sequential storage elements account for the majority of the cell area.

# 

# The table describes the reported combined top-level design. It is not a separate mapping breakdown for each counter implementation.

# 

# \---

# 

# \# 20. Standard-Cell Area Distribution

# 

# The reported top-level cell area is:

# 

# ```text

# Total Cell Area = 1609.978

# ```

# 

# \### Area Classification

# 

# | Cell Category | Instances | Reported Area | Area Percentage |

# |---|---:|---:|---:|

# | Sequential | 24 | 1446.984 | 89.9% |

# | Inverter | 19 | 126.403 | 7.9% |

# | Logic | 3 | 36.590 | 2.3% |

# | Physical cells | 0 | 0.000 | 0.0% |

# | \*\*Total\*\* | \*\*46\*\* | \*\*1609.978\*\* | \*\*100% approximately\*\* |

# 

# \### Observation

# 

# Sequential cells dominate the reported area:

# 

# ```text

# Sequential Area = 1446.984

# ```

# 

# ```text

# Sequential Area Percentage ≈ 89.9%

# ```

# 

# This is consistent with the design's shift-register-based architecture, which relies on flip-flops to store the counter state.

# 

# The reported cell area is a synthesis result. It should not be interpreted as final routed core area.

# 

# \---

# 

# \# 21. Hierarchical Area Comparison

# 

# The reported child implementation areas are ranked below.

# 

# | Rank | Implementation | Reported Area |

# |---:|---|---:|

# | 1 | Johnson RTL | 239.501 |

# | 2 | Ring RTL | 242.827 |

# | 3 | Ring synchronous reset | 256.133 |

# | 4 | Johnson synchronous reset | 259.459 |

# | 5 | Ring asynchronous reset | 299.376 |

# | 6 | Johnson asynchronous reset | 312.682 |

# 

# \### Lowest Reported Area

# 

# The Johnson RTL implementation has the lowest reported area:

# 

# ```text

# Johnson RTL Area = 239.501

# ```

# 

# The Ring RTL implementation has a reported area of:

# 

# ```text

# Ring RTL Area = 242.827

# ```

# 

# The relative difference is approximately:

# 

# ```text

# (242.827 - 239.501) / 242.827 × 100

# ≈ 1.37%

# ```

# 

# Therefore, the reported Johnson RTL area is approximately 1.37% lower than the reported Ring RTL area.

# 

# This comparison concerns the reported synthesis areas only. It does not establish better timing, lower power, or overall PPA superiority.

# 

# \---

# 

# \# 22. Synchronous vs. Asynchronous Reset Area

# 

# The reported areas can also be compared by reset type.

# 

# | Counter | Synchronous Area | Asynchronous Area | Approximate Async Increase |

# |---|---:|---:|---:|

# | Ring Counter | 256.133 | 299.376 | 16.88% |

# | Johnson Counter | 259.459 | 312.682 | 20.51% |

# 

# \### Interpretation

# 

# For the reported implementations:

# 

# \- The ring asynchronous-reset variant has a larger reported area than the ring synchronous-reset variant.

# \- The Johnson asynchronous-reset variant has a larger reported area than the Johnson synchronous-reset variant.

# \- The difference depends on the RTL, the selected library cells, and the synthesis mapping.

# 

# These results should not be generalized to other technology libraries or design constraints without additional synthesis evidence.

# 

# \---

# 

# \# 23. Instance Analysis

# 

# The technology-mapping report contains 46 instances in the combined top-level design.

# 

# \### Sequential Instances

# 

# ```text

# DFFHQX1

# DFFHQXL

# DFFRHQX1

# DFFSXL

# DFFTRX1

# DFFTRXL

# ```

# 

# \### Combinational Instances

# 

# ```text

# INVX1

# INVXL

# NOR2X1

# OR2X2

# ```

# 

# \### Category Summary

# 

# | Category | Instances |

# |---|---:|

# | Sequential cells | 24 |

# | Inverters | 19 |

# | Logic cells | 3 |

# | Physical cells | 0 |

# | \*\*Total\*\* | \*\*46\*\* |

# 

# The instance count describes the mapped combined design. The top-level instance count should not be confused with the number of registers in a single counter.

# 

# \---

# 

# \# 24. Power Analysis

# 

# The reported power estimate for the top-level design is:

# 

# ```text

# Total Power = 1.61917 × 10⁻⁴ W

# ```

# 

# Equivalent value:

# 

# ```text

# Total Power ≈ 161.917 µW

# ```

# 

# The report is associated with the power-analysis frame:

# 

# ```text

# /stim#0/frame#0

# ```

# 

# The result depends on the analysis setup, cell models, and activity assumptions associated with that report.

# 

# \### Power Summary

# 

# | Category | Reported Total Power |

# |---|---:|

# | Registers | 1.43856e-04 W |

# | Logic | 9.23159e-07 W |

# | Clock switching | 1.71373e-05 W |

# | \*\*Reported subtotal\*\* | \*\*1.61917e-04 W\*\* |

# 

# The power report is for the combined top-level design. Separate power results for each counter implementation were not supplied in the available report summary.

# 

# \---

# 

# \# 25. Power Breakdown

# 

# The detailed power report gives the following values.

# 

# | Category | Leakage | Internal | Switching | Total |

# |---|---:|---:|---:|---:|

# | Registers | 4.24327e-08 W | 1.42885e-04 W | 9.29038e-07 W | 1.43856e-04 W |

# | Logic | 3.99306e-09 W | 7.36508e-07 W | 1.82658e-07 W | 9.23159e-07 W |

# | Clock switching | — | — | 1.71373e-05 W | 1.71373e-05 W |

# | \*\*Subtotal\*\* | \*\*4.64257e-08 W\*\* | \*\*1.43621e-04 W\*\* | \*\*1.82490e-05 W\*\* | \*\*1.61917e-04 W\*\* |

# 

# \### Power Component Percentages

# 

# | Power Component | Approximate Share |

# |---|---:|

# | Leakage | 0.03% |

# | Internal | 88.70% |

# | Switching | 11.27% |

# 

# Percentages are rounded, so the displayed values may not sum to exactly 100%.

# 

# \---

# 

# \# 26. Power Interpretation

# 

# The reported power distribution is dominated by internal power.

# 

# ```text

# Internal Power ≈ 88.70%

# Switching Power ≈ 11.27%

# Leakage Power ≈ 0.03%

# ```

# 

# The register category contributes most of the reported total power:

# 

# ```text

# Register Power = 1.43856e-04 W

# ```

# 

# The reported clock-switching contribution is:

# 

# ```text

# Clock Switching Power = 1.71373e-05 W

# ```

# 

# \### Interpretation

# 

# The reported result indicates that register-related power is the largest contributor in this analysis frame.

# 

# However, this is a top-level result. It cannot be used to rank the six counter implementations by power because separate per-implementation power results are not available in the supplied report summary.

# 

# \---

# 

# \# 27. Timing Analysis

# 

# The supplied Genus timing report contains:

# 

# ```text

# Path 1: MET (7506 ps) Setup Check

# ```

# 

# The reported slack is:

# 

# ```text

# Slack = +7506 ps

# ```

# 

# Equivalent value:

# 

# ```text

# Slack = +7.506 ns

# ```

# 

# \### Reported Timing Values

# 

# | Timing Parameter | Reported Value |

# |---|---:|

# | Capture clock edge | 10000 ps |

# | Launch clock edge | 0 ps |

# | Setup time | 321 ps |

# | Clock uncertainty | 1000 ps |

# | Required time | 8679 ps |

# | Input delay | 1000 ps |

# | Data-path delay | 173 ps |

# | \*\*Slack\*\* | \*\*+7506 ps\*\* |

# | Timing status | \*\*MET\*\* |

# 

# \### Reported Path

# 

# The detailed path identifies the reset input as the startpoint and the `RING\_RTL/Q\_reg\[0]/D` pin as the endpoint.

# 

# The reported logic path includes:

# 

# ```text

# RING\_RTL/g4\_\_5107/Y

# ```

# 

# with the cell:

# 

# ```text

# OR2X2

# ```

# 

# The reported data-path delay is 173 ps.

# 

# \---

# 

# \# 28. Timing Interpretation

# 

# The timing report indicates that the specific reported setup check passes with positive slack.

# 

# ```text

# Reported Slack = +7.506 ns

# ```

# 

# However, the detailed path is a \*\*reset-input-to-register-D path\*\*, not a conventional register-to-register data path.

# 

# Therefore, the result should not be interpreted as the maximum operating frequency of the ring or Johnson counter.

# 

# A complete timing analysis would need to examine the relevant constrained paths, including register-to-register paths, and account for the intended clock and I/O constraints.

# 

# \### Important Limitation

# 

# The available report does not establish:

# 

# \- The maximum functional operating frequency.

# \- The critical path for every counter implementation.

# \- A complete timing sign-off result.

# \- A timing comparison between all six child implementations.

# 

# The reported positive slack applies to the specific check shown in the supplied report.

# 

# \---

# 

# \# 29. PPA Summary

# 

# PPA refers to:

# 

# ```text

# P = Power

# P = Performance

# A = Area

# ```

# 

# \### Combined Results

# 

# | Metric | Reported Result | Scope |

# |---|---:|---|

# | Top-level cell count | 46 | Combined design |

# | Top-level cell area | 1609.978 | Combined hierarchy |

# | Top-level total power | 161.917 µW | Reported power frame |

# | Setup slack | +7.506 ns | Reset-to-D setup check |

# | Functional simulation | PASS | Supplied testbench scenarios |

# | Total simulation errors | 0 | Supplied simulation log |

# | Simulation completion | 228 ns | Supplied simulation log |

# | Lowest reported child area | 239.501 | Johnson RTL |

# | Per-variant power comparison | Not reported | Insufficient data |

# | Per-variant critical-path comparison | Not reported | Insufficient data |

# | Maximum functional frequency | Not established | Requires further timing analysis |

# 

# \### PPA Interpretation

# 

# The available evidence provides functional simulation results and selected synthesis-analysis results.

# 

# The top-level area and power refer to the combined design, while the child area values refer to individual hierarchy entries. These values should not be combined into a single implementation-level PPA ranking.

# 

# \---

# 

# \# 30. Optimization Opportunities

# 

# The following are potential areas for further investigation, not claims of measured improvement.

# 

# 1\. \*\*Analyze each implementation separately.\*\* Synthesize the ring and Johnson variants independently under consistent constraints to obtain a fair area comparison.

# 2\. \*\*Review reset-cell mapping.\*\* Inspect the standard cells selected for synchronous and asynchronous reset behavior.

# 3\. \*\*Check critical timing paths.\*\* Generate full timing reports and identify register-to-register paths before making frequency claims.

# 4\. \*\*Compare power under consistent conditions.\*\* Use equivalent clock constraints and activity assumptions when comparing counter variants.

# 5\. \*\*Review state initialization.\*\* Verify the intended reset state and behavior if the counter enters an unexpected state.

# 6\. \*\*Expand reset verification.\*\* Test reset assertion and release around clock edges.

# 7\. \*\*Improve coverage.\*\* Record state, transition, and reset coverage for the testbench.

# 8\. \*\*Validate mapped behavior.\*\* Run gate-level simulation or formal equivalence if those checks are required by the project objectives.

# 

# Any claimed improvement must be supported by new simulation, synthesis, timing, or power results.

# 

# \---

# 

# \# 31. Verification Evidence and Limitations

# 

# \### Available Evidence

# 

# \- Self-checking simulation log.

# \- Passing ring-counter sequence checks.

# \- Passing Johnson-counter sequence checks.

# \- Passing reset checks.

# \- Passing variant comparisons for the scenarios exercised.

# \- Final simulation status with zero reported errors.

# \- SHM waveform database creation.

# \- Genus hierarchy report.

# \- Technology-mapping report.

# \- Top-level power report.

# \- A reported setup timing check.

# 

# \### Limitations

# 

# The supplied evidence does not establish:

# 

# \- Exhaustive functional coverage.

# \- Formal equivalence between all variants.

# \- Post-synthesis gate-level simulation equivalence.

# \- Post-route parasitic-aware timing.

# \- Physical design sign-off.

# \- Per-variant power rankings.

# \- Per-variant critical-path rankings.

# \- Maximum operating frequency.

# 

# These distinctions are important when documenting the project for technical review or interviews.

# 

# \---

# 

# \# 32. Interview Questions

# 

# 1\. What is a ring counter?

# 2\. What is a Johnson counter?

# 3\. What is the difference between their feedback connections?

# 4\. Why does a 4-bit ring counter have a four-state one-hot sequence in this example?

# 5\. Why can a 4-bit Johnson counter produce an eight-state sequence?

# 6\. What happens if a ring counter is initialized to an unintended state?

# 7\. What is the difference between synchronous and asynchronous reset?

# 8\. Why can reset type affect standard-cell mapping?

# 9\. Why should hierarchy-level area reports not be summed blindly?

# 10\. What information does a technology-mapping report provide?

# 11\. What is the difference between internal, switching, and leakage power?

# 12\. What does positive setup slack indicate?

# 13\. Why does a reset-to-D timing path not establish maximum operating frequency?

# 14\. Why must PPA comparisons use consistent constraints?

# 15\. What additional verification would be needed to claim formal equivalence?

# 16\. How would you test reset assertion and release in a sequential design?

# 

# \---

# 

# \# 33. Tiny Memory

# 

# ```text

# 1\. Ring counter uses direct feedback.

# 2\. Johnson counter uses inverted feedback.

# 3\. The tested 4-bit ring sequence has four states.

# 4\. The tested 4-bit Johnson sequence has eight states.

# 5\. Ring counter reset state = 0001.

# 6\. Johnson counter reset state = 0000.

# 7\. Synchronous and asynchronous reset mechanisms differ.

# 8\. Positive setup slack means the specific timing check passed.

# 9\. A single timing path does not establish maximum frequency.

# 10\. Hierarchical area results must be interpreted carefully.

# ```

# 

# \---

# 

# \# 34. Learning Outcomes

# 

# After completing Day 12, the project provides experience with:

# 

# \- Ring-counter architecture.

# \- Johnson-counter architecture.

# \- Shift-register-based state transitions.

# \- Synchronous and asynchronous reset behavior.

# \- Self-checking Verilog testbenches.

# \- Functional simulation and waveform inspection.

# \- Comparison of RTL and alternate implementations.

# \- Cadence Genus synthesis.

# \- Standard-cell technology mapping.

# \- Hierarchical cell-area analysis.

# \- Register, logic, and clock power interpretation.

# \- Timing slack and path classification.

# \- Evidence-based VLSI project documentation.

# 

# \---

# 

# \# 35. Project Status

# 

# | Stage | Status |

# |---|---|

# | Counter architecture | Documented |

# | RTL implementation variants | Present in reported hierarchy |

# | Self-checking simulation | \*\*PASS — 0 reported errors\*\* |

# | Ring-counter sequence | PASS |

# | Johnson-counter sequence | PASS |

# | Reset verification scenarios | PASS |

# | Waveform database | Created |

# | Genus synthesis analysis | Reported |

# | Technology mapping | Reported |

# | Area analysis | Reported |

# | Top-level power analysis | Reported |

# | Timing analysis | One setup check reported |

# | Per-variant power comparison | Not available |

# | Per-variant critical timing comparison | Not available |

# | Formal verification | Not established |

# | Physical design sign-off | Not established |

# 

# \---

# 

# \# 36. Final Conclusion

# 

# Day 12 implements and verifies ring and Johnson counters using Verilog HDL. The project covers direct and inverted feedback architectures, expected state sequences, synchronous reset, asynchronous reset, and comparisons between corresponding implementations.

# 

# The supplied Cadence Xcelium simulation log reports that all listed test scenarios passed, with zero reported errors and simulation completion at 228 ns.

# 

# The Cadence Genus results report 46 mapped cells and a combined top-level cell area of `1609.978`. The reported top-level power estimate is approximately `161.917 µW`. Among the six reported child implementations, Johnson RTL has the lowest area at `239.501`, followed by Ring RTL at `242.827`.

# 

# The timing report shows `+7.506 ns` of slack for a reset-input-to-register-D setup check. This result does not establish maximum operating frequency or complete timing sign-off.

# 

# Overall, the project demonstrates functional simulation and selected synthesis analyses. Formal equivalence, exhaustive coverage, per-variant power and timing superiority, and physical design sign-off have not been established by the available evidence.

# 

# \---

# 

# \# 37. Author

# 

# \*\*Omkar Kalmesh Hadapad\*\*

# 

# B.E. Electronics \& Communication Engineering  

# SDM Institute of Technology, Ujire, Karnataka

# 

# \*\*Technical Focus:\*\* Digital VLSI • Verilog HDL • RTL Design • ASIC Design • Design Verification • Cadence Genus • Cadence Innovus • PPA Analysis

# 

# \---

# 

# <p align="center">

# &#x20; <b>DAY 12 — RING COUNTER AND JOHNSON COUNTER</b>

# </p>

# 

# <p align="center">

# &#x20; <code>RTL → Verification → Synthesis → Technology Mapping → Area → Power → Timing</code>

# </p>



