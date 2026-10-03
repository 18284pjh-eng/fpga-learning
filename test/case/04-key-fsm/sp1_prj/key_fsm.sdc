# Board clock: 50 MHz = 20 ns period.
create_clock -name clk -period 20.000 [get_ports {clk}]

# Use the tool's default clock uncertainty model after the base clock exists.
derive_clock_uncertainty
