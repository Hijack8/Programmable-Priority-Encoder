# generate_reports.tcl

# Source common functions
source "$SCRIPT_PATH/common_functions.tcl"

# Stage 7: Generate reports
stage_message 7 "Generating reports" 1

# Create report directory if it doesn't exist
file mkdir "$REPORT_PATH"

set PPE_H_WIDTH [getenv "PPE_H_WIDTH"]

# Generate various reports
# report_compile_options > "$REPORT_PATH/compile_options.rpt"
# report_constraint -all_violators > "$REPORT_PATH/constraint_violators.rpt"
report_timing > "$REPORT_PATH/${PPE_H_WIDTH}_timing.rpt"
report_timing -delay max -max_paths 5000 > "$REPORT_PATH/${PPE_H_WIDTH}_timing_max_paths.rpt"
report_timing -from Req_reg -to o_value_inc > "$REPORT_PATH/${PPE_H_WIDTH}_timing_path.rpt"

# report_fanout -all > "$REPORT_PATH/fanout.rpt"
# report_netlist > "$REPORT_PATH/netlist.rpt"

report_area > "$REPORT_PATH/${PPE_H_WIDTH}_area.rpt"
report_power > "$REPORT_PATH/${PPE_H_WIDTH}_power.rpt"
report_resources > "$REPORT_PATH/${PPE_H_WIDTH}_resources.rpt"
report_design > "$REPORT_PATH/${PPE_H_WIDTH}_design.rpt"
report_clock > "$REPORT_PATH/${PPE_H_WIDTH}_clock.rpt"

stage_message 7 "Reports generated" 0
