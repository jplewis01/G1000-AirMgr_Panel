-- Comments and credits
--[[
    Garmin G1000 Overlay for Air Manager 4.0 for Flight Simulator 2020.
    Ovwerlay Version 0.5.0  Jan 09 2020.

    This G1000 Overlay is a Work in Progress and is based upon RUSS BARLOW's Excellent earlier work for XPlane 10 & 11.
    This Overlay is for Microsoft Flight Simulator 2020 only. It was originally tested against MSFS 2020 ver 1.12.13.0
    This panel depends upon the MOBIFLIGHT Events WASM Module being installed into the community folder of MSFS2020.

    Currently only the G1000 PFD is operational. Upcoming Work:
    -Autopilot Button Array
    -MFD
    -Comms Panel

    Contact: Phil Lewis  jplewis02@gmail.com

--]]
-- PFD /MFD Selection
    displayunit_label = user_prop_add_boolean("Display Unit Label", true, "Display the instrument type label on the LCD") -- Show or hide the unit type onscreen
    display_pos = user_prop_add_enum("Display unit function","Pilot PFD,Copilot PFD,MFD","Pilot PFD","Select unit functional position")
    local g_unitpos = "1"
    local pos = user_prop_get(display_pos)

    bezel_prop  = user_prop_add_boolean("Autopilot", true, "Show autopilot controls") -- Show or hide the autopilot controls
    -- Altimeter Setting - Preovides a way for the user to decide which Altimeter reference to adjust withthe Baro Knob
    set_alt = user_prop_add_enum("Set Altimeter","Kohlsman,G1000,Both","Kohlsman","Choose Altimeter reference to set with the Baro Knob")
    
    if pos == "Pilot PFD" then
        g_unitpos= "1"
    elseif pos == "Copilot PFD" then
        g_unitpos= "2"
    else
        g_unitpos= "3"
    end

    if user_prop_get(bezel_prop) then
        img_add_fullscreen("background.png")
    else
        img_add_fullscreen("background_noap.png")
    end

    --print("g_unitpos: " .. g_unitpos)
    
-- Show the G1000 Unit Type 
if user_prop_get(displayunit_label) then
    if g_unitpos == "1" then
        --print("in display unit PFD")
        image_pfd = img_add("pfd.png",195,110,40,30)
    elseif g_unitpos == "3" then
        --print("in display unit MFD")
        image_mfd = img_add("mfd.png",195,110,40,30)
    end
end
-- End PFD/MFD Selection



-- FS2020 Top Bezel Logo
    image_id = img_add("fs2020logo.png",565,11,200,23)
    click_snd = sound_add("knobclick.wav")
-- End Bezel Logo

--GPS DRIVES NAV1 / NAV Selected 
    function nav_selected_callback(navindex)
        return navindex
    end

    function gps_selected_callback(gpsbool)
        --print ("GPS Selected State :"..  tostring(gpsbool))
        return gpsbool
    end

    fs2020_variable_subscribe("AUTOPILOT NAV SELECTED", "Number", nav_selected_callback)
    fs2020_variable_subscribe("GPS DRIVES NAV1", "boolean", gps_selected_callback)
--End of GPS Selected

-- NAV Radio Functions
    --NAV Swap - Stby Active Freqs on selected radio
    function nav_ff()
        --fs2020_event("NAV1_RADIO_SWAP")
        fs2020_event("MOBIFLIGHT.AS1000_PFD_NAV_Switch")
        sound_play(click_snd)
    end
    button_add(nil,"ff_button.png", 102,107,50,32, nav_ff)

    -- Nav Radio Knob
    function nav_outer_turn( direction)
        if direction ==  -1 then
            if g_unitpos == "1" then
                fs2020_event("MOBIFLIGHT.AS1000_PFD_NAV_Large_DEC")
            elseif  g_unitpos == "3" then
                fs2020_event("MOBIFLIGHT.AS1000_MFD_NAV_Large_DEC")            
            end    
        elseif direction == 1 then
            if g_unitpos == "1" then
                fs2020_event("MOBIFLIGHT.AS1000_PFD_NAV_Large_INC")
            elseif  g_unitpos == "3" then
                fs2020_event("MOBIFLIGHT.AS1000_MFD_NAV_Large_INC")            
                end                        
        end
    end
    nav_dial_outer = dial_add("plain_knob_outer.png", 47,173,79,79, nav_outer_turn)
    dial_click_rotate(nav_dial_outer, 6)

    function nav_inner_turn( direction)
        if direction ==  -1 then
            if g_unitpos == "1" then
                fs2020_event("MOBIFLIGHT.AS1000_PFD_NAV_Small_DEC")    
            elseif  g_unitpos == "3" then
                fs2020_event("MOBIFLIGHT.AS1000_MFD_NAV_Small_DEC")
            end 
        elseif direction == 1 then
            if g_unitpos == "1" then
                fs2020_event("MOBIFLIGHT.AS1000_PFD_NAV_Small_DEC")    
            elseif  g_unitpos == "3" then
                fs2020_event("MOBIFLIGHT.AS1000_MFD_NAV_Small_DEC")
            end
        end
    end
    nav_dial_inner = dial_add("plain_knob_inner.png", 63,189,47,47, nav_inner_turn)
    dial_click_rotate(nav_dial_outer, 6)

    --Selected Nav - 1 or 2
        function nav_swap_click()
            if g_unitpos == "1" then
                fs2020_event("Mobiflight.AS1000_PFD_NAV_Push")  
            elseif  g_unitpos == "3" then
                fs2020_event("Mobiflight.AS1000_MFD_NAV_Push")
            end
        sound_play(click_snd)
        end    
        button_add(nil,nil, 75,204,13,13, nav_swap_click)
    --End Selected NAV

    -- NAV VOL Knob add click to select ????
    function nav_vol_turn( direction)
        if direction ==  -1 then
            if g_unitpos == "1" then
                print("in PFD NAV Vol turn CCW")
                fs2020_event("MOBIFLIGHT_AS1000_PFD_VOL_1_DEC")
                fs2020_event("MOBIFLIGHT_AS1000_PFD_VOL_2_DEC")     
            elseif  g_unitpos == "3" then
                fs2020_event("MOBIFLIGHT_AS1000_MFD_VOL_1_DEC")
                fs2020_event("MOBIFLIGHT_AS1000_MFD_VOL_2_DEC")
            end 
        elseif direction == 1 then
            if g_unitpos == "1" then
                print("in PFD NAV Vol turn CW")
                fs2020_event("MOBIFLIGHT_AS1000_PFD_VOL_1_INC")
                fs2020_event("MOBIFLIGHT_AS1000_PFD_VOL_2_INC")    
            elseif  g_unitpos == "3" then
                fs2020_event("MOBIFLIGHT_AS1000_MFD_VOL_1_INC")
                fs2020_event("MOBIFLIGHT_AS1000_MFD_VOL_2_INC")
            end
            sound_play(click_snd)
        end
    end
    nav_vol_dial_turn = dial_add("vol_knob.png", 62,44,50,50, nav_vol_turn)
    
    function nav_vol_press()
        if g_unitpos == "1" then
            print("in PFD Nav Vol Press")
            fs2020_event("MOBIFLIGHT_AS1000_PFD_VOL_1_INC")
        elseif  g_unitpos == "3" then
            fs2020_event("MOBIFLIGHT_AS1000_PFD_VOL_1_INC")
        end
        sound_play(click_snd)
    end
    --button_add(nil,nil, 67,49,40,40, nav_vol_press) 
-- End NAV Radio

-- COM Radio Functions
    --COM Swap Stby Active Freqs on selected radio
    function com_ff()
        fs2020_event("MOBIFLIGHT.AS1000_PFD_COM_Switch")  
        --fs2020_event("COM_STBY_RADIO_SWAP")  
        sound_play(click_snd)
    end
    button_add(nil,"ff_button.png", 1260,107,50,32, com_ff)

    -- COM Radio Knob 
        function com_outer_turn( direction)
            if direction ==  -1 then
                if g_unitpos == "1" then
                    fs2020_event("Mobiflight.AS1000_PFD_COM_Large_DEC")
                elseif  g_unitpos == "3" then
                    fs2020_event("Mobiflight.AS1000_MFD_COM_Large_DEC")                    
                end
            elseif direction == 1 then
                if g_unitpos == "1" then
                    fs2020_event("Mobiflight.AS1000_PFD_COM_Large_INC")
                elseif  g_unitpos == "3" then
                    fs2020_event("Mobiflight.AS1000_MFD_COM_Large_INC")                    
                end
            end
        end        
        com_dial_outer = dial_add("plain_knob_outer.png", 1283,173,79,79, com_outer_turn)
         dial_click_rotate( com_dial_outer, 6)

        function com_inner_turn( direction)
            if direction ==  -1 then
                if g_unitpos == "1" then
                    fs2020_event("Mobiflight.AS1000_PFD_COM_Small_DEC")
                elseif  g_unitpos == "3" then
                    fs2020_event("Mobiflight.AS1000_MFD_COM_Small_DEC")                   
                end            
            elseif direction == 1 then
                if g_unitpos == "1" then
                    fs2020_event("Mobiflight.AS1000_PFD_COM_Small_INC")
                elseif  g_unitpos == "3" then
                    fs2020_event("Mobiflight.AS1000_MFD_COM_Small_INC")                   
                end 
            end
        end
        com_dial_inner = dial_add("plain_knob_inner.png", 1299,189,47,47, com_inner_turn)
        dial_click_rotate( com_dial_inner, 6)

        --Selected COM - 1 or 2        
            function com_swap_click()
                if g_unitpos == "1" then
                    fs2020_event("Mobiflight.AS1000_PFD_COM_Push")      
                    sound_play(click_snd)
                elseif g_unitpos == "3" then
                    fs2020_event("Mobiflight.AS1000_MFD_COM_Push")     
                    --fs2020_event("COM_STBY_RADIO_SWAP") 
                    sound_play(click_snd)
                end
            end
        -- End Selected Nav
        button_add(nil,nil, 1313,204,13,13, com_swap_click)

        -- COM VOL Knob add click to select ???? 
            function com_vol_press()
                if g_unitpos == "1" then
                    print("in PFD Nav Vol Press")
                    fs2020_event("MOBIFLIGHT_AS1000_PFD_VOL_1_INC")
                elseif  g_unitpos == "3" then
                    fs2020_event("MOBIFLIGHT_AS1000_MFD_VOL_1_INC")
                end
                sound_play(click_snd)
            end
            --button_add(nil,nil, 1304,48,40,40, nav_vol_press) 

            function com_vol_turn()
                if direction ==  -1 then
                    if g_unitpos == "1" then
                        --print("in PFD COM Vol turn CCW")
                        fs2020_event("MOBIFLIGHT_AS1000_PFD_VOL_1_DEC")
                        fs2020_event("MOBIFLIGHT_AS1000_PFD_VOL_2_DEC")     
                    elseif  g_unitpos == "3" then
                        --print("in MFD COM Vol turn CW")
                        fs2020_event("MOBIFLIGHT_AS1000_MFD_VOL_1_DEC")
                        fs2020_event("MOBIFLIGHT_AS1000_MFD_VOL_2_DEC")
                    end 
                elseif direction == 1 then
                    if g_unitpos == "1" then
                        --print("in MFD NAV Vol turn CW")
                        fs2020_event("MOBIFLIGHT_AS1000_PFD_VOL_1_INC")
                        fs2020_event("MOBIFLIGHT_AS1000_PFD_VOL_2_INC")    
                    elseif  g_unitpos == "3" then
                        fs2020_event("MOBIFLIGHT_AS1000_MFD_VOL_1_INC")
                        fs2020_event("MOBIFLIGHT_AS1000_MFD_VOL_2_INC")
                    end
                    sound_play(click_snd)
                end
            end
            com_vol_dial_turn = dial_add("vol_knob.png", 1299,43,50,50, com_vol_turn)    
            --comvol_dial = button_add("vol_knob.png","vol_knob_prs.png", 1299,43,50,50, com_vol_press)
    -- End COM Radio

-- Altitude Target Knob
    function alt_callback(altitude)
        --fs2020_event("AP_ALT_VAR_SET_ENGLISH",altitude)
        TargetAlt = altitude
        return TargetAlt 
    end

    fs2020_variable_subscribe("AUTOPILOT ALTITUDE LOCK VAR", "feet", alt_callback)

    function alt_large_callback(direction)
        StepVal = 1000
        -- Direction will have the value
        if direction == 1 then
            TargetAlt =  TargetAlt + StepVal
        elseif direction == -1 then
            TargetAlt =  TargetAlt - StepVal   
        end
        fs2020_event("AP_ALT_VAR_SET_ENGLISH",TargetAlt)   
    end

    function alt_small_callback(direction)
        StepVal = 100    -- altdirection will have the value
        if direction == 1 then
            TargetAlt =  TargetAlt + StepVal
        elseif direction == -1 then
            TargetAlt =  TargetAlt - StepVal    
        end
        fs2020_event("AP_ALT_VAR_SET_ENGLISH",TargetAlt)       
    end

    alt_dial_outer = dial_add("plain_knob_outer.png", 47,793,79,79, alt_large_callback)
    dial_click_rotate( alt_dial_outer, 6)

    alt_dial_inner = dial_add("plain_knob_inner.png", 63,809,47,47, alt_small_callback)
    dial_click_rotate( alt_dial_inner, 6)
-- End Altitude Target Knob

-- Heading Knob
    function hdg_turn( direction)
        if direction ==  -1 then
            fs2020_event("HEADING_BUG_DEC")
        elseif direction == 1 then
            fs2020_event("HEADING_BUG_INC")
        end
    end

    hdg_dial = dial_add("hdg_knob.png", 47,340,80,80,3, hdg_turn)
    dial_click_rotate( hdg_dial, 6)

    function hdg_click()--_hdg_down
        fs2020_event("AP_HDG_HOLD")
        sound_play(click_snd)
    end

    button_add(nil,nil, 77,370,20,20,hdg_click)
-- End Heading Knob

-- AutoPilot functions
        -- AP Mode VARs
        function flc_callback(flcstate)
            FLCState = flcstate 
        return FLCState    
        end

        function vs_callback(vsenabled)
            VSenabled = vsenabled  
        return VSenabled    
        end

        function aspd_callback(asindicated)
            AirspeedIndicated = asindicated  
        return AirspeedIndicated    
        end

        fs2020_variable_subscribe("AUTOPILOT FLIGHT LEVEL CHANGE", "bool", flc_callback)  
        fs2020_variable_subscribe("AUTOPILOT VERTICAL HOLD", "bool", vs_callback)
        fs2020_variable_subscribe("AIRSPEED INDICATED", "knots", aspd_callback)
        -- AIRSPEED_INDICATED  

    -- fs2020_event("")
    function ap_click()
        fs2020_event("AP_Master")
        sound_play(click_snd)
    end

    button_ap = button_add(nil,"ap_button.png", 28,470,50,32, ap_click)
    visible(button_ap, user_prop_get(bezel_prop))

    function hdg_click()
        fs2020_event("AP_PANEL_HEADING_HOLD")
        sound_play(click_snd)
    end

    button_hdg = button_add(nil,"hdg_button.png", 28,520,50,32, hdg_click)
    visible(button_hdg, user_prop_get(bezel_prop))

    function nav_click()
        fs2020_event("AP_NAV1_HOLD_ON")
        sound_play(click_snd)
    end

    button_nav = button_add(nil,"nav_button.png", 28,570,50,32, nav_click)
    visible(button_nav, user_prop_get(bezel_prop))

    function apr_click()
        fs2020_event("AP_APR_HOLD")
        sound_play(click_snd)
    end

    button_apr = button_add(nil,"apr_button.png", 28,621,50,32, apr_click)
    visible(button_apr, user_prop_get(bezel_prop))

    function vs_click()
        fs2020_event("AP_PANEL_VS_HOLD")
        sound_play(click_snd)
    end

    button_vs = button_add(nil,"vs_button.png", 28,671,50,32, vs_click)
    visible(button_vs, user_prop_get(bezel_prop))

    function flc_click()
        if FLCState then
            fs2020_event("FLIGHT_LEVEL_CHANGE_OFF")
        else
            AirspeedDecimal = math.floor(AirspeedIndicated)
            fs2020_event("FLIGHT_LEVEL_CHANGE_ON")
            fs2020_event("AP_SPD_VAR_SET", AirspeedDecimal)
        end
        sound_play(click_snd)
    end

    button_flc = button_add(nil,"flc_button.png", 26,721,54,32, flc_click)
    visible(button_flc, user_prop_get(bezel_prop))

    function fd_click()
        fs2020_event("TOGGLE_FLIGHT_DIRECTOR")
        sound_play(click_snd)
    end

    button_fd = button_add(nil,"fd_button.png", 100,470,50,32, fd_click)
    visible(button_fd, user_prop_get(bezel_prop))

    function alt_click()
        fs2020_event("AP_ALT_HOLD")
        sound_play(click_snd)
    end

    button_alt = button_add(nil,"alt_button.png", 100,520,50,32, alt_click)
    visible(button_alt, user_prop_get(bezel_prop))

    function vnv_click()
        --MOBIFLIGHT_AS530_VNAV_Push
        fs2020_event("MOBIFLIGHT_AS530_VNAV_Push")
        sound_play(click_snd)
    end

    button_vnv = button_add(nil,"vnv_button.png", 98,570,54,32, vnv_click)
    visible(button_vnv, user_prop_get(bezel_prop))

    function bc_click()
        fs2020_event("AP_BC_HOLD_ON")
        sound_play(click_snd)
    end

    button_bc = button_add(nil,"bc_button.png", 98,621,54,32, bc_click)
    visible(button_bc, user_prop_get(bezel_prop))

    function nosup_click()
        if VSenabled then
            fs2020_event("AP_VS_VAR_INC")
        elseif FLCState then 
            fs2020_event("AP_SPD_VAR_INC")
        end
        sound_play(click_snd)
    end

    button_nosup = button_add(nil,"nsup_button.png", 100,671,50,32, nosup_click)
    visible(button_nosup, user_prop_get(bezel_prop))

    function nosdn_click()
        if VSenabled then
            fs2020_event("AP_VS_VAR_DEC")
        elseif FLCState then 
            fs2020_event("AP_SPD_VAR_DEC")
        end 
        sound_play(click_snd)
    end

    button_nosdn = button_add(nil,"nsdn_button.png", 100,721,50,32, nosdn_click)
    visible(button_nosdn, user_prop_get(bezel_prop))

-- End of AutoPilot
--]]

-- Softkey Functions    
    -- PFD side
        if g_unitpos == "1" then
            function sc_1_click()
                fs2020_event("MobiFlight.AS1000_PFD_SOFTKEYS_1")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 213,852,50,32, sc_1_click)

            function sc_2_click()
                fs2020_event("MobiFlight.AS1000_PFD_SOFTKEYS_2")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 297,852,50,32, sc_2_click)

            function sc_3_click()
                fs2020_event("MobiFlight.AS1000_PFD_SOFTKEYS_3")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 383,852,50,32, sc_3_click)

            function sc_4_click()
                fs2020_event("MobiFlight.AS1000_PFD_SOFTKEYS_4")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 468,852,50,32, sc_4_click)

            function sc_5_click()
                fs2020_event("MobiFlight.AS1000_PFD_SOFTKEYS_5")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 554,852,50,32, sc_5_click)

            function sc_6_click()
                --fs2020_event("TOGGLE_GPS_DRIVES_NAV1")
                fs2020_event("MobiFlight.AS1000_PFD_SOFTKEYS_6")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 640,852,50,32, sc_6_click)

            function sc_7_click()
                fs2020_event("MobiFlight.AS1000_PFD_SOFTKEYS_7")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 724,852,50,32, sc_7_click)

            function sc_8_click()
                fs2020_event("MobiFlight.AS1000_PFD_SOFTKEYS_8")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 808,852,50,32, sc_8_click)

            function sc_9_click()
                fs2020_event("MobiFlight.AS1000_PFD_SOFTKEYS_9")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 892,852,50,32, sc_9_click)

            function sc_10_click()
                fs2020_event("MobiFlight.AS1000_PFD_SOFTKEYS_10")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 979,852,50,32, sc_10_click)

            function sc_11_click()
                fs2020_event("MobiFlight.AS1000_PFD_SOFTKEYS_11")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 1064,852,50,32, sc_11_click)

            function sc_12_click()
                fs2020_event("MobiFlight.AS1000_PFD_SOFTKEYS_12")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 1149,852,50,32, sc_12_click)
    -- End PFD
    -- MFD
        elseif g_unitpos == "3" then
            function sc_1_click()
                fs2020_event("MobiFlight.AS1000_MFD_SOFTKEYS_1")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 213,852,50,32, sc_1_click)

            function sc_2_click()
                fs2020_event("MobiFlight.AS1000_MFD_SOFTKEYS_2")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 297,852,50,32, sc_2_click)

            function sc_3_click()
                fs2020_event("MobiFlight.AS1000_MFD_SOFTKEYS_3")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 383,852,50,32, sc_3_click)

            function sc_4_click()
                fs2020_event("MobiFlight.AS1000_MFD_SOFTKEYS_4")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 468,852,50,32, sc_4_click)

            function sc_5_click()
                fs2020_event("MobiFlight.AS1000_MFD_SOFTKEYS_5")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 554,852,50,32, sc_5_click)

            function sc_6_click()
                --fs2020_event("TOGGLE_GPS_DRIVES_NAV1")
                fs2020_event("MobiFlight.AS1000_MFD_SOFTKEYS_6")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 640,852,50,32, sc_6_click)

            function sc_7_click()
                fs2020_event("MobiFlight.AS1000_MFD_SOFTKEYS_7")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 724,852,50,32, sc_7_click)

            function sc_8_click()
                fs2020_event("MobiFlight.AS1000_MFD_SOFTKEYS_8")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 808,852,50,32, sc_8_click)

            function sc_9_click()
                fs2020_event("MobiFlight.AS1000_MFD_SOFTKEYS_9")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 892,852,50,32, sc_9_click)

            function sc_10_click()
                fs2020_event("MobiFlight.AS1000_MFD_SOFTKEYS_10")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 979,852,50,32, sc_10_click)

            function sc_11_click()
                fs2020_event("MobiFlight.AS1000_MFD_SOFTKEYS_11")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 1064,852,50,32, sc_11_click)

            function sc_12_click()
                fs2020_event("MobiFlight.AS1000_MFD_SOFTKEYS_12")
                sound_play(click_snd)
            end

            button_add(nil,"uparrow_button.png", 1149,852,50,32, sc_12_click)
            end
        -- End MFD


    -- End MFD
-- End of SoftKeys

-- FMS Functions
    -- DIRECT TO
        function dir_click()
            if g_unitpos == "1" then  
                fs2020_event("MobiFlight.AS1000_PFD_DIRECTTO")
            elseif g_unitpos == "3" then
                fs2020_event("MobiFlight.AS1000_MFD_DIRECTTO")
            end
            sound_play(click_snd)
        end
        button_add(nil,"dir_button.png", 1262,621,50,32, dir_click)

    -- MENU
        function menu_click()
            if g_unitpos == "1" then          
                fs2020_event("MobiFlight.AS1000_PFD_MENU_Push")
            elseif g_unitpos == "3" then
                fs2020_event("MobiFlight.AS1000_MFD_MENU_Push")
            end
            sound_play(click_snd)
        end
        button_add(nil,"menu_button.png", 1334,621,50,32, menu_click)

    -- FPL
        function fpl_click()
            if g_unitpos == "1" then          
                fs2020_event("MobiFlight.AS1000_PFD_FPL_Push")
            elseif g_unitpos == "3" then
                fs2020_event("MobiFlight.AS1000_MFD_FPL_Push")
            end            
            sound_play(click_snd)
        end
        button_add(nil,"fpl_button.png", 1262,673,50,32, fpl_click)

    -- PROC
        function proc_click()
            if g_unitpos == "1" then            
                fs2020_event("MobiFlight.AS1000_PFD_PROC_Push")
            elseif g_unitpos == "3" then
                fs2020_event("MobiFlight.AS1000_MFD_PROC_Push")       
            end
            sound_play(click_snd)
        end
        button_add(nil,"proc_button.png", 1334,673,50,32, proc_click)

    -- CLR
        function clr_click_down()
            if g_unitpos == "1" then         
                fs2020_event("MobiFlight.AS1000_PFD_CLR")
            elseif g_unitpos == "3" then
                fs2020_event("MobiFlight.AS1000_MFD_CLR")            
            end
            sound_play(click_snd)
        end

        function clr_click_up()
            if g_unitpos == "1" then         
                fs2020_event("MobiFlight.AS1000_PFD_CLR")
            elseif g_unitpos == "3" then
                fs2020_event("MobiFlight.AS1000_MFD_CLR")            
            end
            sound_play(click_snd)
        end
        button_add(nil,"clr_button.png", 1262,725,50,32, clr_click_down, clr_click_up)

    -- ENT
        function ent_click()
            if g_unitpos == "1" then 
                fs2020_event("MobiFlight.AS1000_PFD_ENT_Push")
            elseif g_unitpos == "3" then    
                fs2020_event("MobiFlight.AS1000_MFD_ENT_Push")        
            end
            sound_play(click_snd)
        end

    button_add(nil,"ent_button.png", 1334,725,50,32, ent_click)
--End of FMS Functions

-- FMS
    function fms_outer_turn( direction)
        if g_unitpos == "1" then
            if direction ==  -1 then
                fs2020_event("MOBIFLIGHT.AS1000_PFD_FMS_Lower_DEC")
            elseif direction == 1 then
                fs2020_event("MOBIFLIGHT.AS1000_PFD_FMS_Lower_INC")
            end
        elseif g_unitpos == "3" then
            if direction ==  -1 then
                fs2020_event("MOBIFLIGHT.AS1000_MFD_FMS_Lower_DEC")
            elseif direction == 1 then
                fs2020_event("MOBIFLIGHT.AS1000_MFD_FMS_Lower_INC")
            end
        end
    end

    fms_dial_outer = dial_add("fms_knob.png", 1284,792,79,79, fms_outer_turn)
    dial_click_rotate( fms_dial_outer, 6)

    function fms_inner_turn( direction)
        if g_unitpos == "1" then
            if direction ==  -1 then
                print ("FMS Inner CCW Turn -")
                fs2020_event("MOBIFLIGHT.AS1000_PFD_FMS_Upper_DEC")
            elseif direction == 1 then
                print ("FMS Inner CW Turn +")
                fs2020_event("MOBIFLIGHT.AS1000_PFD_FMS_Upper_INC")
            end
        elseif g_unitpos == "3" then
            if direction ==  -1 then
                print ("FMS Inner CCW Turn -")
                fs2020_event("MOBIFLIGHT.AS1000_MFD_FMS_Upper_DEC")
            elseif direction == 1 then
                print ("FMS Inner CW Turn +")
                fs2020_event("MOBIFLIGHT.AS1000_MFD_FMS_Upper_INC")
            end
        end
    end

    fms_dial_inner = dial_add("Vol_knob.png", 1300,808,47,47, fms_inner_turn)
    dial_click_rotate( fms_dial_outer, 6)

    function cursor_click()
        if g_unitpos == "1" then
            fs2020_event("MOBIFLIGHT.AS1000_PFD_FMS_Upper_PUSH")
        elseif g_unitpos == "3" then  
            fs2020_event("MOBIFLIGHT.AS1000_MFD_FMS_Upper_PUSH")
        end                  
        sound_play(click_snd)
    end

    button_add(nil,nil, 1311,821,13,13, cursor_click)
-- End of FMS




--[[
-- Pan pallette
    -- add pan controls
    local pal_x = 1229
    local pal_y =  432

    function up_prs()
        xpl_command("sim/GPS/g1000n"..g_unitpos.."_pan_up")
    end

    up_press = button_add(nil, "up_arrow.png", pal_x + 69, pal_y + 0, 49,42, up_prs)

    function up_rt_prs()
        xpl_command("sim/GPS/g1000n"..g_unitpos.."_pan_up_right")
    end

    uprt_press = button_add(nil, "uprt_arrow.png", pal_x + 118, pal_y + 25, 46,48, up_rt_prs)

    function up_lt_prs()
        xpl_command("sim/GPS/g1000n"..g_unitpos.."_pan_up_left")
    end

    uplt_press = button_add(nil, "uplt_arrow.png", pal_x + 22, pal_y + 25, 47,47, up_lt_prs)

    function lt_prs()
        xpl_command("sim/GPS/g1000n"..g_unitpos.."_pan_left")
    end

    lt_press = button_add(nil, "lt_arrow.png", pal_x + 0, pal_y + 74, 44,46, lt_prs)

    function rt_prs()
        xpl_command("sim/GPS/g1000n"..g_unitpos.."_pan_right")
    end

    rt_press = button_add(nil, "rt_arrow.png", pal_x + 146, pal_y + 74, 44,46, rt_prs)

    function dn_prs()
        xpl_command("sim/GPS/g1000n"..g_unitpos.."_pan_down")
    end

    dn_press = button_add(nil, "down_arrow.png", pal_x + 69, pal_y + 148, 49,42, dn_prs)

    function dnrt_prs()
        xpl_command("sim/GPS/g1000n"..g_unitpos.."_pan_down_right")
    end

    dnrt_press = button_add(nil, "downrt_arrow.png", pal_x + 118, pal_y + 120, 46,48, dnrt_prs)

    function dnlt_prs()
        xpl_command("sim/GPS/g1000n"..g_unitpos.."_pan_down_left")
    end

    dnlt_press = button_add(nil, "downlt_arrow.png", pal_x + 22, pal_y + 120, 47,47, dnlt_prs)

    pan_background = img_add("pan_background.png", pal_x ,pal_y,190,190)
    local pan_vis = false
    visible(pan_background, pan_vis)

    function pansel_click()
        pan_vis = not pan_vis
        visible(pan_background, pan_vis)
        sound_play(click_snd)
    end    
    
    button_add(nil,nil, 1313,519,21,21, pansel_click)
--]]

-- Range Knob
    -- PFD
        if g_unitpos == "1" then
            function pfd_range_turn( direction)
                if direction ==  -1 then
                    fs2020_event("Mobiflight.AS1000_PFD_RANGE_DEC")
                elseif direction == 1 then
                    fs2020_event("Mobiflight.AS1000_PFD_RANGE_INC")  
                end
            end        
    --End PFD
    -- MFD
        elseif g_unitpos == "3" then
            function mfd_range_turn( direction)
                if direction ==  -1 then
                    fs2020_event("Mobiflight.AS1000_MFD_RANGE_DEC")
                elseif direction == 1 then
                    fs2020_event("Mobiflight.AS1000_MFD_RANGE_INC")  
                end
            end
    --End MFD
        end
    pfdrng_dial = dial_add("rng_knob.png", 1292,496,65,65, pfd_range_turn)
    mfdrng_dial = dial_add("rng_knob.png", 1292,496,65,65, mfd_range_turn)
    dial_click_rotate( pfdrng_dial, 6)
    dial_click_rotate( mfdrng_dial, 6)
-- End Range Knob

-- Barometric / CRS Knob
    function baro_turn( direction)
        if user_prop_get(set_altimeter) == "Kohlsman" then
            if direction ==  -1 then
                fs2020_event("KOHLSMAN_DEC") 
            elseif direction == 1 then
                fs2020_event("KOHLSMAN_INC") 
            end
        elseif user_prop_get(set_altimeter) == "G1000" then
            if direction ==  -1 then
                fs2020_event("MOBIFLIGHT.AS1000_PFD_BARO_DEC") 
            elseif direction == 1 then
                fs2020_event("MOBIFLIGHT.AS1000_PFD_BARO_INC") 
            end
        else -- Set Both Kohlsman & G1000
            if direction ==  -1 then
                fs2020_event("MOBIFLIGHT.AS1000_PFD_BARO_DEC") 
                fs2020_event("KOHLSMAN_DEC") 
            elseif direction == 1 then
                fs2020_event("MOBIFLIGHT.AS1000_PFD_BARO_INC") 
                fs2020_event("KOHLSMAN_INC") 
            end
        end
    end

    baro_dial  = dial_add("baro_knob.png", 1284,334,80,80, baro_turn)
    dial_click_rotate( baro_dial, 6)

    function crs_turn( direction)
        if direction ==  -1 then
            fs2020_event("MOBIFLIGHT.AS1000_PFD_CRS_DEC")
        elseif direction == 1 then
            fs2020_event("MOBIFLIGHT.AS1000_PFD_CRS_INC")
        end
    end

    crs_dial = dial_add("crs_knob.png", 1298,350,51,51,3, crs_turn)
    dial_click_rotate( crs_dial, 6)

    function crs_click()
        -- Add Custom Logic to provide a feedback variable to cover whichever VOR is active ???
        sound_play(click_snd)
    end

    button_add(nil,nil, 1315,370,13,13, crs_click)
-- End Baro / CRS
