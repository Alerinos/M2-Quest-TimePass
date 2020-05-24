-- Author Alerino
-- Version 1.0
-- Date 22.05.2020

quest timePass begin
    state start begin
    
        -- read me
        -- Settings are in function
        -- Additional settings:
        -- hook1 - NPc ID through which to teleport
        -- hook2 - Map ID on which it should teleport
    
        function setting()
            return {
                ['home'] = {908, 3239}, -- x y village location
                ['map'] = {908, 3239},  -- x y map to which to teleport
                ['item']    = 31094,    -- SETTING The item you need
                ['count']   = 2,        -- SETTING The amount you need
                ['timeOut'] = 60*60*2,  -- SETTING time after which logout will take place (in seconds)
            }
        end
    
        -- NPC ID or when ID."Keep going".chat
        when 9004.click begin   -- hook 1
           local setting = timePass.setting()
           
           -- Header (mission name or npc)
           say_title(mob_name(9004)) -- hook 1
           
           -- text
           say("Do you want to go further?")
           say("Need "..item_name(setting['item']))
           
           if pc.count_item(setting['item']) >= setting['count'] then   -- Counts the number of items in EQ
                if select("Yes", "No") == 1 then
                    pc.removeitem(setting['item'], setting['count'])
                    pc.setqf("st", os.time())
                    
                    -- text
                    say("Lets go!")
                    
                    -- location
                    pc.warp(setting.map[1], setting.map[2])
                else
                    -- The text that will be displayed after canceling
                    say("Good bay!")   
                end
            else
                -- Text that will be displayed when you don't have a pass
                say("I need item"..item_name(setting['item']).." x "..setting['count'])               
            end
        end
        
        -- Map ID
        when login with pc.get_map_index() == 2 begin -- hook 2
            local setting = timePass.setting()
            
            if pc.getqf("st") >= os.time() - setting.timeOut then
                local calculateTime = pc.getqf("st") - (os.time() - setting.timeOut)
                timer('out', calculateTime)

                -- Welcome message
                syschat("You have left "..secondsToTime(calculateTime))
            else
                -- A message when there should be no user here
                syschat("You will be teleported to m1")
                pc.warp(setting.home[1], setting.home[2])
            end
        end
        
        when out.timer begin
            local setting = timePass.setting()
            
            syschat("Time is over, you're going back to m1")
            pc.warp(setting.home[1], setting.home[2])
        end
    end
end