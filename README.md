# G1000-AirMgr_Panel
G1000 ENABLEMENT HOW-TO GUIDE.
If you have  been suffering with the stock and limited functionality and have been waiting impatiently for the ASOBO Glass Cockpit updates. 
I have an alternative solution that provides the functionality you want and need.

tyo make best use of this Air Manager Panel you will also need the MOBIFLIGHT Events WASM module installed into you community folder and also highly recommended is the Working Title G1000 Mod available at https://github.com/Working-Title-MSFS-Mods/fspackages

MobiFlight Installation [Updated 01-09-2021]
MobiFlight installation / integration is as easy as downloading and install the MobiFlight zip file from https://www.mobiflight.com 239. 
As of this writing you need at least ver. 7.10.0
There may be security warnings when you extract the zip due to unsigned drivers. Scan the file yourself before extraction and decide on the best course of action for you.
Here are the steps that you need to do to get access to the new events:
These are the instructions from the Flight Tracker user guide 31 to install Mobiflight and get the module.

Have MSFS 2020 stopped.
Install MobiFlight - Download MobiFlight für Arduino, FSUIPC und FSX oder X-Plane 45
Run MobiFlight
In the Extras -> Settings menu, at the bottom, check “I would like to receive beta version updates”
Click “Help -> Check for update”
After update, navigate to the install location for MobiFlight on your machine.
There should now be a “MSFS2020-module” folder, open that folder.
Copy the “mobiflight-event-module” folder to your MSFS community folder.
Relaunch MSFS 2020
Configure Flight-Stream-Deck with newly supported events 46, courtesy of MobiFlight! They are like the normal SDK events, except the wasm module in the community folder interacts with the gauges/instruments directly when receiving them.
That’s it, integration done!

A little bit of background to help explain the module. Microsoft have changed the way they do new Addons for FS2020 and now use Web Assemblies. This event module integrates into FS2020 itself and extends the events list that are supported via SimConnect, SimConnect is really just a way to communicate between the Sim and external software and hardware. Don’t be at all surprised to find future Asobo extensions use the same technique.

Other tools I use:

-FSUIPC7 Pretty much only used to see what events are triggered

-VS Code with LUA extensions for LUA editing though you could use Notepad ++ if you like.

-New MobiSoft Events.

There are a couple of ways to get the list of new events that relate to to the various Glass Cockpit versions.

One is to gather the info from Mobisoft,com itself.

Another way (This is how I did it) I use the Flight Tracker Structs.cs file which also integrates with MobiFlight. if you go to the Flight Tracker Git Repo, and open the Flight-Tracker-StreamDeck/FlightStreamDeck.Core at master · nguyenquyhy/Flight-Tracker-StreamDeck · GitHub 25 Folder you will find the file that lists all the available flight Tracker events and variables. Look for the Events section then just search for the MOBIFLIGHT events that were added when Flight Tracker added MobiFlight integration.
When there are new releases, I just import the events and variables into a simple spreadsheet and then use filters on the data to find what need.

A thrid option is to use this list: MobiFlight Event Module SimConnect Event IDs - Pastebin.com 33

Air Manager
There is currently a Beta Version 4 available for download from Sim Innovations. Its free at present I think. https://SimInnovations.com 23. I have found it to be stable and only a couple of minor issues present.

Updating the overlay yourself.

Once familiar with Air Manager you can go find the XPlane G1000 overlay or other gauge in the online gauge repository in the app.

You will be editing the LUA file for the overlay (logic.lua) This one does not yet support FS2020. The Changes or additions you’ll make are rudimentary. See here - YouTube 20 for a full video series on gauge construction. The main videos ones you might want to look at are for Dials and Buttons.

These examples below use the G1000 Overlay for Xplane as our example.

What you will be adding are new lines for FS2020_Events. Simply open the logic.lua file look inside the various callback functions associated with each Button or Dial to see the existing events. Look for the xpl_command(“Dataref name”) lines…
I replaced or added FS2020_Event(“eventname”) I use the MOBIFLIGHT events because it drives the current G1000 Logic so you can do minimal coding to get things working.

MOBIFLIGHT Events add what you will need to make your FS2020 glass panel work. In some cases you may / will need to craft your own logic too (I did for Target Altitude but it is pretty simple stuff. So lets get down to an example or three:

Swapping Selected Nav Radio to be tuned, Nav1 or 2
function nav_ff()
–fs2020_event(“NAV1_RADIO_SWAP”)
fs2020_event(“MOBIFLIGHT.AS1000_PFD_NAV_Switch”)
–xpl_command(“sim/GPS/g1000n”…g_unitpos…"_nav_ff")
sound_play(click_snd)

end

button_add(nil,“ff_button.png”, 102,107,50,32, nav_ff)

Pressing Softkey 6 (CDI)
function sc_6_click()
–fs2020_event(“TOGGLE_GPS_DRIVES_NAV1”)
fs2020_event(“MobiFlight.AS1000_PFD_SOFTKEYS_6”)
sound_play(click_snd)
end

button_add(nil,“uparrow_button.png”, 640,852,50,32, sc_6_click)

That’s about as complex as it needs to be to get started. If you already have a Knobster then you can really dial up your control!

Important to note
MOBIFLIGHT is Donate-Ware developed in Germany (I Think) If this helps you along PLEASE help out the community and support further development by sending a few dollars or whatever your local currency is, to help support the product development efforts! Oh and spread word too!!!
