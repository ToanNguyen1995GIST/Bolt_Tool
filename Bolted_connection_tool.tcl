namespace eval ::HM:: {} {}

proc ::HM::message {str_msg str_icon} {
	tk_messageBox -message $str_msg -title "Holes Checking Tool" -icon $str_icon -type ok
	return
}
proc ::HM::main_GUI {} {
	variable gui; global glo; variable arr

	set gui(dirname) [file dirname [info script]]
	set gui(Font) "{MS Sans Serif} 9 roman"
	set gui(H1) [expr [lindex [hm_getpanelarea] end]/7]
	set gui(H2) [expr [lindex [hm_getpanelarea] end]/7-4]
	
	catch {destroy .topwin}
	set gui(mainWin) [toplevel .topwin]
	wm geometry $gui(mainWin) 350x560+20+100
	KeepOnTop $gui(mainWin)
	wm attribute $gui(mainWin) -toolwindow 0
	wm title $gui(mainWin) "BOLTED JOINT TOOL"
	
	set gui(f5) [frame $gui(mainWin).f5]; pack $gui(f5) -side top -fill x
		set gui(bolt_param_file) [button $gui(f5).bolt_param_file -text "Bolt Param File" -font $gui(Font) -width 15 -command ::HM::bolt_param_file]; 
		pack $gui(bolt_param_file) -side left -padx 2 -pady 2
		set gui(bolt_param_entry) [entry $gui(f5).bolt_param_entry -textvariable glo(bolt_parm_path) -font $gui(Font) -width 15];
		pack $gui(bolt_param_entry) -side left -padx 2 -pady 2 -fill both -expand 1
	
	if {[info exist arr(bolt_name_list)]==0} {set arr(bolt_name_list) [list]}
	set gui(f7) [frame $gui(mainWin).f7]; pack $gui(f7) -side top -fill x
		set gui(boltype_label) [label $gui(f7).boltype_label -text "Bolt Types:" -width 12 -anchor w -font $gui(Font)]
		pack $gui(boltype_label) -side left -padx 2 -pady 2 
		set gui(bolt_combo) [ttk::combobox $gui(f7).bolt_combo -textvariable glo(bolt_name) -values $arr(bolt_name_list)]
		pack $gui(bolt_combo) -side left -padx 2 -pady 2 -fill both -expand 1
		bind $gui(bolt_combo) "<<ComboboxSelected>>" {::HM::update_bolt_param}
	
	set name_list [list "Bolt Diam:" "Hole Diam:" "Head Diam:"]
	set variable_list [list "bolt_dia" "hole_dia" "head_dia"]
	foreach name $name_list variable $variable_list {
		set gui(f_$variable) [frame $gui(mainWin).f_$variable]; pack $gui(f_$variable) -side top -fill x
			set gui(label_$variable) [label $gui(f_$variable).label_$variable -text $name -font $gui(Font) -anchor w -width 12]; 
			pack $gui(label_$variable) -side left -padx 2 -pady 2
			set gui(entry_$variable) [entry $gui(f_$variable).entry_$variable -textvariable glo($variable) -font $gui(Font) -width 15];
			pack $gui(entry_$variable) -side left -padx 2 -pady 2 -fill both -expand 1
	}
	
	set gui(separator_0) [ttk::separator $gui(mainWin).separator_0 -orient horizontal];
	pack $gui(separator_0) -side top -fill x -expand 0 -padx 2 -pady 6
	
	set gui(f13) [frame $gui(mainWin).f13]; pack $gui(f13) -side top -fill both -expand 0
		set gui(pre_hole_lb) [label $gui(f13).pre_hole_lb -text "Hole mode:" -width 12 -anchor w -font $gui(Font)]
		pack $gui(pre_hole_lb) -side left -padx 2 -pady 2 
		set gui(pre_hole_com) [ttk::combobox $gui(f13).pre_hole_com -textvariable glo(pre_hole) -values {"Hole existed" "Hole non-existed"}]
		pack $gui(pre_hole_com) -side left -padx 2 -pady 2 -fill both -expand 1
		
	set gui(f1) [frame $gui(mainWin).f1]; pack $gui(f1) -side top -fill x
		set gui(upper_comp_button) [button $gui(f1).upper_comp_button -text "Upper component" -font $gui(Font) -anchor w -width 15 -bg #e6e664 -command ::HM::choose_upper_comp]; 
		pack $gui(upper_comp_button) -side left -padx 2 -pady 2
		set gui(upper_comp_entry) [entry $gui(f1).upper_comp_entry -textvariable glo(upper_comp_name) -font $gui(Font) -width 15];
		pack $gui(upper_comp_entry) -side left -padx 2 -pady 2 -fill both -expand 1 
	
	set gui(f2) [frame $gui(mainWin).f2]; pack $gui(f2) -side top -fill x
		set gui(lower_comp_button) [button $gui(f2).lower_comp_button -text "Lower component" -font $gui(Font) -anchor w -width 15 -bg #e6e664 -command ::HM::choose_lower_comp]; 
		pack $gui(lower_comp_button) -side left -padx 2 -pady 2
		set gui(lower_comp_entry) [entry $gui(f2).lower_comp_entry -textvariable glo(lower_comp_name) -font $gui(Font) -width 15];
		pack $gui(lower_comp_entry) -side left -padx 2 -pady 2 -fill both -expand 1
	
	set gui(f3) [frame $gui(mainWin).f3]; pack $gui(f3) -side top -fill x
		set gui(bolt_axis_button) [button $gui(f3).bolt_axis_button -text "Bolt Axis" -font $gui(Font) -width 15 -bg #e6e664 -command ::HM::bolt_axis]; 
		pack $gui(bolt_axis_button) -side left -padx 2 -pady 2 
		set gui(bolt_axis_xcomp) [entry $gui(f3).bolt_axis_xcomp -textvariable glo(bolt_axis_xcomp) -font $gui(Font) -width 7];
		pack $gui(bolt_axis_xcomp) -side left -padx 2 -pady 2 -fill both -expand 1
		set gui(bolt_axis_ycomp) [entry $gui(f3).bolt_axis_ycomp -textvariable glo(bolt_axis_ycomp) -font $gui(Font) -width 7];
		pack $gui(bolt_axis_ycomp) -side left -padx 2 -pady 2 -fill both -expand 1
		set gui(bolt_axis_zcomp) [entry $gui(f3).bolt_axis_zcomp -textvariable glo(bolt_axis_zcomp) -font $gui(Font) -width 7];
		pack $gui(bolt_axis_zcomp) -side left -padx 2 -pady 2 -fill both -expand 1
	
	set gui(f4) [frame $gui(mainWin).f4]; pack $gui(f4) -side top -fill x
		set gui(v_axis_button) [button $gui(f4).v_axis_button -text "Orientation" -font $gui(Font) -width 15 -bg #e6e664 -command ::HM::orientation]; 
		pack $gui(v_axis_button) -side left -padx 2 -pady 2 
		set gui(v_axis_xcomp) [entry $gui(f4).v_axis_xcomp -textvariable glo(v_axis_xcomp) -font $gui(Font) -width 7];
		pack $gui(v_axis_xcomp) -side left -padx 2 -pady 2 -fill both -expand 1
		set gui(v_axis_ycomp) [entry $gui(f4).v_axis_ycomp -textvariable glo(v_axis_ycomp) -font $gui(Font) -width 7];
		pack $gui(v_axis_ycomp) -side left -padx 2 -pady 2 -fill both -expand 1
		set gui(v_axis_zcomp) [entry $gui(f4).v_axis_zcomp -textvariable glo(v_axis_zcomp) -font $gui(Font) -width 7];
		pack $gui(v_axis_zcomp) -side left -padx 2 -pady 2 -fill both -expand 1
	
	set gui(f10) [frame $gui(mainWin).f10]; pack $gui(f10) -side top -fill x
		set gui(create_line) [button $gui(f10).create_line -text "Hole Centers" -font $gui(Font) -bg #e6e664 -height 1 -command ::HM::choose_bolt_hole]; 
		pack $gui(create_line) -side left -padx 2 -pady 2 -fill x -expand 1
		
	set name_list [list "Washer No:" "Alpha:" "Preload:"]
	set variable_list [list "washer_no" "alpha" "preload"]
	foreach name $name_list variable $variable_list {
		set gui(f_$variable) [frame $gui(mainWin).f_$variable]; pack $gui(f_$variable) -side top -fill x
			set gui(label_$variable) [label $gui(f_$variable).label_$variable -text $name -font $gui(Font) -anchor w -width 12]; 
			pack $gui(label_$variable) -side left -padx 2 -pady 2
			set gui(entry_$variable) [entry $gui(f_$variable).entry_$variable -textvariable glo($variable) -font $gui(Font) -width 15];
			pack $gui(entry_$variable) -side left -padx 2 -pady 2 -fill both -expand 1
	}
	
	set gui(separator_1) [ttk::separator $gui(mainWin).separator_1 -orient horizontal];
	pack $gui(separator_1) -side top -fill x -expand 0 -padx 2 -pady 6
	
	set gui(f12) [frame $gui(mainWin).f12]; pack $gui(f12) -side top -fill both -expand 0
		set gui(cont_type) [label $gui(f12).cont_type -text "Shear type:" -width 12 -anchor w -font $gui(Font)]
		pack $gui(cont_type) -side left -padx 2 -pady 2 
		set gui(cont_com) [ttk::combobox $gui(f12).cont_com -textvariable glo(shear_type) -values {clearance nonclearance}]
		pack $gui(cont_com) -side left -padx 2 -pady 2 -fill both -expand 1
	
	set gui(f11) [frame $gui(mainWin).f11]; pack $gui(f11) -side top -fill both -expand 1
		set gui(create_button) [button $gui(f11).create_button -text "Evaluate Params" -font $gui(Font) -width 15 -bg #60c060 -command ::HM::eval_param]; 
		pack $gui(create_button) -side left -padx 2 -pady 2 -fill both -expand 1
		
	set name_list [list "ROD R:" "BUSH K1:" "BUSH K2:" "BUSH K3:"]
	set variable_list [list "rod_r" "bush_k1" "bush_k2" "bush_k3"]
	foreach name $name_list variable $variable_list {
		set gui(f_$variable) [frame $gui(mainWin).f_$variable]; pack $gui(f_$variable) -side top -fill x
			set gui(label_$variable) [label $gui(f_$variable).label_$variable -text $name -font $gui(Font) -anchor w -width 12]; 
			pack $gui(label_$variable) -side left -padx 2 -pady 2
			set gui(entry_$variable) [entry $gui(f_$variable).entry_$variable -textvariable glo($variable) -font $gui(Font) -width 15];
			pack $gui(entry_$variable) -side left -padx 2 -pady 2 -fill both -expand 1
	}
	
	set gui(separator_2) [ttk::separator $gui(mainWin).separator_2 -orient horizontal];
	pack $gui(separator_2) -side top -fill x -expand 0 -padx 2 -pady 6
	
	set gui(f6) [frame $gui(mainWin).f6]; pack $gui(f6) -side top -fill x
		set gui(create_line) [button $gui(f6).create_line -text "(1) Hole Layer Preview" -font $gui(Font) -width 15 -bg #60c060 -height 2 -command ::HM::hole_line_preview]; 
		pack $gui(create_line) -side left -padx 2 -pady 2 -fill both -expand 1
		set gui(create_bolt) [button $gui(f6).create_bolt -text "(2) Create Bolted Connection" -font $gui(Font) -width 15 -bg #60c060 -command ::HM::create]; 
		pack $gui(create_bolt) -side left -padx 2 -pady 2 -fill both -expand 1

}

proc ::HM::bolt_param_file {} {
	#load the bolt parameters file
	variable arr; global glo; variable gui
	set glo(bolt_parm_path) [tk_getOpenFile -initialdir $gui(dirname) -filetypes {{{Text Files} {.txt}}}]
	
	#extract information
	set channel [open $glo(bolt_parm_path) "r"]; set data [read $channel]; close $channel	
	set lines_data [split $data "\n"]; set arr(bolt_name_list) [list];  set j 0; set arr(mat_list) [list]
	foreach line $lines_data {
		set word_list [split $line " "]
		if {[lindex $word_list 0]=="\$BOLT_TYPE:"} {
			set bolt_name [lindex $word_list 1];
			lappend arr(bolt_name_list) $bolt_name
			set arr($bolt_name) [list]
			for {set i 1} {$i<=14} {incr i 1} {
				lappend arr($bolt_name) [lindex [split [lindex $lines_data [expr $j+$i]] " "] 1]
			}
		}
		set j [expr $j+1]
	}
	
	#update the combo button for the bolt type selection
	destroy $gui(boltype_label); destroy $gui(bolt_combo)
	set gui(boltype_label) [label $gui(f7).boltype_label -text "Bolt Types:" -width 12 -anchor w -font $gui(Font)]
	pack $gui(boltype_label) -side left -padx 2 -pady 2 
	set gui(bolt_combo) [ttk::combobox $gui(f7).bolt_combo -textvariable glo(bolt_name) -values $arr(bolt_name_list)]
	pack $gui(bolt_combo) -side left -padx 2 -pady 2 -fill both -expand 1
	bind $gui(bolt_combo) "<<ComboboxSelected>>" {::HM::update_bolt_param}
	
	#evaluate with first bolt type in the parameter file
	set glo(bolt_name) [lindex $arr(bolt_name_list) 0]
	puts $arr(bolt_name_list)
	::HM::update_bolt_param
}

proc ::HM::update_bolt_param {} {
	variable arr; global glo; variable gui
	set glo(bolt_dia) [format {%0.3f} [lindex $arr($glo(bolt_name)) 0]];
	set glo(hole_dia) [format {%0.3f} [lindex $arr($glo(bolt_name)) 4]]; 
	set glo(head_dia) [format {%0.3f} [lindex $arr($glo(bolt_name)) 3]];
}


proc ::HM::choose_upper_comp {} {
	#choose the upper component, this component contacts with the bolt head 
	variable arr; global glo
	*createmarkpanel components 1 "please select upper comp"; set arr(upper_comp) [hm_getmark comps 1]
	set glo(upper_comp_name) [hm_getentityvalue comps $arr(upper_comp) name 1]
	
	#check pshell information
	set pshell_id [hm_getentityvalue comps $arr(upper_comp) propertyid 0]; 
	if {$pshell_id==0} {::HM::message "Selected component doesn't have assigned property with thickness" error; return}
	set arr(T1) [format %.3f [hm_getvalue props id=$pshell_id dataname=PSHELL_T]]; 	#thickness of the upper comp used to evaluate parameters
	if {$arr(T1)==0} {::HM::message "Selected component doesn't have assigned property with thickness" error; return}
	
	#check for material information
	set arr(mat_id) [hm_getentityvalue props $pshell_id materialid 0]
	if {$arr(mat_id)==0} {::HM::message "Selected component doesn't have assigned material" error; return}
	
	set arr(E1) [hm_getvalue mats id=$arr(mat_id) dataname=E];
	set arr(G1) [hm_getvalue mats id=$arr(mat_id) dataname=G];
	
	#detect holes
	*nodecleartempmark; *clearmark surfs 1
	hm_holedetectioninit
	eval *createmark surfs 1 {"by comp id"} $arr(upper_comp)
	hm_holedetectionsetentities surfs 1
	hm_holedetectionsetholeparams hole_shape=31 max_planar_dim=[expr $glo(hole_dia)*1.2] min_planar_dim=[expr $glo(hole_dia)/1.2]
	hm_holedetectionfindholes 1
	set n [hm_holedetectiongetnumberofholes];
	if {$n>0} {for {set i 0} {$i<$n} {incr i 1} {set hole_data($i) [hm_holedetectiongetholedetails $i]}} else {hm_holedetectionend; return}
	hm_holedetectionend
	for {set i 0} {$i<$n} {incr i} {
		set coor_list [lindex $hole_data($i) 3];
		*createnode [lindex $coor_list 0] [lindex $coor_list 1] [lindex $coor_list 2] 0 0 0
	}
}

proc ::HM::choose_lower_comp {} {
	#choose the second component, this component contacts with the nut
	variable arr; global glo
	*createmarkpanel components 2 "please select lower comp"; set arr(lower_comp) [hm_getmark comps 2]
	set glo(lower_comp_name) [hm_getentityvalue comps $arr(lower_comp) name 1]
	
	#check the pshell information
	set pshell_id [hm_getentityvalue comps $arr(lower_comp) propertyid 0]; 
	if {$pshell_id==0} {::HM::message "Selected component doesn't have assigned property with thickness" error; return}
	set arr(T2) [format %.3f [hm_getvalue props id=$pshell_id dataname=PSHELL_T]];	#thickness of the lower comp used to evaluate parameters
	if {$arr(T2)==0} {::HM::message "Selected component doesn't have assigned property with thickness" error; return}
	
	#check for material information
	set arr(mat_id) [hm_getentityvalue props $pshell_id materialid 0]
	if {$arr(mat_id)==0} {::HM::message "Selected component doesn't have assigned material" error; return}
	set arr(E2) [hm_getvalue mats id=$arr(mat_id) dataname=E]
	set arr(G2) [hm_getvalue mats id=$arr(mat_id) dataname=G];
}

proc ::HM::bolt_axis {} {
	#direction of the bolt, point from the bolt head to the bolt end
	variable arr; global glo
	set direction_list [hm_getdirectionpanel]; set direction_list [lindex $direction_list 0]
	set glo(bolt_axis_xcomp) [lindex $direction_list 0];
	set glo(bolt_axis_ycomp) [lindex $direction_list 1];
	set glo(bolt_axis_zcomp) [lindex $direction_list 2];
}

proc ::HM::orientation {} {
	#second orientation to determine the local system for the bolted connection.
	variable arr; global glo; variable gui
	set direction_list [hm_getdirectionpanel]; set direction_list [lindex $direction_list 0]
	set glo(v_axis_xcomp) [lindex $direction_list 0];
	set glo(v_axis_ycomp) [lindex $direction_list 1];
	set glo(v_axis_zcomp) [lindex $direction_list 2];
}

proc ::HM::choose_bolt_hole {} {
	variable arr; global glo
	*createmarkpanel nodes 1 "please select center nodes of holes"
	
	set node_list [hm_getmark nodes 1]
	set arr(center_coords_list) [list]
	foreach node $node_list {
		set x [hm_getvalue nodes id=$node dataname=globalx]
		set y [hm_getvalue nodes id=$node dataname=globaly]
		set z [hm_getvalue nodes id=$node dataname=globalz]
		lappend arr(center_coords_list) [list $x $y $z]
	}
}

proc ::HM::eval_param {} {
	#evaluate the parameters for bolt stiffness and grip stiffness
	variable arr; variable gui; global glo
	set d_nom [lindex $arr($glo(bolt_name)) 0];		#nominal diameter
	set P [lindex $arr($glo(bolt_name)) 2]; 		#bolt pitch
	set D [lindex $arr($glo(bolt_name)) 3];			#head diameter
	set d_hole [lindex $arr($glo(bolt_name)) 4];	#hole diameter
	set washer [lindex $arr($glo(bolt_name)) 5]; 	#washer length
	set E_bolt [lindex $arr($glo(bolt_name)) 6]; 	#Yound modulus
	set Nu_bolt [lindex $arr($glo(bolt_name)) 7];	#Poisson ratio
	set RHO_bolt [lindex $arr($glo(bolt_name)) 8];	#Density
	set li [lindex $arr($glo(bolt_name)) 9];		#bolt shank length
	set lT [lindex $arr($glo(bolt_name)) 10];		#bolt thread length
	set pi 3.141592654								
	set alpha [expr $glo(alpha)*$pi/180]
	
	#calculate the bolt elasticicty 
	set Ai [expr $pi*($d_nom**2)/4]; 				#constant cross-section area
	set AT [expr $pi*(($d_nom-0.9382*$P)**2)/4];	#tensile stress area of thread section
	set teta_i [expr $li/$Ai]
	set teta_T [expr $lT/$AT]
	set teta_B [expr ($teta_i + $teta_T)/$E_bolt]
	#set teta_B [expr ($teta_i + $teta_T + 26/$Ai)/$E_bolt]
	
	#evaluate the diameter for ROD element; this element only trasfer the axial load
	set l_rod [expr ($arr(T1)+$arr(T2))/2]
	set glo(rod_r) [format %.3f [expr sqrt($l_rod/($teta_B*$E_bolt*$pi))]]
	puts $E_bolt
	
	#evaluate the grip stiffness
	set Lg [expr $arr(T1)+$arr(T2)+2*$washer]
	set A [expr ($arr(E1)+$arr(E2))*log(($D+3*$d_hole)/($D-$d_hole))]
	set B [expr $arr(E1)*log(($D+2*$arr(T1)*tan($alpha)-$d_hole)/($D+2*$arr(T1)*tan($alpha)+3*$d_hole))]
	set C [expr $arr(E2)*log(($D+2*$arr(T2)*tan($alpha)-$d_hole)/($D+2*$arr(T2)*tan($alpha)+3*$d_hole))]
	set k_grip [expr $arr(E1)*$arr(E2)*$d_hole*$pi*tan($alpha)/($A+$B+$C)]
	
	#evaluate the shear stiffness
	set Aw [expr ($D**2-$d_hole**2)*$pi/4]
	if {$glo(shear_type)=="clearance"} {
		set k_shear1 [expr 2*$Aw*$arr(G1)/$arr(T1)]
		set k_shear2 [expr 2*$Aw*$arr(G2)/$arr(T2)]
		set k_shear [expr 1/(1/$k_shear1 + 1/$k_shear2)];
	} else {
		set C0 [expr (($arr(T1)+$arr(T2))/(2*$d_nom))**(2/3)];
		set C1 [expr 3/($arr(T1)*$arr(E1))];
		set C2 [expr 3/($arr(T2)*$arr(E2))];
		set C3 [expr 3/(2*$arr(T1)*$E_bolt)];
		set C4 [expr 3/(2*$arr(T2)*$E_bolt)];
		set C [expr $C0*($C1+$C2+$C3+$C4)];
		
		#set C0 [expr 2*($arr(T1)+$arr(T2))/()]
		set k_shear [expr 1/$C];
	}
	
	set glo(cont_type) "RBE2"
	if {$glo(cont_type)=="RBE3"} {
		set glo(bush_k1) [format %.3f [expr $k_grip/(2*$glo(washer_no))]]; #devide for number of bush elements
		set glo(bush_k2) [format %.3f [expr $k_shear/$glo(washer_no)]];
		set glo(bush_k3) [format %.3f [expr $k_shear/$glo(washer_no)]];
	} elseif {$glo(cont_type)=="RBE2"} {
		set glo(bush_k1) [format %.3f [expr $k_grip/(6*$glo(washer_no))]];
		set glo(bush_k2) [format %.3f [expr $k_shear/(4*$glo(washer_no))]];
		set glo(bush_k3) [format %.3f [expr $k_shear/(4*$glo(washer_no))]];
	} else {
		::HM::message "Please choose a contact type to process" error; return
	}
		
}

proc ::HM::hole_line_preview {} {

	#additonal mesh layer is determined by the pressure cone, largest area the force is distributed
	variable arr; variable gui; global glo
	if {[hm_entityinfo exist comps "lines"]==0} {*createentity comps includeid=0 name=lines; *setvalue comps name=lines color=3}
	set pi 3.141592654
	set r_cone [format %0.3f [expr ($arr(T1)+$arr(T2))*0.5*tan($glo(alpha)*$pi/180)]]
	
	eval *createlist nodes 1 $arr(center_node_list)
	*createvector 1 $glo(bolt_axis_xcomp) $glo(bolt_axis_ycomp) $glo(bolt_axis_zcomp)
	set hb [expr ([format %0.3f $glo(head_dia)]-[format %0.3f $glo(hole_dia)])/2]
	set R1 [expr [format %0.3f $glo(hole_dia)]/2 + $hb/3]
	set R2 [expr [format %0.3f $glo(hole_dia)]/2 + $hb*2/3]
	set R3 [expr [format %0.3f $glo(hole_dia)]/2 + $hb]
	set R4 [expr [format %0.3f $glo(hole_dia)]/2 + $hb + $r_cone/2]
	set R5 [expr [format %0.3f $glo(hole_dia)]/2 + $hb + $r_cone]
	
	*createcirclefromcenterradius 1 1 $R1 360 0
	*createcirclefromcenterradius 1 1 $R2 360 0
	*createcirclefromcenterradius 1 1 $R3 360 0
	*createcirclefromcenterradius 1 1 $R4 360 0
	*createcirclefromcenterradius 1 1 $R5 360 0
}

proc ::HM::create {} {
	variable arr; variable gui; global glo
	::HM::Graphics 0; # temporarily stop the graphics
	if {$glo(pre_hole)=="Hole non-existed"} {::HM::create_hole_mesh}
	::HM::create_bolt
	::HM::Graphics 1
}

proc ::HM::create_hole_mesh {} {
	variable arr; variable gui; global glo
	
	#create a temp comp to store elements first
	if {[hm_entityinfo exist comps "^temp_1D_comp"]==0} {*createentity comps includeid=0 name="^temp_1D_comp"} 
	if {[hm_entityinfo exist comps "^temp_2D_comp"]==0} {*createentity comps includeid=0 name="^temp_2D_comp"}
	
	#calculate base parameters
	set pi 3.141592654
	set r_cone [format %0.3f [expr ($arr(T1)+$arr(T2))*0.5*tan($glo(alpha)*$pi/180)]]
	set hb [expr ([format %0.3f $glo(head_dia)]-[format %0.3f $glo(hole_dia)])/2]
	set R1 [expr [format %0.3f $glo(hole_dia)]/2 + $hb/3]
	set R2 [expr [format %0.3f $glo(hole_dia)]/2 + $hb*2/3]
	set R3 [expr [format %0.3f $glo(hole_dia)]/2 + $hb]
	set R4 [expr [format %0.3f $glo(hole_dia)]/2 + $hb + $r_cone/2]
	set R5 [expr [format %0.3f $glo(hole_dia)]/2 + $hb + $r_cone]
	
	#generate the mesh
	foreach coords $arr(center_coords_list) {
		set x [lindex $coords 0]
		set y [lindex $coords 1]
		set z [lindex $coords 2]
		*createnode $x $y $z 0 0 0
		set node_id [hm_latestentityid nodes]
	
		set node_list ""
		*createvector 1 $glo(v_axis_xcomp) $glo(v_axis_ycomp) $glo(v_axis_zcomp)
		*createmark nodes 1 $node_id; 
		*duplicatemark nodes 1; lappend node_list [hm_latestentityid nodes]; *translatemark nodes 1 1 [expr $glo(hole_dia)/2]
		*duplicatemark nodes 1; lappend node_list [hm_latestentityid nodes]; *translatemark nodes 1 1 [expr $R1-$glo(hole_dia)/2]	
		*duplicatemark nodes 1; lappend node_list [hm_latestentityid nodes]; *translatemark nodes 1 1 [expr $R2-$R1]
		*duplicatemark nodes 1; lappend node_list [hm_latestentityid nodes]; *translatemark nodes 1 1 [expr $R3-$R2]
		*duplicatemark nodes 1; lappend node_list [hm_latestentityid nodes]; *translatemark nodes 1 1 [expr $R4-$R3];
		*duplicatemark nodes 1; lappend node_list [hm_latestentityid nodes]; *translatemark nodes 1 1 [expr $R5-$R4];
		
		*currentcollector comps "^temp_1D_comp"
		*elementsizeset 100
		eval *createlist nodes 1 $node_list
		*linemesh_preparenodeslist1 1 61
		*linemesh_saveparameters 0 1 0 0
		*linemesh_saveparameters 1 1 0 0
		*linemesh_saveparameters 2 1 0 0
		*linemesh_saveparameters 3 1 0 0
		*linemesh_saveparameters 4 1 0 0
		*linemesh_savedata1 1 61 0 0
		
		*currentcollector comps "^temp_2D_comp"
		*createmark elems 1 "by comp" "^temp_1D_comp"
		*createplane 2 $glo(bolt_axis_xcomp) $glo(bolt_axis_ycomp) $glo(bolt_axis_zcomp) $x $y $z
		*meshspinelements2 1 2 360 $glo(washer_no) 0 0
		*deletemark elems 1
		eval *createmark nodes 1 $node_list
		*nodemarkcleartempmark 1
	}
	*clearmark nodes 1 
	*clearmark elems 1
	*createmark components 1 "^temp_2D_comp"
	*equivalence components 1 0.001 1 0 0
	
	#imprint the mesh to the connected comps
	set elem_size [expr 2*$pi*$R5/$glo(washer_no)]
	*createmark elements 1 "by comp" "^temp_2D_comp"
	*createmark components 2 $arr(lower_comp)
	*imprint_elements components 2 elements 1 "remain 3 to_dest_component 1 remesh_layers 2 remesh_mode 2 angle 30.000000 mesh_type 0 mesh_size $elem_size create_joint_elems 0"
	*createmark components 2 $arr(upper_comp)
	*imprint_elements components 2 elements 1 "remain 3 to_dest_component 1 remesh_layers 2 remesh_mode 2 angle 30.000000 mesh_type 0 mesh_size $elem_size create_joint_elems 0" 
	
	#clear the temp comps
	*createmark comps 1 "^temp_2D_comp" "^temp_1D_comp"
	*deletemark comps 1
	
	#clear the inside hole elements
	*createmark elems 1
	set gap [expr ($arr(T1)+$arr(T2))/2];
	foreach coords $arr(center_coords_list) {
		set x1 [lindex $coords 0]
		set y1 [lindex $coords 1]
		set z1 [lindex $coords 2]
		set x2 [expr $x1+$glo(bolt_axis_xcomp)*$gap]; set y2 [expr $y1+$glo(bolt_axis_ycomp)*$gap]; set z2 [expr $z1+$glo(bolt_axis_zcomp)*$gap]
		*appendmark elems 1 "by sphere" $x1 $y1 $z1 [expr $glo(hole_dia)*0.95/2] inside 0 0 0
		*appendmark elems 1 "by sphere" $x2 $y2 $z2 [expr $glo(hole_dia)*0.95/2] inside 0 0 0
	}
	*deletemark elems 1
}


proc ::HM::create_bolt {} {
	
	#get input data =======================================
	variable arr; variable gui; global glo
	
	set bolt_xcomp $glo(bolt_axis_xcomp); set bolt_ycomp $glo(bolt_axis_ycomp); set bolt_zcomp $glo(bolt_axis_zcomp)
	set v_xcomp $glo(v_axis_xcomp); set v_ycomp $glo(v_axis_ycomp); set v_zcomp $glo(v_axis_zcomp)
	
	if {[hm_entityinfo exist comps "rbe3_rod"]==0} {*createentity comps includeid=0 name="rbe3_rod"; *setvalue comps name="rbe3_rod" color=3}
	if {[hm_entityinfo exist comps "CRODs"]==0} {*createentity comps includeid=0 name="CRODs"; *setvalue comps name="CRODs" color=6}
	if {[hm_entityinfo exist comps "Contact"]==0} {*createentity comps includeid=0 name="Contact"; *setvalue comps name="Contact" color=50}
	if {[hm_entityinfo exist comps "CBUSH_axial"]==0} {*createentity comps includeid=0 name="CBUSH_axial"; *setvalue comps name="CBUSH_axial" color=45}
	if {[hm_entityinfo exist comps "CBUSH_shear"]==0} {*createentity comps includeid=0 name="CBUSH_shear"; *setvalue comps name="CBUSH_shear" color=45}
	if {[hm_entityinfo exist loadcols "Pretension_loads"]==0} {*createentity loadcols includeid=0 name="Pretension_loads"; }
	if {[hm_entityinfo exist sets "Output_CRODs"]==0} {*createentity sets cardimage="SET_ELEM" includeid=0 name="Output_CRODs"};
	if {[hm_entityinfo exist sets "Output_Nodes"]==0} {*createentity sets cardimage="SET_GRID" includeid=0 name="Output_Nodes"};
	
	#create material for bolt or use existed information
	if {[hm_entityinfo exist mats "bolt_mat_$glo(bolt_name)"]==0} {
		*createentity mats cardimage=MAT1 includeid=0 name="bolt_mat_$glo(bolt_name)"
		set bolt_mat_id [hm_latestentityid mats];
		*setvalue mats id=$bolt_mat_id STATUS=1 1=[lindex $arr($glo(bolt_name)) 6]
		*setvalue mats id=$bolt_mat_id STATUS=1 3=[lindex $arr($glo(bolt_name)) 7]
		*setvalue mats id=$bolt_mat_id STATUS=1 4=[lindex $arr($glo(bolt_name)) 8]
	} else {
		set bolt_mat_id [hm_getvalue mats name="bolt_mat_$glo(bolt_name)" dataname=id]
	}

	
	set exclusive_id [expr ([lsearch $arr(bolt_name_list) $glo(bolt_name)]+1)*10000]
	set crod_elem_list [list]; set cbush_node_list [list]; *elementtype 61 1; *elementtype 21 6
	foreach coords $arr(center_coords_list) {
		set x1 [lindex $coords 0]
		set y1 [lindex $coords 1]
		set z1 [lindex $coords 2]
		*createnode $x1 $y1 $z1 0 0 0
		set node [hm_latestentityid nodes]
		
		#create RBE3 for contact============================================================================================================
		
		set gap [expr ($arr(T1)+$arr(T2))/2];
		set x2 [expr $x1+$bolt_xcomp*$gap]; set y2 [expr $y1+$bolt_ycomp*$gap]; set z2 [expr $z1+$bolt_zcomp*$gap]
		set hole_rad [expr $glo(hole_dia)/2]; set head_rad [expr $glo(head_dia)/2]; set distance_1 [expr $arr(T1)/2]; set distance_2 [expr -$arr(T2)/2];
		set output1 [handle_single_hole $x1 $y1 $z1 $arr(upper_comp) $hole_rad $head_rad $distance_1 $glo(washer_no) $bolt_xcomp $bolt_ycomp $bolt_zcomp RBE2]; 
		set output2 [handle_single_hole $x2 $y2 $z2 $arr(lower_comp) $hole_rad $head_rad $distance_2 $glo(washer_no) $bolt_xcomp $bolt_ycomp $bolt_zcomp RBE2];
		eval lappend cbush_node_list [lindex $output1 0]; eval lappend cbush_node_list [lindex $output2 0];
		eval lappend cbush_node_list [lindex $output1 1]; eval lappend cbush_node_list [lindex $output2 1];
		
		#create PROD and CROD element=======================================================================================================
		*currentcollector components "CRODs"; set pi 3.141592654
		while {1==1} {if {[hm_entityinfo exist props PROD_$exclusive_id]==0} {*createentity props cardimage=PROD includeid=0 name=PROD_$exclusive_id; break;} else {incr exclusive_id 1}}
		*createmark props 1 "PROD_$exclusive_id"; *renumbersolverid properties 1 $exclusive_id 1 0 0 0 0 0
		*setvalue props name="PROD_$exclusive_id" STATUS=1 64=[format %.3f [expr ($pi*$glo(rod_r)**2)/1]];
		*setvalue props name="PROD_$exclusive_id" STATUS=1 65=[format %.3f [expr ($pi*$glo(rod_r)**4)/2]];
		*setvalue props name="PROD_$exclusive_id" materialid={mats $bolt_mat_id}
		*rod [lindex $output1 2] [lindex $output2 2] "PROD_$exclusive_id"
		lappend crod_elem_list [hm_latestentityid elems]
		#=====================================================================================================================================
		
		#create base system for bolt connection==========================================================================================
		*createmark nodes 1 $node;
		*createnode [expr $x1+$bolt_xcomp] [expr $y1+$bolt_ycomp] [expr $z1+$bolt_zcomp] 0 0 0; set x_node [hm_latestentityid nodes]
		*createnode [expr $x1+$v_xcomp] [expr $y1+$v_ycomp] [expr $z1+$v_zcomp] 0 0 0; set xy_node [hm_latestentityid nodes]
		*systemcreate 1 0 $node "x-axis" $x_node "xy plane    " $xy_node; set base_system_id [hm_latestentityid systems];
		*createmark systems 1 $base_system_id; *renumbersolverid systems 1 $exclusive_id 1 0 0 0 0 0; #change the system id to the exclusive id for each element 
		*createmark nodes 1 $xy_node $x_node; *nodemarkcleartempmark 1
		#=====================================================================================================================================
		
		#create preload for each crod elements================================================================================================
		*currentcollector loadcols "Pretension_loads"
		*createmark elements 1 [hm_latestentityid elems]
		*entitysetcreate "PRETENS_$exclusive_id" elements 1; set set_id [hm_latestentityid sets]
		*setvalue sets id=$set_id id={Sets $exclusive_id}
		*createmark sets 1 "PRETENS_$exclusive_id"
		set home_folder [hm_info -appinfo ALTAIR_HOME]
		*dictionaryload sets 1 "$home_folder/templates/feoutput/optistruct/optistruct" "PRETENS"
		*attributeupdateint sets $exclusive_id 3240 1 2 0 1
		*attributeupdatestring sets $exclusive_id 2163 1 0 0 "        "
		*attributeupdateentity sets $exclusive_id 2171 1 0 0 nodes 0
		*attributeupdatestring sets $exclusive_id 2163 1 1 0 "AUTO"
		*createmark sets 1 $exclusive_id
		*loadcreateonentity_curve sets 1 6 5 $glo(preload) 0 0 0 0 0 0 0 0 0 0
		#=====================================================================================================================================
		
		#create CBUSH elements==============================================================================================================
		*currentcollector components "CBUSH_axial"; *elementtype 21 6
		#Create CBUSH elements and PBUSH for axial stiffness
		set exclu_pbush_1 [expr $exclusive_id*10]; 
		*createentity props cardimage=PBUSH includeid=0 name=PBUSH_$exclu_pbush_1;
		*setvalue props name=PBUSH_$exclu_pbush_1 id={Properties $exclu_pbush_1}
		*setvalue props name=PBUSH_$exclu_pbush_1 STATUS=2 872=1
		*setvalue props name=PBUSH_$exclu_pbush_1 STATUS=2 845=$glo(bush_k1)
		eval *createmark nodes 1 {"by id only"} [lindex $output2 0] [lindex $output2 1]; *findmark nodes 1 257 1 elements 0 2; 
		foreach node1 [concat [lindex $output1 0] [lindex $output1 1]] {
			set x [hm_getvalue nodes id=$node1 dataname=globalx]
			set y [hm_getvalue nodes id=$node1 dataname=globaly]
			set z [hm_getvalue nodes id=$node1 dataname=globalz]
			set node2 [hm_getclosestnode $x $y $z 2];
			*springos $node1 $node2 "PBUSH_$exclu_pbush_1" 0 0 0 0 0 0 $exclusive_id;
			*replacenodes $node1 $node2 0 1
		}
		
		#create CBUSH elements and PBUSH for shear stiffness
		*currentcollector components "CBUSH_shear"; *elementtype 21 6
		set exclu_pbush_2 [expr $exclusive_id*10+1];
		*createentity props cardimage=PBUSH includeid=0 name=PBUSH_$exclu_pbush_2;
		*setvalue props name=PBUSH_$exclu_pbush_2 id={Properties $exclu_pbush_2}
		*setvalue props name=PBUSH_$exclu_pbush_2 STATUS=2 872=1
		*setvalue props name=PBUSH_$exclu_pbush_2 STATUS=2 846=$glo(bush_k2)
		*setvalue props name=PBUSH_$exclu_pbush_2 STATUS=2 847=$glo(bush_k3)
		eval *createmark nodes 1 {"by id only"} [lindex $output2 0]; *findmark nodes 1 257 1 elements 0 2;
		*createmark elems 1 "by comp name" "CBUSH_axial"; *markdifference elems 2 elems 1
		foreach node1 [lindex $output1 0] {
			set x [hm_getvalue nodes id=$node1 dataname=globalx]
			set y [hm_getvalue nodes id=$node1 dataname=globaly]
			set z [hm_getvalue nodes id=$node1 dataname=globalz]
			set node2 [hm_getclosestnode $x $y $z 2];
			*springos $node1 $node2 "PBUSH_$exclu_pbush_2" 0 0 0 0 0 0 $exclusive_id;
			*replacenodes $node1 $node2 0 1
		}
		#=====================================================================================================================================
		
		#assign nodes displacement to based system============================================================================================
		eval *createmark nodes 1 {"by id only"} [lindex $output1 0] [lindex $output1 1]
		eval *appendmark nodes 1 {"by id only"} [lindex $output2 0] [lindex $output2 1]
		*systemsetanalysis nodes 1 $exclusive_id
		#=====================================================================================================================================
		
		incr exclusive_id 1; 
	}
	
	set cur_crod_elems [hm_getvalue sets name=Output_CRODs dataname=ids]
	set cur_cbush_nodes [hm_getvalue sets name=Output_Nodes dataname=ids]
	eval *setvalue sets name=Output_CRODs ids={elems [concat $cur_crod_elems $crod_elem_list]}
	eval *setvalue sets name=Output_Nodes ids={nodes [concat $cur_cbush_nodes $cbush_node_list]}
	
	#show the components after the creation
	*createmark components 2 $arr(upper_comp) $arr(lower_comp); 
	*appendmark comps 2 "Contact" "rbe3_rod" "CRODs" "CBUSH_axial" "CBUSH_shear"
	*createstringarray 2 "elements_on" "geometry_off"
	*showentitybymark 2 1 2
	*clearmarkall 1; *clearmarkall 2
	::HM::Graphics 1
}

proc handle_single_hole {x y z comp hole_radius head_radius distance washer_no xcomp ycomp zcomp cont_type} {
	*createmark components 2 $comp
	*createstringarray 2 "elements_on" "geometry_on"
	*isolateentitybymark 2 1 2
	*currentcollector components "Contact"
	
	#retrieve the meshlayer 
	set layer_step [expr ($head_radius-$hole_radius)/3]; set tolerance [expr $layer_step*0.2]
	*createmark nodes 1 "by sphere" $x $y $z [expr $hole_radius+0*$layer_step] boudary 0 0 $tolerance; set layer_1st_node [hm_getmark nodes 1]; hm_highlightmark nodes 1 "high"
	#*createmark nodes 1 "by sphere" -24 -24 7.8 4 boudary 0 0 0.133333333333333333333
	#*createmark elems 1 "by sphere" $x $y $z [expr $hole_radius+0.5*$layer_step] boudary 0 0 $tolerance; set layer_1st [hm_getmark elems 1]
	*findmark nodes 1 1 1 elems 0 2; set layer_1st [hm_getmark elems 2]; *clearmark elems 2
	eval *createmark elems 1 $layer_1st 
	*findmark elems 1 1 1 elems 0 2; set layer_2nd [hm_getmark elems 2]; *clearmark elems 2;
	eval *createmark elems 1 $layer_1st $layer_2nd; 
	*findmark elems 1 1 1 elems 0 2; set layer_3rd [hm_getmark elems 2]; *clearmark elems 2;
	eval *createmark elems 1 $layer_1st $layer_2nd $layer_3rd; 
	*findmark elems 1 1 1 elems 0 2; set layer_4th [hm_getmark elems 2]; *clearmark elems 2;
	eval *createmark elems 1 $layer_1st $layer_2nd $layer_3rd $layer_4th; 
	*findmark elems 1 1 1 elems 0 2; set layer_5th [hm_getmark elems 2]; *clearmark elems 2;
	
	if {$cont_type=="RBE3"} {
		#RBE3 for CBUSH in case of RBE3 contact type
		set cont_list_1 [list]; set cont_list_2 [list]; 
		foreach elem1 $layer_1st {
			#create rbe3 for three first layer
			set x [hm_getvalue elems id=$elem1 dataname=centerx]; set y [hm_getvalue elems id=$elem1 dataname=centery]; set z [hm_getvalue elems id=$elem1 dataname=centerz];
			set elem2 [::hwat::core::GetClosestCentroid $x $y $z $layer_2nd]
			set elem3 [::hwat::core::GetClosestCentroid $x $y $z $layer_3rd]
			*createmark nodes 1 "by elem id" $elem1 $elem2 $elem3
			*createarray 8 123 123 123 123 123 123 123 123 
			*createdoublearray 8 1 1 1 1 1 1 1 1 
			*rbe3 1 1 8 1 8 0 123456 1
			lappend cont_list_1 [hm_latestentityid nodes]
			
			#create rbe3 for 2 additional layer
			set elem4 [::hwat::core::GetClosestCentroid $x $y $z $layer_4th]
			set elem5 [::hwat::core::GetClosestCentroid $x $y $z $layer_5th]
			*createmark nodes 1 "by elem id" $elem4 $elem5 
			*createarray 6 123 123 123 123 123 123
			*createdoublearray 6 1 1 1 1 1 1 
			*rbe3 1 1 6 1 6 0 123456 1
			lappend cont_list_2 [hm_latestentityid nodes]
		}
		eval *createmark nodes 1 {"by id only"} $cont_list_1 $cont_list_2; *createvector 1 $xcomp $ycomp $zcomp; *translatemark nodes 1 1 $distance
	} elseif {$cont_type=="RBE2"} {
		#RBE2 for first three layers
		eval *createmark elems 1 $layer_1st $layer_3rd; *duplicatemark elems 1 0; set elem_list [hm_getmark elems 1]
		*createvector 1 $xcomp $ycomp $zcomp; *translatemark elems 1 1 $distance
		eval *createmark nodes 1 {"by elem id"} $layer_1st $layer_3rd; set node_list [hm_getmark nodes 1]
		foreach node1 $node_list {
			set x [hm_getvalue nodes id=$node1 dataname=globalx]
			set y [hm_getvalue nodes id=$node1 dataname=globaly]
			set z [hm_getvalue nodes id=$node1 dataname=globalz]
			set node2 [hm_getclosestnode $x $y $z 1]
			*rigid $node1 $node2 123456
		}
		eval *createmark nodes 1 {"by elem id"} $elem_list; set cont_list_1 [hm_getmark nodes 1];
		eval *createmark elems 1 {"by id only"} $elem_list; *deletemark elems 1 
		
		#RBE2 for last two layers 
		eval *createmark elems 1 $layer_5th; *duplicatemark elems 1 0; set elem_list [hm_getmark elems 1]
		*createvector 1 $xcomp $ycomp $zcomp; *translatemark elems 1 1 $distance
		eval *createmark nodes 1 {"by elem id"} $layer_5th; set node_list [hm_getmark nodes 1]
		foreach node1 $node_list {
			set x [hm_getvalue nodes id=$node1 dataname=globalx]
			set y [hm_getvalue nodes id=$node1 dataname=globaly]
			set z [hm_getvalue nodes id=$node1 dataname=globalz]
			set node2 [hm_getclosestnode $x $y $z 1]
			*rigid $node1 $node2 123456
		}
		eval *createmark nodes 1 {"by elem id"} $elem_list; set cont_list_2 [hm_getmark nodes 1];
		eval *createmark elems 1 {"by id only"} $elem_list; *deletemark elems 1 
	}
	
	#create RBE3 for crod
	set idp_no [expr $washer_no*4]
	*currentcollector components "rbe3_rod"
	eval *createmark nodes 1 {"by elem id"} $layer_1st; eval *appendmark nodes 1 {"by elem id"} $layer_3rd
	hm_highlightmark nodes 1 "high"
	eval *createarray $idp_no [lrepeat $idp_no 123]
	eval *createdoublearray $idp_no [lrepeat $idp_no 1]
	*rbe3 1 1 $idp_no 1 $idp_no 0 123456 1;
	set crod_node [hm_latestentityid nodes]
	
	set return_list [list $cont_list_1 $cont_list_2 $crod_node]
	return $return_list
}

proc ::HM::get_vector_from_two_nodes {node1 node2} {
	set x1 [hm_getvalue nodes id=$node1 dataname=globalx]
	set y1 [hm_getvalue nodes id=$node1 dataname=globaly]
	set z1 [hm_getvalue nodes id=$node1 dataname=globalz]
	
	set x2 [hm_getvalue nodes id=$node2 dataname=globalx]
	set y2 [hm_getvalue nodes id=$node2 dataname=globaly]
	set z2 [hm_getvalue nodes id=$node2 dataname=globalz]
	
	set x [expr $x2-$x1]; set y [expr $y2-$y1]; set z [expr $z2-$z1]; set output [list $x $y $z]
	
	return $output
}

proc ::HM::Graphics { Switch } {
	if { $Switch == 0 } {
		*entityhighlighting 0
		hm_blockredraw 1
		hm_blockmessages 1
		hm_blockerrormessages 1

	} else {
		*entityhighlighting 1
		hm_blockredraw 0
		hm_blockmessages 0
		hm_blockerrormessages 0	
	}
}

::HM::main_GUI 
return