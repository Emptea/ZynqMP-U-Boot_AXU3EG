# 1. Запрещаем оптимизировать отладочный хаб и ядро ILA
set_property DONT_TOUCH true [get_cells dbg_hub]
set_property DONT_TOUCH true [get_cells u_ila_0]

# 2. Задаем частоту для JTAG хаба (чтобы он не ждал клок от Zynq)
set_property C_CLK_INPUT_FREQ_HZ 100000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
