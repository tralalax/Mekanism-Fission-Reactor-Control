# Mekanism Fission Reactor Control
This is a program for the fission reactor, the turbine, the boiler and the energy matrix for Mekanism made with ComputerCraft and AdvancedPeripherals
![Reactor Panel](https://imgur.com/a/mxdRCBv.png)

# Feature
- The display of the information about the main reactor but also the turbine, boiler and energy matrix
- The safe start-up. To avoid explosion or any problems with the reactor (the reactor will not start if certain safety conditions are not met).
- The emergency shutdown. It will automatically shut down the reactor if any problem shoes up while it is running.
- Touch screen to turn on/off the reactor and to run a check to see if everything is fine for the start up of the reactor (if the check up finds a problem the reactor will not start).

# How to setup everything
1. Download the [ReactorControlPanel.lua](https://github.com/tralalax/Mekanism-Fission-Reactor-Control/blob/main/ReactorControlPanel.lua) program and put it in a computer
2. Build your fission reactor, boiler, turbine, energy matrix with Mekanism and the 3 monitor (4*3 advanced monitor) then connect everything together with an advanced computer in where there is the program.
![Reactor connection](https://imgur.com/a/cAs4O90.png)
3. In the program, you will need to replace the text to the right of the "= " with the name of the wired modem. For example, my reactor's modem is called "fissionReactorLogicAdapter_0", so in the code it should be "ReactorPort = fissionReactorLogicAdapter_0".
4. Save and exit the code, then you can run it by typing "ReactorControlPanel" in the advanced computer.