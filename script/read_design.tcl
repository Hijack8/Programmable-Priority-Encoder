# read_design.tcl

# Source common functions
source "$SCRIPT_PATH/common_functions.tcl"

# Stage 3: Read design files
stage_message 3 "Reading design files" 1

# Get all Verilog files under the RTL directory
set rtl_files [get_verilog_files $RTL_PATH]
set ppe_c_width [getenv "PPE_C_WIDTH"]
set ppe_c_log_w [getenv "PPE_C_LOG_W"]

# Read all Verilog files
foreach file $rtl_files {
    puts "Reading file: $file"
    set last_slash [string last "/" $file]
    set module_name [string range $file [expr $last_slash + 1] end]
    set module_name [string range $module_name 0 end-2]
    puts $last_slash
    analyze -f verilog $file
    # elaborate $module_name
    puts $file
    puts $module_name
}

# set it top
elaborate ppe_com -parameter "PPE_C_WIDTH=$ppe_c_width,PPE_C_LOG_W=$ppe_c_log_w"

# Set the top-level design
# current_design $TOP_MODULE

puts $ppe_c_width
puts $ppe_c_log_w

link

stage_message 3 "Design files read" 0
