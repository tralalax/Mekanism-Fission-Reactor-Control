----------------------------------------------- CONFIG -----------------------------------------------

TurbinePort = "turbineValve_0"
ReactorPort = "fissionReactorLogicAdapter_9"
BoilerPort = "boilerValve_1"
MatrixPort = "inductionPort_0"
Monitor1Port = "monitor_5"
Monitor2Port = "monitor_7"
Monitor3Port = "monitor_6"

------------------------------------------------------------------------------------------------------

-- Turbine Detection
if peripheral.wrap(TurbinePort) ~= nil then
    turbine = peripheral.wrap(TurbinePort)
    print("turbine detected")
else
    print("Turbine not found")
end

-- Fission Reactor Detection
if peripheral.wrap(ReactorPort) ~= nil then
    reactor = peripheral.wrap(ReactorPort)
    print("reactor detected")
else
    print("Fission Reactor not found")
end

-- Boiler detection
if peripheral.wrap(BoilerPort) ~= nil then
    boiler = peripheral.wrap(BoilerPort)
    print("Boiler detected")
else
    print("Boiler not found")
end

-- energy matrix detection
if peripheral.wrap(MatrixPort) ~= nil then
    matrix = peripheral.wrap(MatrixPort)
    print("matrix detected")
else
    print("Energy Matrix not found")
end

-- Reactor monitor detection
if peripheral.wrap(Monitor1Port) ~= nil then
    Reacmonitor = peripheral.wrap(Monitor1Port)
    print("monitor 1 detected")
else
    print("Monitor 1 not found")
end

-- Boiler monitor detection
if peripheral.wrap(Monitor2Port) ~= nil then
    Boilmonitor = peripheral.wrap(Monitor2Port)
    print("monitor 2 detected")
else
    print("Monitor 2 not found")
end

-- control monitor detection
if peripheral.wrap(Monitor3Port) ~= nil then
    Controlmonitor = peripheral.wrap(Monitor3Port)
    print("monitor 3 detected")
else
    print("Monitor 3 not found")
end

ReadyToLaunch = false

local reacWindow = window.create(Reacmonitor, 1, 1, 30, 30)
local boilWindow = window.create(Boilmonitor, 1, 1, 30, 30)

reacWindow.setTextColour(colours.white)
reacWindow.clear()
boilWindow.setTextColour(colours.white)
boilWindow.clear()
Controlmonitor.setTextColour(colours.white)
Controlmonitor.setBackgroundColour(colours.black)
Controlmonitor.clear()


local function ReacStatus()
    if reactor.getStatus() == true then
        reacWindow.setTextColour(colors.lime)
        reacWindow.write("REACTOR ENABLE")
    else
        reacWindow.setTextColour(colors.red)
        reacWindow.write("REACTOR DISABLE")
    end
end

local function BoilStatus()
    if boiler.getBoilRate() > 1 then
        boilWindow.setTextColour(colors.lime)
        boilWindow.write("BOILER ENABLE")
    else
        boilWindow.setTextColour(colors.red)
        boilWindow.write("BOILER DISABLE")
    end
end

local function TurbStatus()
    if turbine.getFlowRate() > 1 then
        boilWindow.setTextColour(colors.lime)
        boilWindow.write("TURBINE ENABLE")
    else
        boilWindow.setTextColour(colors.red)
        boilWindow.write("TURBINE DISABLE")
    end
end

local function turbineDumpMode()
    if turbine.getDumpingMode() == "DUMPING_EXCESS" then
        boilWindow.write("mode : dumping excess")
    elseif turbine.getDumpingMode() == "DUMPING" then
        boilWindow.write("mode : dumping")
    elseif turbine.getDumpingMode() == "IDLE" then
        boilWindow.write("mode : idle")
    end
end

local function ChekUp()
    if (turbine.getDumpingMode() == "IDLE" and math.floor(100*(turbine.getSteamFilledPercentage())) >= 90) or math.floor(100*(reactor.getDamagePercent())) > 5 or math.floor(100*(reactor.getWasteFilledPercentage())) > 90 then
        ReadyToLaunch = false
    else
        ReadyToLaunch = true
    end    
end

local StartButtonWindow = window.create(Controlmonitor, 3, 2, 11, 20)
local StopButtonWindow = window.create(Controlmonitor, 17, 2, 11, 20)
local CheckButtonWindow = window.create(Controlmonitor, 3, 5, 11, 20)

StartButtonWindow.setTextColour(colours.white)
StartButtonWindow.clear()
StopButtonWindow.setTextColour(colours.white)
StopButtonWindow.clear()
CheckButtonWindow.setTextColour(colours.white)
CheckButtonWindow.clear()

StartButtonWindow.setBackgroundColour(colours.lime)
StartButtonWindow.write(" Toggle On ")
StartButtonWindow.setCursorPos(1,2)
StartButtonWindow.write("  Reactor  ")

StopButtonWindow.setBackgroundColour(colours.red)
StopButtonWindow.write(" Toggle Off ")
StopButtonWindow.setCursorPos(1,2)
StopButtonWindow.write("  Reactor   ")

CheckButtonWindow.setBackgroundColour(colors.gray)
CheckButtonWindow.write("  Launch   ")
CheckButtonWindow.setCursorPos(1,2)
CheckButtonWindow.write(" Check up  ")

Controlmonitor.setCursorPos(1,8)
Controlmonitor.setTextColour(colours.yellow)
Controlmonitor.write("Ready to launch ? : ")

local function control()
    while true do
        local event, side,x,y = os.pullEvent("monitor_touch")
        if side == "monitor_6" then
            if y == 2 or y == 3 then -- toggle on
                if x >= 2 and x <= 13 then
                    print("toggle on BUTTON")
                    ChekUp()
                    if ReadyToLaunch == true and reactor.getStatus() == false then
                        reactor.activate()
                        print("Reactor activated")
                    end
                elseif x >= 17 and x <= 27 then -- toggle off
                    print("toggle off BUTTON")
                    if reactor.getStatus() == true then
                        reactor.scram()
                        print("Reactor disabled")
                    end
                end
            elseif y == 5 or y == 6 then -- check up
                if x >= 2 and x <= 13 then
                    ChekUp()
                    print("check up launched BUTTON")
                    if ReadyToLaunch == true then
                        Controlmonitor.setCursorPos(1,8)
                        Controlmonitor.clearLine()
                        Controlmonitor.setTextColour(colours.yellow)
                        Controlmonitor.write("Ready to launch ? : ")
                        Controlmonitor.setCursorPos(21,8)
                        Controlmonitor.setTextColour(colours.lime)
                        Controlmonitor.write("YES")
                    else
                        Controlmonitor.setCursorPos(1,8)
                        Controlmonitor.clearLine()
                        Controlmonitor.setTextColour(colours.yellow)
                        Controlmonitor.write("Ready to launch ? : ")
                        Controlmonitor.setCursorPos(21,8)
                        Controlmonitor.setTextColour(colours.red)
                        Controlmonitor.write("NO")
                    end
                end
            end
--            print("monitor touched at (" .. x .. ", " .. y .. ")")
        end
    end
end


local function infoDisplay()
    while true do
        reacWindow.setVisible(false)
        reacWindow.clear()
        boilWindow.setVisible(false)
        boilWindow.clear()

        reacWindow.setCursorPos(1,1) -- REACTOR INFO ------------------------------------------------------------------------------------------
        reacWindow.setTextColour(colors.yellow)
        reacWindow.write("REACTOR INFO : ")
        reacWindow.setTextColour(colors.white)
        reacWindow.setCursorPos(1,2)
        ReacStatus()
        reacWindow.setTextColour(colours.white)
        reacWindow.setCursorPos(1,4)
        if math.floor(100*(reactor.getDamagePercent())) > 5 then
            reacWindow.setTextColour(colors.red)
        end
        reacWindow.write("Damage : "..math.floor(reactor.getDamagePercent()) .." %")
        reacWindow.setTextColour(colors.white)
        reacWindow.setCursorPos(1,5)
        reacWindow.write("Heating Rate : "..reactor.getHeatingRate().." mb/t")
        reacWindow.setCursorPos(1,6)
        reacWindow.write("Temperature : "..math.floor(reactor.getTemperature()-273.15).." °C")
        reacWindow.setCursorPos(1,7)
        reacWindow.write("Set Burn Rate : "..reactor.getBurnRate().." mb/t")
        reacWindow.setCursorPos(1,8)
        reacWindow.write("Actual Burn Rate : "..reactor.getActualBurnRate().." mb/t")
        reacWindow.setCursorPos(1,10)
        if math.floor(100*(reactor.getWasteFilledPercentage())) > 90 then
            reacWindow.setTextColour(colors.red)
        end
        reacWindow.write("Waste Amount : "..math.floor(100*(reactor.getWasteFilledPercentage())).." %")
        reacWindow.setTextColour(colors.white)
        reacWindow.setCursorPos(1,11)
        reacWindow.write("Fuel Amount : "..math.floor(100*(reactor.getFuelFilledPercentage())).." %")
        reacWindow.setCursorPos(1,12)
        reacWindow.write("Coolant Amount : "..math.floor(100*(reactor.getCoolantFilledPercentage())).." %")
        reacWindow.setCursorPos(1,13)
        reacWindow.write("Heated Coolant Amount : "..math.floor(100*(reactor.getHeatedCoolantFilledPercentage())).." %")

        reacWindow.setCursorPos(1,15) -- ENERGY INFO ------------------------------------------------------------------------------------------
        reacWindow.setTextColour(colors.yellow)
        reacWindow.write("ENERGY INFO : ")
        reacWindow.setTextColour(colors.white)
        reacWindow.setCursorPos(1,17)
        reacWindow.write("Energy Input : "..matrix.getLastInput().." EU/t")
        reacWindow.setCursorPos(1,18)
        reacWindow.write("Energy Output : "..matrix.getLastOutput().." EU/t")
        reacWindow.setCursorPos(1,19)
        reacWindow.write("Energy Stored : "..math.floor(100*(matrix.getEnergyFilledPercentage())).." %")

        boilWindow.setCursorPos(1,1) -- BOILER INFO ------------------------------------------------------------------------------------------
        boilWindow.setTextColour(colors.yellow)
        boilWindow.write("BOILER INFO :")
        boilWindow.setTextColour(colors.white)
        boilWindow.setCursorPos(1,2)
        BoilStatus()
        boilWindow.setTextColour(colors.white)
        boilWindow.setCursorPos(1,4)
        boilWindow.write("Boiler Capacity : "..boiler.getBoilCapacity().." mb")
        boilWindow.setCursorPos(1,5)
        boilWindow.write("Boiler Rate : "..boiler.getBoilRate().." mb/t")
        boilWindow.setCursorPos(1,6)
        boilWindow.write("Boiler Temperature : "..math.floor(boiler.getTemperature()-273.15).." °C")
        boilWindow.setCursorPos(1,7)
        boilWindow.write("Water Needed : "..boiler.getWaterNeeded().." mb/t")
        --boilWindow.setCursorPos(1,9)
        --boilWindow.write("Coolant Amount : "..math.floor(100*(boiler.getCoolantFilledPercentage())).." %")
        boilWindow.setCursorPos(1,9)
        boilWindow.write("Heated Coolant Amount : "..math.floor(100*(boiler.getHeatedCoolantFilledPercentage())).." %")
        boilWindow.setCursorPos(1,10)
        boilWindow.write("Water Amount : "..math.floor(100*(boiler.getWaterFilledPercentage())).." %")
        boilWindow.setCursorPos(1,11)
        boilWindow.write("Steam Amount : "..math.floor(100*(boiler.getSteamFilledPercentage())).." %")

        boilWindow.setCursorPos(1,13) -- TURBINE INFO ------------------------------------------------------------------------------------------
        boilWindow.setTextColour(colors.yellow)
        boilWindow.write("TURBINE INFO :")
        boilWindow.setTextColour(colors.white)
        boilWindow.setCursorPos(1,14)
        TurbStatus()
        boilWindow.setTextColour(colors.white)
        boilWindow.setCursorPos(1,16)
        boilWindow.write("Steam Capacity : "..turbine.getSteamCapacity().." mb")
        boilWindow.setCursorPos(1,17)
        boilWindow.write("Steam Input : "..turbine.getLastSteamInputRate().." mb/t")
        boilWindow.setCursorPos(1,18)
        boilWindow.write("Energy Production : "..turbine.getProductionRate().." mb/t")
        boilWindow.setCursorPos(1,19)
        boilWindow.write("Flow Rate : "..turbine.getFlowRate().." mb/t")
        boilWindow.setCursorPos(1,21)
        if math.floor(100*(turbine.getSteamFilledPercentage())) > 90 then
            boilWindow.setTextColour(colors.red)
        end
        boilWindow.write("Steam Amount : "..math.floor(100*(turbine.getSteamFilledPercentage())).." %")
        boilWindow.setTextColour(colors.white)
        boilWindow.setCursorPos(1,22)
        turbineDumpMode()

        reacWindow.setVisible(true)
        boilWindow.setVisible(true)
    end
end

local function EmergencyScram()
    while true do
        if (turbine.getDumpingMode() == "IDLE" and math.floor(100*(turbine.getSteamFilledPercentage())) >= 90) or math.floor(100*(reactor.getDamagePercent())) > 5 or math.floor(100*(reactor.getWasteFilledPercentage())) > 90 then
            if reactor.getStatus() == true then
                reactor.scram()
                print("EMERGENCY SCRAM TRIGGERED")
                Controlmonitor.setCursorPos(1,9)
                Controlmonitor.setTextColour(colours.red)
                Controlmonitor.write("EMERGENCY SCRAM TRIGGERED")
            end
        else
            Controlmonitor.setCursorPos(1,9)
            Controlmonitor.clearLine()
        end
    end
end

parallel.waitForAll(infoDisplay,control,EmergencyScram)    