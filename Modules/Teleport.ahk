#Requires AutoHotkey v2.0

; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; DIRECTIVES & CONFIGURATIONS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

#SingleInstance Force  ; Forces the script to run only in a single instance. If this script is executed again, the new instance will replace the old one.
CoordMode "Mouse", "Client"  ; Sets the coordinate mode for mouse functions (like Click, MouseMove) to be relative to the active window's client area, ensuring consistent mouse positioning across different window states.
CoordMode "Pixel", "Client"  ; Sets the coordinate mode for pixel functions (like PixelSearch, PixelGetColor) to be relative to the active window's client area, improving accuracy in color detection and manipulation.
SetMouseDelay 10  ; Sets the delay between mouse events to 10 milliseconds, balancing speed and reliability of automated mouse actions.


; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; LIBRARIES
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; Macro Related Libraries:
#Include "%A_ScriptDir%\Modules"
#Include "Zones.ahk"


; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; GLOBAL VARIABLES
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

TELEPORT_PIXEL := Map(
    "MENU_ICON", Map("START", [66, 108], "END", [66, 108], "COLOUR", "0xD81140", "TOLERANCE", 2),
    "SEARCH_CURSOR", Map("START", [610, 117], "END", [630, 117], "COLOUR", "0xAFAFAF", "TOLERANCE", 2),
    "SEARCH_TERM", Map("START", [676, 100], "END", [685, 115], "COLOUR", "0x1E1E1E", "TOLERANCE", 2),
    "DESTINATION_BLUE", Map("START", [441, 245], "END", [441, 245], "COLOUR", "0x5ADAFF", "TOLERANCE", 2),
    "DESTINATION_GREEN", Map("START", [441, 245], "END", [441, 245], "COLOUR", "0x60F002", "TOLERANCE", 2),
    "DESTINATION_WHITE", Map("START", [441, 245], "END", [441, 245], "COLOUR", "0xFFFFFF", "TOLERANCE", 2),
    "CONFIRM_TELEPORT", Map("START", [187, 126], "END", [187, 126], "COLOUR", "0x53E3FF", "TOLERANCE", 2),
    "CONTROL", Map("START", [109, 190], "END", [109, 190], "COLOUR", "0xC80A2F", "TOLERANCE", 2),
    "SKIP_BUTTON", Map("START", [365, 575], "END", [365, 575], "COLOUR", "0xFD9E42", "TOLERANCE", 2)
)

TELEPORT_COORDS := Map(
    "CONTROL", [110, 190],
    "MENU_ICON", [66, 108],
    "SEARCH_BOX", [600, 107],
    "SEARCH_ZONE", [398, 193],
    "CLOSE", [746, 109],
    "WORLD_1", [22, 238],
    "WORLD_2", [22, 284],
    "WORLD_3", [22, 328],
    "CONFIRM_TELEPORT", [291, 422],
    "SKIP_BUTTON", [365, 575]
)

; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; TELEPORT FUNCTIONS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

teleportToZone(zoneNumber) {
    ;setCurrentAction("Teleporting to Zone " zoneNumber "...")  ; Update UI to show teleport action.
    ;setCurrentZone(zoneNumber)  ; Set new zone number.
    activateRoblox()  ; Ensure Roblox window is active.
    closeTeleportMenu()
    openTeleportMenu()  ; Open the teleport menu.
    clickTeleportSearchBox()  ; Click on the search box within the teleport menu.
    enterTeleportSearchTerm(zoneNumber)  ; Enter the zone number into the search box.
    alreadyInZone := false
    if isDestinationGreen()
        clickTeleportButton(zoneNumber)  ; Click the button to initiate teleportation.
    else
        alreadyInZone := true
    closeTeleportMenu()  ; Close the teleport menu.
    ;setCurrentAction("-")  ; Reset current action status.
    return alreadyInZone
}

openTeleportMenu() {
    if isTeleportMenuOpen()
        return

    button := TELEPORT_COORDS["CONTROL"]

    Loop 100 {
        SendEvent "{Click, " button[1] ", " button[2] ", 1}"  ; Click to open the teleport menu.
        Loop 25 {  ; Loop to check if the menu has opened.   
            Sleep 10  ; Brief pause between checks to reduce CPU usage.            
            if isTeleportMenuOpen()  ; Check if the teleport menu is open.
                return
        }        
    }


}

clickTeleportMenuIcon() {
    button := TELEPORT_COORDS["MENU_ICON"]

    Loop 100 {
        SendEvent "{Click, " button[1] ", " button[2] ", 1}"  ; Click on the teleport search box.     
        Loop 25 { 
            Sleep 10
            if isTeleportMenuOpen()
                return
        }
    }
}

clickTeleportSearchBox() {
    button := TELEPORT_COORDS["SEARCH_BOX"]
    
    Loop 100 {
        SendEvent "{Click, " button[1] ", " button[2] ", 1}"  ; Click on the teleport search box.  
        Loop 25 {  ; Loop to check if the search box is selected.
            Sleep 10  ; Brief pause between checks to reduce CPU usage.
            if isTeleportSearchBoxSelected()  ; Check if the search box is selected. {
                return ; Exit the loop if the search box is selected.
        }
    }

}

enterTeleportSearchTerm(zoneNumber) {
    
    SendText ZONE_MAP.Get(zoneNumber)  ; Enter the text for the specified zone number into the search box.

    Loop 100 {  ; Loop to check if the search term has been entered.
        if isTeleportSearchTermEntered()  ; Check if the search term is entered.
            return  ; Exit the loop if the search term is entered.
        Sleep 10  ; Brief pause between checks to reduce CPU usage.
    }

}

clickTeleportButton(zoneNumber) {
    button := TELEPORT_COORDS["SEARCH_ZONE"]
    SendEvent "{Click, " button[1] ", " button[2] ", 1}"  ; Click on the teleport button.
    
    closeTeleportMenu()  ; Close the teleport menu.   
    openTeleportMenu()  ; Reopen the teleport menu.
    clickTeleportSearchBox()  ; Click on the search box within the teleport menu.
    enterTeleportSearchTerm(zoneNumber)  ; Re-enter the zone number into the search box.
    
    Loop 250 {  ; Loop to check if the destination is ready again.
        if isDestinationBlue()  ; Check if the destination is ready.
            break  ; Exit the loop if the destination is ready.
        Sleep 10  ; Brief pause between checks to reduce CPU usage.
    }
}

closeTeleportMenu() {
    if isTeleportMenuOpen() {
        button := TELEPORT_COORDS["CLOSE"]
        SendEvent "{Click, " button[1] ", " button[2] ", 1}"  ; Click on the close button of the teleport menu.
        Loop 100 {
            if !isTeleportMenuOpen()
                break
            Sleep 10
        }
    }
}

; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; PIXEL CHECKS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰


isTeleportMenuOpen() {
    pixel := TELEPORT_PIXEL["MENU_ICON"]
    return PixelSearch(&foundX, &foundY,  ; Perform a pixel search.
        pixel["START"][1], pixel["START"][2],  ; Starting coordinates for the search area.
        pixel["END"][1], pixel["END"][2],  ; Ending coordinates for the search area.
        pixel["COLOUR"], pixel["TOLERANCE"])  ; Color and tolerance for the search.
}


isTeleportSearchBoxSelected() {
    pixel := TELEPORT_PIXEL["SEARCH_CURSOR"]
    return PixelSearch(&foundX, &foundY,  ; Perform a pixel search.
        pixel["START"][1], pixel["START"][2],  ; Starting coordinates for the search area.
        pixel["END"][1], pixel["END"][2],  ; Ending coordinates for the search area.
        pixel["COLOUR"], pixel["TOLERANCE"])  ; Color and tolerance for the search.
}


isTeleportSearchTermEntered() {
    pixel := TELEPORT_PIXEL["SEARCH_TERM"]    
    return PixelSearch(&foundX, &foundY,  ; Perform a pixel search.
        pixel["START"][1], pixel["START"][2],  ; Starting coordinates for the search area.
        pixel["END"][1], pixel["END"][2],  ; Ending coordinates for the search area.
        pixel["COLOUR"], pixel["TOLERANCE"])  ; Color and tolerance for the search.
}


isDestinationBlue() {
    pixel := TELEPORT_PIXEL["DESTINATION_BLUE"]     
    return PixelSearch(&foundX, &foundY,  ; Perform a pixel search.
        pixel["START"][1], pixel["START"][2],  ; Starting coordinates for the search area.
        pixel["END"][1], pixel["END"][2],  ; Ending coordinates for the search area.
        pixel["COLOUR"], pixel["TOLERANCE"])  ; Color and tolerance for the search.
}


isDestinationGreen() {
    pixel := TELEPORT_PIXEL["DESTINATION_GREEN"]   
    return PixelSearch(&foundX, &foundY,  ; Perform a pixel search.
        pixel["START"][1], pixel["START"][2],  ; Starting coordinates for the search area.
        pixel["END"][1], pixel["END"][2],  ; Ending coordinates for the search area.
        pixel["COLOUR"], pixel["TOLERANCE"])  ; Color and tolerance for the search.
}

isDestinationWhite() {
    pixel := TELEPORT_PIXEL["DESTINATION_WHITE"]     
    return PixelSearch(&foundX, &foundY,  ; Perform a pixel search.
        pixel["START"][1], pixel["START"][2],  ; Starting coordinates for the search area.
        pixel["END"][1], pixel["END"][2],  ; Ending coordinates for the search area.
        pixel["COLOUR"], pixel["TOLERANCE"])  ; Color and tolerance for the search.
}

isTeleportWorldConfirmationOpen() {
    pixel := TELEPORT_PIXEL["CONFIRM_TELEPORT"]     
    return PixelSearch(&foundX, &foundY,  ; Perform a pixel search.
        pixel["START"][1], pixel["START"][2],  ; Starting coordinates for the search area.
        pixel["END"][1], pixel["END"][2],  ; Ending coordinates for the search area.
        pixel["COLOUR"], pixel["TOLERANCE"])  ; Color and tolerance for the search.    
}

isTeleportControlVisible() {
    pixel := TELEPORT_PIXEL["CONTROL"]     
    return PixelSearch(&foundX, &foundY,  ; Perform a pixel search.
        pixel["START"][1], pixel["START"][2],  ; Starting coordinates for the search area.
        pixel["END"][1], pixel["END"][2],  ; Ending coordinates for the search area.
        pixel["COLOUR"], pixel["TOLERANCE"])  ; Color and tolerance for the search.       
}

isSkipButtonShown() {
    pixel := TELEPORT_PIXEL["SKIP_BUTTON"]     
    return PixelSearch(&foundX, &foundY,  ; Perform a pixel search.
        pixel["START"][1], pixel["START"][2],  ; Starting coordinates for the search area.
        pixel["END"][1], pixel["END"][2],  ; Ending coordinates for the search area.
        pixel["COLOUR"], pixel["TOLERANCE"])  ; Color and tolerance for the search.      
}


; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; WORLD FUNCTIONS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

getWorld() {
    worldSpawns := [15, 100, 200]
    world := -1

    Loop 10 {
        openTeleportMenu()  ; Reopen the teleport menu.
        loop 3 {
            clickTeleportMenuIcon()
            clickTeleportSearchBox()  ; Click on the search box within the teleport menu.
            enterTeleportSearchTerm(worldSpawns[A_Index])  ; Re-enter the zone number into the search box.
            if !isDestinationWhite() {
                world := A_Index
                break
            }
        }
        
        if world != -1 {
            closeTeleportMenu()
            return world
        }
            
    }    

}

teleportToWorld(worldNumber) {
    openTeleportMenu()
    button := TELEPORT_COORDS["WORLD_" worldNumber]
    Loop {
        SendEvent "{Click, " button[1] ", " button[2] ", 1}"  
        Sleep 10
        if !isTeleportMenuOpen()
            break
    }
    
    button := TELEPORT_COORDS["CONFIRM_TELEPORT"]
    Loop 100 {
        if isTeleportWorldConfirmationOpen() {
            SendEvent "{Click, " button[1] ", " button[2] ", 1}"
            break
        }
        Sleep 10
    }

    ;Loop 100 {
    ;    if !isTeleportWorldConfirmationOpen()
    ;        break
    ;    Sleep 10
    ;}

    Loop 100 {
        if !isTeleportControlVisible()
            break
        Sleep 10
    }

    button := TELEPORT_COORDS["SKIP_BUTTON"]
    Loop {
        if isTeleportControlVisible()
            break
        if isSkipButtonShown()
            SendEvent "{Click, " button[1] ", " button[2] ", 1}"
        Sleep 100
    }

}