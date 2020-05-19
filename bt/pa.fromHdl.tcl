
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name bt -dir "C:/Users/utp/Documents/Diablo III/bt/planAhead_run_1" -part xc3s100ecp132-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "receiver.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {receiver.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top receiver $srcset
add_files [list {receiver.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s100ecp132-4
