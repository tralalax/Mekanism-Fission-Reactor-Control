# Mekanism Fission Reactor Control
Reactor program for fission reactor, turbine, boiler and energy matrix with Mekanism made with ComputerCraft and AdvancedPeripherals
![Reactor Panel](https://imgur.com/a/mxdRCBv)

# Feature
- Display usefull information about the reactor itself but also the turbine, boiler and energy matrix.
- Safe start-up. To avoid explosion problems, the reactor will not start if certain safety conditions are not met.
- Emergency shutdown. If a problem happens while the reactor is running, it shuts down immediately.
- Touch screen to turn on/off the reactor, and run a check to see if everything is ok to start the reactor ( if not the reactor will not start).

# How to setup everything
1. Download the [ReactorControlPanel.lua](https://github.com/tralalax/Mekanism-Fission-Reactor-Control/blob/main/ReactorControlPanel.lua) program and put it in a computer
2. Build your fission reactor, boiler, turbine, energy matrix with Mekanism and the 3 monitor (4*3 advanced monitor) then connects everything together with an advanced computer in which there is the program
![Reactor connection](https://imgur.com/a/cAs4O90)
3. In the program, you will need to replace the text to the right of the = with the name of the wired modem. For example, my reactor's wired modem is called fissionReactorLogicAdapter_0, so in the code it should be ReactorPort = "fissionReactorLogicAdapter_0".
4. Save and exit the code, then you can run it by typing ReactorControlPanel in the advanced computer