#Requires AutoHotkey v2.0  ; Ensures the script runs only on AutoHotkey version 2.0, which supports the syntax and functions used in this script.

; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; TREE HOUSE - AutoHotKey 2.0 Macro for Pet Simulator 99
; Written by waktool
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

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

; Third-party Libraries:
#Include <OCR>
#Include <JXON>
#Include <Pin>

; Macro Related Libraries:
#Include "%A_ScriptDir%\Modules"
#Include "Maps.ahk"
#Include "Teleport.ahk"
#Include "Zones.ahk"

; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; GLOBAL VARIABLES
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; Macro details.
MACRO_TITLE := "Tree House"  ; The title displayed in main GUI elements.
MACRO_VERSION := "0.1.0"  ; Script version, helpful for user support and debugging.

; API settings.
URL_RAP_API := "https://biggamesapi.io/api/rap"

; File settings.
RAP_JSON := A_ScriptDir "\Assets\rap.json"
LOG_FOLDER := A_ScriptDir "\Logs\"
PRIORITY_TXT := A_ScriptDir "\priority.cfg"
SETTINGS_INI := A_ScriptDir "\Settings.ini"  ; Path to settings INI file.

; Replacement fonts.
TIMES_NEW_ROMAN := A_ScriptDir "\Assets\TimesNewRoman.ttf"  ; Path to Times New Roman font.
FREDOKA_ONE_REGULAR := A_ScriptDir "\Assets\FredokaOne-Regular.ttf"  ; Path to Fredoka One Regular font.

; Other settings.
LOG_DATE := FormatTime(A_Now, "yyyyMMdd")
ONE_SECOND := 1000

; Define the setting for changing worlds after a certain number of times opened.
CHANGE_WORLDS_AFTER_TIMES_OPENED := getSetting("ChangeWorldsAfterTimesOpened")

; Define a map for menu pixel positions and colors.
MENU_PIXEL := Map(
    "CHAT_ICON_WHITE", Map("START", [81, 24], "END", [81, 24], "COLOUR", "0xFFFFFF", "TOLERANCE", 2),
    "LEADERBOARD_RANK_STAR", Map("START", [652, 43], "END", [678, 59], "COLOUR", "0xB98335", "TOLERANCE", 50)
)

; Define a map for tree house pixel positions and colors.
TREE_HOUSE_PIXEL := Map(
    "TREE_BRANCH", Map("START", [359, 9], "END", [359, 9], "COLOUR", "0x6B5AB9", "TOLERANCE", 2)
)


; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; MACRO
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

runMacro()

; ----------------------------------------------------------------------------------------
; runMacro Function
; Description: Main function to execute the macro. It handles initializing, using secret keys,
;              interacting with the game elements, and logging activities.
; Operation:
;   - Activates the Roblox window.
;   - Completes initial setup tasks.
;   - Displays the statistics and main GUIs.
;   - Enters an infinite loop to perform tasks, including using secret keys, scanning items,
;     logging activities, and changing worlds.
; Dependencies:
;   - Various helper functions like activateRoblox, completeInitialisationTasks, updateRap, 
;     updatePriority, displayStatsGui, displayMainGui, useSecretKey, enterTreeHouse, 
;     walkToMerchant, scanItems, getBestIndex, clickBestItem, exitTreeHouse, 
;     populateMainGui, populateStatsGui, teleportToWorld, etc.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
runMacro() {
    activateRoblox()  ; Ensure the Roblox window is active.
    completeInitialisationTasks()  ; Perform all initial setup tasks.
    activateRoblox()
    secretKeyRap := updateRap()  ; Update the RAP data based on the downloaded JSON.
    updatePriority()  ; Update the priority of items based on a text file.
    displayStatsGui()  ; Display the statistics GUI.
    displayMainGui()  ; Display the main GUI.
    activateRoblox()  ; Ensure the Roblox window is active again.

    Loop {
        closeLeaderboard()  ; Close the leaderboard if it's open.
        closeChatLog()  ; Close the chat log if it's open.
        travelToTree()  ; Travel to the tree location.

        ; Infinite loop to perform the sequence of tasks.
        Loop {
            ; Determine movement keys based on the iteration index.
            keyMoveTowardsTree := A_Index == 1 ? "w" : "s"
            keyMoveAwayFromTree := A_Index == 1 ? "s" : "w"

            useSecretKey(keyMoveTowardsTree, keyMoveAwayFromTree)  ; Use a secret key.
            
            ; Check if the secret key was not consumed.
            Loop 50 {
                SendEvent "{Click, 400, 300, 1}"  ; Click in the middle of the screen to remove the mastery.
                Sleep 10  ; Wait 10 milliseconds before the next check.
                if isSecretKeyNotConsumed() {
                    STATS_MAP["Keys not consumed"].value++  ; Increment the count of keys not consumed.
                    STATS_MAP["Keys used"].value--  ; Decrement the count of keys used.
                    break  ; Exit the loop if the secret key was not consumed.
                }
            }
            
            ; Update the RAP value for the keys.
            STATS_MAP["Keys RAP (~)"].value := STATS_MAP["Keys used"].value * secretKeyRap

            ; Log the usage of the key.
            writeToActivityLog("--------------------------------------------------")
            writeToActivityLog("Key " STATS_MAP["Times opened"].value " (Consumed: " STATS_MAP["Keys used"].value 
                . " | Not Consumed: " STATS_MAP["Keys not consumed"].value 
                . " | Key RAP: " STATS_MAP["Keys RAP (~)"].value ")")

            enterTreeHouse(keyMoveTowardsTree, keyMoveAwayFromTree)  ; Enter the tree house.
            walkToMerchant()  ; Walk to the merchant.
            scanItems()  ; Scan items in the tree house.
            bestIndex := getBestIndex()  ; Get the index of the best item.
            clickBestItem(bestIndex)  ; Click the best item.

            ; Update the balance based on RAP values.
            STATS_MAP["Balance (~)"].value := STATS_MAP["Total RAP (~)"].value - STATS_MAP["Keys RAP (~)"].value

            ; Log the choices made.
            writeToActivityLog("Best: " bestIndex ": " CHOICE_MAP[bestIndex].itemName " ("
                . "Priority: " CHOICE_MAP[bestIndex].priority " | XP: " CHOICE_MAP[bestIndex].xp " | RAP: " CHOICE_MAP[bestIndex].rap ")")
            writeToActivityLog("Totals: Minimum RAP: " STATS_MAP["Total RAP (~)"].value .
                " | Balance: " STATS_MAP["Balance (~)"].value " | Minimum XP: " STATS_MAP["Total XP (~)"].value)

            populateMainGui(STATS_MAP["Times opened"].value, bestIndex)  ; Populate the main GUI with data.
            populateStatsGui()  ; Populate the stats GUI with data.
            exitTreeHouse()  ; Exit the tree house.
            
            if Mod(STATS_MAP["Times opened"].value, CHANGE_WORLDS_AFTER_TIMES_OPENED) == 0
                break  ; Break the loop to change worlds after a certain number of times opened.

            Sleep 1000  ; Sleep for 1000 milliseconds to prevent game issues with secret keys.
                        ; Note: This delay is to prevent secret keys from being used too quickly.
                        ; If you go too fast, the free buttons in the merchant are disabled and do not work.
        }

        teleportToWorld(2)  ; Teleport to the second world.
        teleportToWorld(1)  ; Teleport back to the first world.
        STATS_MAP["World changes"].value++  ; Increment the count of world changes.
        populateStatsGui()  ; Populate the stats GUI with data.

    }
}


; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; GUI INITIALISATION
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; ----------------------------------------------------------------------------------------
; displayStatsGui Function
; Description: Creates and displays a GUI window for statistics, with a list view to show various statistics.
; Operation:
;   - Initializes the GUI with the "AlwaysOnTop" property and sets its title and font.
;   - Adds a ListView control to the GUI with three columns: "#", "Statistic", and "Value".
;   - Sets the width and other properties for the columns.
;   - Shows the GUI and positions it at the top right of the screen.
;   - Calls populateStatsGui() to fill the ListView with data.
; Dependencies:
;   - populateStatsGui: Function that populates the ListView with statistics data.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
displayStatsGui(*) {
	global statsGui := Gui("+AlwaysOnTop")  ; Initialize the GUI with "AlwaysOnTop" property.
	statsGui.Title := "Statistics"  ; Set the title of the GUI window.
	statsGui.SetFont(, "Segoe UI")  ; Set the font of the GUI to "Segoe UI".

	global statsList := statsGui.AddListView("r10 w250 Sort NoSortHdr ReadOnly", ["#", "Statistic", "Value"])
    statsList.ModifyCol(1, 20)  ; Set the width of the first column.
	statsList.ModifyCol(2, 125)  ; Set the width of the second column.
    statsList.ModifyCol(3, 80)  ; Set the width of the third column.
    statsList.ModifyCol(3, "Integer")  ; Set the third column to display integers.

    statsGui.Show()  ; Show the GUI window.
    statsGui.GetPos(,, &Width,)  ; Get the position and width of the GUI.
    statsGui.Move(A_ScreenWidth - Width + 8, 0)  ; Position the GUI at the top right of the screen.

    populateStatsGui()  ; Populate the ListView with statistics data.
}

; ----------------------------------------------------------------------------------------
; displayMainGui Function
; Description: Creates and displays the main GUI window, including a list view for items and control buttons.
; Operation:
;   - Initializes the main GUI with the "AlwaysOnTop" property and sets its title and font.
;   - Adds a ListView control to display items with multiple columns.
;   - Adds control buttons for various functionalities.
;   - Positions the main GUI window relative to another GUI window (statsGui).
;   - Assigns event handlers to the buttons for their respective functions.
; Dependencies:
;   - MACRO_TITLE: Global variable for the title of the macro.
;   - MACRO_VERSION: Global variable for the version of the macro.
;   - statsGui: Another GUI window whose position is used to position the main GUI.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
displayMainGui() {
    ; Initialize the main GUI with "AlwaysOnTop" property.
    global mainGui := Gui("+AlwaysOnTop")
    mainGui.Title := MACRO_TITLE " v" MACRO_VERSION  ; Set the title incorporating global variables for title and version.
    mainGui.SetFont("s8", "Segoe UI")  ; Use "Segoe UI" font for a modern look.

    ; Create a list view for items with various columns.
    global itemList := mainGui.AddListView("r10 w575 NoSort ReadOnly", ["Key", "Option 1", "Option 2", "Option 3", "Selected"])
    itemList.ModifyCol(1, 40)  ; Modify column widths for better data presentation.
    itemList.ModifyCol(2, 125)
    itemList.ModifyCol(3, 125)
    itemList.ModifyCol(4, 125)
    itemList.ModifyCol(5, 125)
    itemList.ModifyCol(1, "Integer")  ; Set the first column to display integers.

    ; Add control buttons to the GUI for various functions.
    pauseButton := mainGui.AddButton("xs", "⏸ &Pause (F8)")
    wikiButton := mainGui.AddButton("yp", "🌐 &Wiki")
    reconnectButton := mainGui.AddButton("yp", "🔁 &Reconnect")
    changeFontButton := mainGui.AddButton("yp", "𝔄 &Default Font")

    ; Retrieve and adjust the GUI window position to the top right of the screen.
    statsGui.GetPos(&X, &Y, &statsW, &H)
    mainGui.Show()
    mainGui.GetPos(,, &mainW,)
    mainGui.Move(A_ScreenWidth - statsW - mainW + 22, 0)

    ; Assign events to buttons for respective functionalities.
    pauseButton.OnEvent("Click", pauseMacro)
    wikiButton.OnEvent("Click", openWiki)
    reconnectButton.OnEvent("Click", reconnectClient)
    changeFontButton.OnEvent("Click", changeToDefaultFont)
}

; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; TREE HOUSE FUNCTIONS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; ----------------------------------------------------------------------------------------
; exitTreeHouse Function
; Description: Simulates the process of exiting a tree house by clicking the home button and handling screen transitions.
; Operation:
;   - Clicks the home button with a slight random offset until the screen transitions.
;   - Waits for the screen transition to complete.
;   - Closes the merchant window if it is open.
; Dependencies:
;   - isTransitionScreen: Function that checks if the screen is transitioning.
;   - isMerchantWindowOpen: Function that checks if the merchant window is open.
;   - closeMerchantWindow: Function that closes the merchant window.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
exitTreeHouse() {
    homeButton := [400, 519]  ; Coordinates of the home button.

    ; Loop to click the home button until the screen transitions.
    Loop {
        clickX := homeButton[1] + Random(-3, 3)  ; Calculate X coordinate with a slight random offset.
        clickY := homeButton[2] + Random(-3, 3)  ; Calculate Y coordinate with a slight random offset.
        SendEvent "{Click, " clickX ", " clickY ", 1}"  ; Send a click event to the home button.
        Sleep 10  ; Add a short delay to prevent excessive CPU usage.
        if isTransitionScreen()  ; Check if the screen is transitioning.
            break  ; Exit the loop if the screen is transitioning.
    }

    ; Wait for the transition screen to complete.
    Loop {
        if !isTransitionScreen()  ; Check if the screen has finished transitioning.
            break  ; Exit the loop if the screen has finished transitioning.
        Sleep 10  ; Add a short delay to prevent excessive CPU usage.
    }

    ; Close the merchant window if it is open.
    if isMerchantWindowOpen()
        closeMerchantWindow()
}

; ----------------------------------------------------------------------------------------
; useSecretKey Function
; Description: Uses a secret key in the game by interacting with the secret key window.
; Operation:
;   - Moves towards the tree to interact with the secret key.
;   - Simulates key presses to open the interaction window.
;   - Clicks the "Yes" button to confirm the interaction.
;   - Updates the statistics map with the number of times opened and keys used.
;   - Moves away from the tree after the interaction is complete.
; Dependencies:
;   - isUseKeyWindowOpen: Function that checks if the interaction window is open.
;   - moveDirection: Function that simulates movement in a specified direction.
; Parameters:
;   - keyMoveTowardsTree: Key to move towards the tree (e.g., "s" for backward).
;   - keyMoveAwayFromTree: Key to move away from the tree (e.g., "w" for forward).
; Return: None
; ----------------------------------------------------------------------------------------
useSecretKey(keyMoveTowardsTree, keyMoveAwayFromTree) {
    Send "{" keyMoveTowardsTree " down}"  ; Start moving towards the tree.

    ; Loop to interact with the secret key until the interaction window opens.
    Loop {
        SendEvent "{e}"  ; Send the "e" key to interact.
        Sleep 10  ; Add a short delay to prevent excessive CPU usage.
        if isUseKeyWindowOpen()  ; Check if the interaction window is open.
            break  ; Exit the loop if the interaction window is open.
    }
    Send "{" keyMoveTowardsTree " up}"  ; Stop moving towards the tree.

    yesButton := [291, 422]  ; Coordinates of the "Yes" button.

    ; Loop to click the "Yes" button until the interaction window closes.
    Loop {
        ; Send a click event to the button coordinates with a slight random offset.
        clickX := yesButton[1] + Random(-3, 3)
        clickY := yesButton[2] + Random(-3, 3)
        SendEvent "{Click, " clickX ", " clickY ", 1}"
        Sleep 10  ; Add a short delay to prevent excessive CPU usage.
        if !isUseKeyWindowOpen()  ; Check if the interaction window is closed.
            break  ; Exit the loop if the interaction window is closed.
    }

    ; Update statistics.
    STATS_MAP["Times opened"].value++
    STATS_MAP["Keys used"].value++

    moveDirection(keyMoveAwayFromTree, 250)  ; Move away from the tree after the interaction.
}

; ----------------------------------------------------------------------------------------
; enterTreeHouse Function
; Description: Simulates the process of entering a treehouse by moving backward and handling screen transitions.
; Operation:
;   - Activates the Roblox window.
;   - Moves towards the treehouse for an initial duration.
;   - Continues moving back and forth until the screen transitions.
;   - Waits for the screen transition to complete.
; Dependencies:
;   - isTransitionScreen: Function that checks if the screen is transitioning.
;   - moveDirection: Function that simulates movement in a specified direction.
; Parameters:
;   - keyMoveTowardsTree: Key to move towards the treehouse (e.g., "s" for backward).
;   - keyMoveAwayFromTree: Key to move away from the treehouse (e.g., "w" for forward).
; Return: None
; ----------------------------------------------------------------------------------------
enterTreeHouse(keyMoveTowardsTree, keyMoveAwayFromTree) {
    activateRoblox()  ; Ensure the Roblox window is active.

    moveDirection(keyMoveTowardsTree, 800)  ; Move towards the treehouse for an initial duration.

    ; Keep moving down until the screen transitions.
    Loop {
        if isTransitionScreen()  ; Check if the screen is transitioning.
            break  ; Exit the loop if the screen is transitioning.
        moveDirection(keyMoveAwayFromTree, 50)  ; Move away from the treehouse for 50 milliseconds.
        moveDirection(keyMoveTowardsTree, 100)  ; Move towards the treehouse for 100 milliseconds.
        Sleep 10  ; Add a short delay to prevent excessive CPU usage.
        ; Note: This back-and-forth movement is necessary because sometimes entering the treehouse
        ; does not trigger on the first attempt, so we need to move back and forth until it does.
    }

    ; Wait until the screen transition completes.
    Loop {
        if !isTransitionScreen()  ; Check if the screen has finished transitioning.
            break  ; Exit the loop if the screen has finished transitioning.
        Sleep 10  ; Add a short delay to prevent excessive CPU usage.
    }
}

; ----------------------------------------------------------------------------------------
; walkToMerchant Function
; Description: Simulates walking forward until the merchant window is open.
; Operation:
;   - Sends a key down event to start walking forward.
;   - Continuously checks if the merchant window is open.
;   - Stops walking by sending a key up event once the merchant window is open.
; Dependencies:
;   - isMerchantWindowOpen: Function that checks if the merchant window is open.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
walkToMerchant() {
    Send "{w down}"  ; Start walking forward by pressing the "w" key.

    ; Loop to check if the merchant window is open.
    Loop {
        if isMerchantWindowOpen()  ; Check if the merchant window is open.
            break  ; Exit the loop if the merchant window is open.
        Sleep 10  ; Add a short delay to prevent excessive CPU usage.
    }

    Send "{w up}"  ; Stop walking by releasing the "w" key.

    moveDirection("s", 500)  ; Move backward for 100 milliseconds.
}

; ----------------------------------------------------------------------------------------
; clickBestItem Function
; Description: Clicks the specified best item button until the merchant window is closed.
; Operation:
;   - Defines the coordinates of the initial free button and the offset between buttons.
;   - Calculates the coordinates of the button to be clicked based on the best item index.
;   - Sends click events to the button coordinates in a loop with a slight random offset.
;   - Checks if the merchant window is still open.
;   - Breaks the loop once the merchant window is closed.
; Dependencies:
;   - isMerchantWindowOpen: Function that checks if the merchant window is open.
; Parameters:
;   - bestItem: The index of the best item to be clicked.
; Return: None
; ----------------------------------------------------------------------------------------
clickBestItem(bestItem) {
    freeButton := [167, 359]  ; Initial coordinates of the free button.
    xOffset := 233  ; Horizontal offset between buttons.

    ; Calculate the coordinates of the button to be clicked based on the best item index.
    buttonToUse := [freeButton[1] + ((bestItem - 1) * xOffset), freeButton[2]]

    ; Loop to click the button until the merchant window is closed.
    Loop 100 {
        ; Send a click event to the button coordinates with a slight random offset.
        clickX := buttonToUse[1] + Random(-3, 3)
        clickY := buttonToUse[2] + Random(-3, 3)
        SendEvent "{Click, " clickX ", " clickY ", 1}"

        ; Check if the merchant window is still open.
        if !isMerchantWindowOpen()
            break  ; Exit the loop if the merchant window is closed.
        
        Sleep 10  ; Short delay to allow the click event to process.
    }
}

; ----------------------------------------------------------------------------------------
; closeMerchantWindow Function
; Description: Attempts to close the merchant window by clicking the close button until the window is no longer open.
; Operation:
;   - Defines the coordinates of the close button.
;   - Sends a click event to the close button coordinates in a loop.
;   - Checks if the merchant window is still open.
;   - Breaks the loop once the merchant window is closed.
; Dependencies:
;   - isMerchantWindowOpen: Function that checks if the merchant window is open.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
closeMerchantWindow() {
    xButton := [745, 111]  ; Coordinates of the close button.

    ; Loop until the merchant window is closed.
    Loop {
        ; Send a click event to the close button coordinates.
        SendEvent "{Click, " xButton[1] ", " xButton[2] ", 1}"
        
        ; Check if the merchant window is still open.
        if !isMerchantWindowOpen()
            break  ; Exit the loop if the merchant window is closed.
        
        Sleep 10  ; Short delay to allow the click event to process.
    }
}

; ----------------------------------------------------------------------------------------
; scanItems Function
; Description: Scans the details of three items in the game and updates the CHOICE_MAP with the retrieved item details.
; Operation:
;   - Activates the Roblox window.
;   - Calculates the coordinates for each item and performs a click to bring up its details.
;   - Uses OCR and color detection to determine the item's name, rarity, and other details.
;   - Logs the details and updates the CHOICE_MAP.
; Dependencies:
;   - activateRoblox: Function to activate the Roblox window.
;   - getDetailsFromRarityMap: Function to get the rarity details from item coordinates.
;   - getItemNameWithOcr: Function to get the item name using OCR.
;   - getDetailsFromItemMap: Function to get item details from the item map.
;   - writeToDebugLog: Function to write debug information to a log file.
;   - writeToActivityLog: Function to write activity information to a log file.
;   - writeToErrorLog: Function to write error information to a log file.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
scanItems() {
    item1 := [100, 200]  ; Initial coordinates of the first item.
    xOffset := 230  ; Horizontal offset between items.

    Loop 3 {
        activateRoblox()  ; Ensure the Roblox window is active.

        ; Calculate the coordinates of the current item.
        itemCoordinates := [item1[1] + ((A_Index - 1) * xOffset), item1[2]]

        itemIndex := A_Index
        itemScanned := false
        maxAttempts := 5

        Loop maxAttempts {
            try {
                ; Perform a click at the item coordinates to bring up its details.
                SendEvent "{Click down, " itemCoordinates[1] ", " itemCoordinates[2] ", 1}"

                ; Get the rarity details and OCR item name from the item coordinates.
                rarityDetails := getDetailsFromRarityMap(itemCoordinates)
                if rarityDetails == "" {
                    writeToErrorLog("Item " itemIndex ": Unable to determine rarity color. (Attempt " A_Index "/" maxAttempts ")")
                }

                ocrItemName := getItemNameWithOcr(itemCoordinates)

                ; Retrieve item details based on the OCR item name and rarity.
                itemDetails := getDetailsFromItemMap(ocrItemName, rarityDetails.rarity)
                if itemDetails == "" {
                    writeToErrorLog("Item " itemIndex ": No match found in item map. (Ocr: " ocrItemName ", Rarity: " rarityDetails.rarity ") (Attempt " A_Index "/" maxAttempts ")")
                }

                ; Log the item details.
                writeToDebugLog("--------------------------------------------------")
                writeToDebugLog("Item: " itemIndex)
                writeToDebugLog(" RARITY DETAILS")
                writeToDebugLog(" * Rarity: " rarityDetails.rarity)
                writeToDebugLog(" * Color: " rarityDetails.properties.color)
                writeToDebugLog(" * XP: " rarityDetails.properties.xp)
                writeToDebugLog(" OCR DETAILS")
                writeToDebugLog(" * Result: " ocrItemName)
                writeToDebugLog(" ITEM DETAILS")                
                writeToDebugLog(" * Item: " itemDetails.name)
                writeToDebugLog(" * Rarity: " itemDetails.properties.rarity)
                writeToDebugLog(" * Category: " itemDetails.properties.category)
                writeToDebugLog(" * Id: " itemDetails.properties.id)
                writeToDebugLog(" * Tier: " itemDetails.properties.tn)
                writeToDebugLog(" * Regex: " itemDetails.properties.regex)
                writeToDebugLog(" * Priority: " itemDetails.properties.priority)
                writeToDebugLog(" API DETAILS")                
                writeToDebugLog(" * Value: " itemDetails.properties.value)                

                ; Update the CHOICE_MAP with the retrieved item details.
                CHOICE_MAP[itemIndex] := { 
                    itemName: itemDetails.name,
                    xp: rarityDetails.properties.xp,
                    rap: itemDetails.properties.value,
                    priority: itemDetails.properties.priority
                }

                writeToActivityLog(itemIndex ": " itemDetails.name " (Priority: " itemDetails.properties.priority 
                    . " | XP: " rarityDetails.properties.xp " | RAP: " itemDetails.properties.value ")")
            }
            catch as e {
                writeToErrorLog(e.What " " e.Message)  ; Log any errors encountered during the process.
            }
            else {
                itemScanned := true
                break  ; Exit the loop if the item is successfully scanned.
            } 
        }

        if !itemScanned
            writeToErrorLog("Item " itemIndex " not scanned.")  ; Log if the item was not successfully scanned after all attempts.
    }
}

; ----------------------------------------------------------------------------------------
; getBestIndex Function
; Description: Determines the index of the item with the highest priority (lowest priority value) in the CHOICE_MAP.
; Operation:
;   - Iterates through the CHOICE_MAP to find the item with the highest priority.
;   - Compares each item's priority to the current highest priority and updates accordingly.
; Dependencies: None
; Parameters: None
; Return: The index of the item with the highest priority in the CHOICE_MAP.
; ----------------------------------------------------------------------------------------
getBestIndex() {
    highestPriority := 1000  ; Initialize the highest priority value to a large number.
    bestIndex := -1  ; Initialize the best index to -1 to indicate no valid index found yet.

    ; Iterate through the CHOICE_MAP to find the item with the highest priority.
    for index, properties in CHOICE_MAP {
        if properties.priority < highestPriority {
            highestPriority := properties.priority  ; Update the highest priority value.
            bestIndex := index  ; Update the best index.
        }
    }

    STATS_MAP["Total RAP (~)"].value += CHOICE_MAP[bestIndex].rap
    STATS_MAP["Total XP (~)"].value += CHOICE_MAP[bestIndex].xp

    return bestIndex  ; Return the index of the item with the highest priority.
}

; ----------------------------------------------------------------------------------------
; getDetailsFromRarityMap Function
; Description: Matches the color in the tooltip area to the COLOR_RARITY_MAP and retrieves the rarity and its properties.
; Operation:
;   - Defines the tooltip area based on the item coordinates.
;   - Iterates through the COLOR_RARITY_MAP to find a matching color within the tooltip area.
;   - Returns the rarity and its properties if a matching color is found.
; Dependencies:
;   - PixelSearch: Searches a rectangular area of the screen for a pixel of the specified color.
; Parameters:
;   - itemCoordinates: Array containing the coordinates [x, y] of the item.
; Return: A map containing the rarity and its properties if a matching color is found; otherwise, returns an empty string.
; ----------------------------------------------------------------------------------------
getDetailsFromRarityMap(itemCoordinates) {
    ; Define the start coordinates and size for the tooltip area.
    toolTipStart := [itemCoordinates[1] + 10, itemCoordinates[2] + 10]
    toolTipSize := [200, 100]
    toolTipEnd := [toolTipStart[1] + toolTipSize[1], toolTipStart[2] + toolTipSize[2]]

    tolerance := 2  ; Set the color tolerance for the pixel search.

    ; Iterate through the COLOR_RARITY_MAP to find a matching color within the tooltip area.
    for rarity, properties in COLOR_RARITY_MAP {
        if PixelSearch(&foundX, &foundY, 
            toolTipStart[1], toolTipStart[2],  
            toolTipEnd[1], toolTipEnd[2],  
            properties.color, tolerance)  ; Use 'color' property from COLOR_RARITY_MAP
        {
            return {rarity: rarity, properties: properties}  ; Return the rarity and its properties if a matching color is found.
        }
    }
    
    return ""  ; Return an empty string if no matching color is found.
}

; ----------------------------------------------------------------------------------------
; getItemNameWithOcr Function
; Description: Retrieves the item name from the tooltip based on the provided item coordinates.
; Operation:
;   - Defines the tooltip area based on the item coordinates.
;   - Performs OCR on the tooltip area to capture the item name.
;   - Checks for specific items like "Treasure Hunter Potion" and concatenates the second line if needed.
; Dependencies:
;   - getOcrResult: Function that captures and processes OCR results from a specified area.
;   - RegExMatch: Function that matches a string against a regular expression pattern.
; Parameters:
;   - itemCoordinates: Array containing the coordinates [x, y] of the item.
; Return: The item name retrieved from the OCR result.
; ----------------------------------------------------------------------------------------
getItemNameWithOcr(itemCoordinates) {
    toolTipStart := [itemCoordinates[1] + 10, itemCoordinates[2] + 10]  ; Define the start coordinates for the tooltip area.
    toolTipSize := [200, 50]  ; Define the size of the tooltip area.
    ocrResult := getOcrResult(toolTipStart, toolTipSize, 5)  ; Perform OCR on the tooltip area to capture the item name.

    ; Check if the item is "Treasure Hunter Potion" and concatenate the second line if needed.
    if RegExMatch(ocrResult.Lines[1].Text, "i)(?=.*tre)(?=.*hun).*") && ocrResult.Lines.Length > 1 {
        return ocrResult.Lines[1].Text " " ocrResult.Lines[2].Text  ; Concatenate the first and second lines for "Treasure Hunter Potion".
    }

    return ocrResult.Lines[1].Text  ; Return the first line of the OCR result as the item name.
}

; ----------------------------------------------------------------------------------------
; getDetailsFromItemMap Function
; Description: Retrieves item details from ITEM_MAP based on the OCR item name and rarity.
; Operation:
;   - Checks if ITEM_MAP has an entry matching the OCR item name and returns its details if found.
;   - If not found, iterates through ITEM_MAP to match based on regex and rarity.
;   - Returns the item details if a match is found.
; Dependencies:
;   - ITEM_MAP: A map containing item details including regex patterns and rarity.
;   - RegExMatch: Function that matches a string against a regular expression pattern.
; Parameters:
;   - ocrItemName: The name of the item obtained from OCR.
;   - rarity: The rarity of the item.
; Return: A map containing the item name and properties if a match is found; otherwise, returns nothing.
; ----------------------------------------------------------------------------------------
getDetailsFromItemMap(ocrItemName, rarity) {
    ; Match based on the item name.
    if ITEM_MAP.Has(ocrItemName)
        return {name: ocrItemName, properties: ITEM_MAP[ocrItemName]}  ; Return the item details if the name matches.

    ; Match based on the regex and rarity.
    for item, properties in ITEM_MAP {
        if RegExMatch(ocrItemName, properties.regex) && properties.rarity == rarity {
            return {name: item, properties: properties}  ; Return the item details if the regex and rarity match.
        }
    }

    return ""
}

; ----------------------------------------------------------------------------------------
; getRarityFromColour Function
; Description: Determines the rarity of an item based on its color using pixel search.
; Operation:
;   - Defines the area for the tooltip based on the item's coordinates.
;   - Iterates through the COLOR_RARITY_MAP to find a matching color within the tooltip area.
;   - Returns the rarity if a matching color is found, otherwise returns an empty string.
; Dependencies:
;   - PixelSearch: Searches a rectangular area of the screen for a pixel of the specified color.
; Parameters:
;   - itemCoordinates: Array containing the coordinates [x, y] of the item.
; Return: The rarity of the item if a matching color is found; otherwise, an empty string.
; ----------------------------------------------------------------------------------------
getRarityFromColour(itemCoordinates) {
    toolTipStart := [itemCoordinates[1] + 10, itemCoordinates[2] + 10]  ; Define the start coordinates for the tooltip area.
    toolTipSize := [200, 100]  ; Define the size of the tooltip area.
    toolTipEnd := [toolTipStart[1] + toolTipSize[1], toolTipStart[2] + toolTipSize[2]]  ; Calculate the end coordinates for the tooltip area.

    tolerance := 2  ; Set the color tolerance for the pixel search.

    ; Iterate through the COLOR_RARITY_MAP to find a matching color within the tooltip area.
    for rarity, properties in COLOR_RARITY_MAP {
        if PixelSearch(&foundX, &foundY, 
            toolTipStart[1], toolTipStart[2],  
            toolTipEnd[1], toolTipEnd[2],  
            properties.color, tolerance) 
        {
            return rarity  ; Return the rarity if a matching color is found.
        }
    }
    
    return ""  ; Return an empty string if no matching color is found.
}

; ----------------------------------------------------------------------------------------
; getOcrResult Function
; Description: Captures and processes OCR (Optical Character Recognition) results from a specified area of the Roblox window.
; Operation:
;   - Retrieves the top-left coordinates of the Roblox window client area.
;   - Adjusts the OCR start coordinates based on the window position.
;   - Performs OCR on the specified rectangular area.
;   - Returns the OCR result object.
; Dependencies:
;   - WinGetClientPos: Retrieves the position of the client area of the specified window.
;   - OCR.FromRect: Performs OCR on a specified rectangular area.
; Parameters:
;   - ocrStart: Array containing the starting coordinates [x, y] for the OCR area.
;   - ocrSize: Array containing the size [width, height] of the OCR area.
;   - ocrScale: Scale factor for the OCR process.
; Return: OCR result object containing the recognized text and other information.
; ----------------------------------------------------------------------------------------
getOcrResult(ocrStart, ocrSize, ocrScale) {
    WinGetClientPos &windowTopLeftX, &windowTopLeftY, , , "ahk_exe RobloxPlayerBeta.exe"  ; Retrieve the position of the client area of the Roblox window.
    ocrStart := [ocrStart[1] + windowTopLeftX, ocrStart[2] + windowTopLeftY]  ; Adjust the OCR start coordinates based on the window position.

    ; Perform OCR on the specified rectangular area.
    ocrObjectResult := OCR.FromRect(ocrStart[1], ocrStart[2], ocrSize[1], ocrSize[2], , ocrScale)
    
    return ocrObjectResult  ; Return the OCR result object.
}

; ----------------------------------------------------------------------------------------
; activateMouseHover Function
; Description: Simulates a mouse hover by briefly moving the cursor. Useful for triggering hover-sensitive UI elements.
; Operation:
;   - Pauses for 50 ms, moves the cursor by 1 pixel right and down, pauses again, moves back by 1 pixel, and final pause.
; Return: None (affects the mouse's position only)
; ----------------------------------------------------------------------------------------
activateMouseHover() {
    Sleep 50  ; Stabilizes mouse context.
    MouseMove 1, 1,, "R"  ; Move cursor right and down by 1 pixel.
    Sleep 50  ; Allows UI to react.
    MouseMove -1, -1,, "R"  ; Return cursor to original position.
    Sleep 50  ; Ensures UI updates.
}

; ----------------------------------------------------------------------------------------
; writeToActivityLog Function
; Description: Writes a log message to the activity log with a timestamp in ISO 8601 format.
; Operation:
;   - Formats the current date and time as per ISO 8601 standard.
;   - Constructs the log message with a timestamp.
;   - Appends the log message to the log file.
; Dependencies:
;   - LOG_FOLDER: Global variable defining the directory for log files.
;   - LOG_DATE: Global variable defining the current date for log file naming.
; Parameters:
;   - logMessage: The message to be logged.
; Return: None
; ----------------------------------------------------------------------------------------
writeToActivityLog(logMessage) {
    ; Format the current date and time in ISO 8601 format.
    logDateTime := FormatTime(A_Now, "yyyy-MM-ddTHH:mm:ssZ")

    ; Construct the log message by prefixing it with the timestamp and enclosing it in brackets.
    formattedMessage := "[" logDateTime "]   " logMessage "`n"

    ; Define the log file path using the global log directory and current date, appending ".log" to make it a log file.
    logFile := LOG_FOLDER LOG_DATE ".log"

    try {
        ; Append the formatted message to the log file, automatically creating the file if it doesn't exist.
        FileAppend formattedMessage, logFile
    }
}

; ----------------------------------------------------------------------------------------
; writeToErrorLog Function
; Description: Writes an error message to the error log with a timestamp in ISO 8601 format.
; Operation:
;   - Formats the current date and time as per ISO 8601 standard.
;   - Constructs the log message with a timestamp.
;   - Appends the log message to the error log file.
; Dependencies:
;   - LOG_FOLDER: Global variable defining the directory for log files.
; Parameters:
;   - logMessage: The error message to be logged.
; Return: None
; ----------------------------------------------------------------------------------------
writeToErrorLog(logMessage) {
    ; Format the current date and time in ISO 8601 format.
    logDateTime := FormatTime(A_Now, "yyyy-MM-ddTHH:mm:ssZ")

    ; Construct the log message by prefixing it with the timestamp and enclosing it in brackets.
    formattedMessage := "[" logDateTime "]   " logMessage "`n"

    ; Define the log file path using the global log directory and "error.log" as the filename.
    logFile := LOG_FOLDER "error.log"

    try {
        ; Append the formatted message to the log file, automatically creating the file if it doesn't exist.
        FileAppend formattedMessage, logFile
    }
}

; ----------------------------------------------------------------------------------------
; writeToDebugLog Function
; Description: Writes a debug message to the debug log with a timestamp in ISO 8601 format.
; Operation:
;   - Formats the current date and time as per ISO 8601 standard.
;   - Constructs the log message with a timestamp.
;   - Appends the log message to the debug log file.
; Dependencies:
;   - LOG_FOLDER: Global variable defining the directory for log files.
; Parameters:
;   - logMessage: The debug message to be logged.
; Return: None
; ----------------------------------------------------------------------------------------
writeToDebugLog(logMessage) {
    ; Format the current date and time in ISO 8601 format.
    logDateTime := FormatTime(A_Now, "yyyy-MM-ddTHH:mm:ssZ")

    ; Construct the log message by prefixing it with the timestamp and enclosing it in brackets.
    formattedMessage := "[" logDateTime "]   " logMessage "`n"

    ; Define the log file path using the global log directory and "debug.log" as the filename.
    logFile := LOG_FOLDER "debug.log"

    try {
        ; Append the formatted message to the log file, automatically creating the file if it doesn't exist.
        FileAppend formattedMessage, logFile
    }
}


; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; GUI FUNCTIONS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; ----------------------------------------------------------------------------------------
; populateStatsGui Function
; Description: Populates the stats GUI ListView with data from the STATS_MAP.
; Operation:
;   - Clears the existing entries in the ListView.
;   - Iterates through the STATS_MAP and adds each statistic to the ListView.
; Dependencies:
;   - STATS_MAP: A global map containing statistics data.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
populateStatsGui() {
    statsList.Delete()  ; Clear all existing entries in the ListView.
    
    ; Iterate through the STATS_MAP and add each statistic to the ListView.
    for index, properties in STATS_MAP {
        statsList.Add(, properties.order, index, properties.value)  ; Add the statistic to the ListView.
    }
}

; ----------------------------------------------------------------------------------------
; populateMainGui Function
; Description: Populates the main GUI ListView with item details and the best selected item.
; Operation:
;   - Retrieves item names from the CHOICE_MAP based on the provided indices.
;   - Inserts the retrieved item names into the ListView at the specified index.
; Dependencies:
;   - CHOICE_MAP: A global map containing item details.
;   - itemList: A ListView control in the main GUI to be populated.
; Parameters:
;   - index: The index at which to insert the new row in the ListView.
;   - bestIndex: The index of the best selected item in CHOICE_MAP.
; Return: None
; ----------------------------------------------------------------------------------------
populateMainGui(index, bestIndex) {
    ; Retrieve item names from CHOICE_MAP based on the provided indices.
    item1 := CHOICE_MAP[1].itemName
    item2 := CHOICE_MAP[2].itemName
    item3 := CHOICE_MAP[3].itemName
    itemSelected := CHOICE_MAP[bestIndex].itemName

    ; Insert the retrieved item names into the ListView at the specified index.
    itemList.Insert(1, , index, item1, item2, item3, itemSelected)
}

; ----------------------------------------------------------------------------------------
; pauseMacro Function
; Description: Toggles the pause state of the macro.
; Operation:
;   - Sends a keystroke to simulate a pause/unpause command.
;   - Toggles the pause state of the script.
; Dependencies:
;   - Send: Function to simulate keystrokes.
; Parameters:
;   - None
; Return: None; toggles the paused state of the macro.
; ----------------------------------------------------------------------------------------
pauseMacro(*) {
    Pause -1  ; Toggle the pause status of the macro.
}

; ----------------------------------------------------------------------------------------
; exitMacro Function
; Description: Exits the macro application completely.
; Operation:
;   - Terminates the application.
; Dependencies:
;   - ExitApp: Command to exit the application.
; Parameters:
;   - None
; Return: None; closes the application.
; ----------------------------------------------------------------------------------------
exitMacro(*) {
    ExitApp  ; Exit the macro application.
}

; ----------------------------------------------------------------------------------------
; changeToDefaultFont Function
; Description: Copies specific font files to the Roblox font directory to update the default fonts.
; Operation:
;   - Copies the 'FredokaOne-Regular.ttf' font file to the Roblox font path.
;   - Copies the 'SourceSansPro-Bold.ttf' font file to the Roblox font path.
; Parameters:
;   - *: Indicates the function may potentially accept parameters, though not used here.
; Dependencies:
;   - FREDOKA_ONE_REGULAR, SOURCE_SANS_PRO_BOLD: Global variables holding the paths to the font files.
;   - g_robloxFontPath: Global variable holding the path to the Roblox font directory.
;   - FileCopy: Function used to copy files.
; Return: None; modifies the file system by updating font files in Roblox directory.
; ----------------------------------------------------------------------------------------
changeToDefaultFont(*) {
    robloxFontPath := StrReplace(WinGetProcessPath("ahk_exe RobloxPlayerBeta.exe"), "RobloxPlayerBeta.exe", "") "content\fonts\"  ; Path to Roblox fonts directory.
    FileCopy FREDOKA_ONE_REGULAR, robloxFontPath "FredokaOne-Regular.ttf", true  ; Copy Fredoka One font.
}

; ----------------------------------------------------------------------------------------
; openWiki Function
; Description: Opens a help text file in Notepad for user assistance.
; Operation:
;   - Executes Notepad with a specified file path to display help documentation.
; Dependencies:
;   - Run: Function to execute external applications.
; Parameters:
;   - None; uses a global variable for the file path.
; Return: None; opens a text file for user reference.
; ----------------------------------------------------------------------------------------
openWiki(*) {
    Run "https://github.com/waktool/SecretKey/wiki"
}


; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; SETTINGS.INI FUNCTIONS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; ----------------------------------------------------------------------------------------
; getSetting Function
; Description: Retrieves a setting value from an INI file based on a given key.
; Parameters:
;   - Key: The setting key whose value is to be retrieved.
; Operation:
;   - Reads the value associated with the specified key from a designated INI file section.
; Dependencies:
;   - IniRead: Function used to read data from an INI file.
;   - SETTINGS_INI: Global variable specifying the path to the INI file.
; Return: The value of the specified setting key, returned as a string.
; ----------------------------------------------------------------------------------------
getSetting(keyName) {
    return IniRead(SETTINGS_INI, "Settings", keyName)  ; Read and return the setting value from the INI file.
}


; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; INITIALISATION SETTINGS/FUNCTIONS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; ----------------------------------------------------------------------------------------
; completeInitialisationTasks Function
; Description: Performs all initial tasks necessary for the macro's setup, such as updating the tray icon, resizing the Roblox window, defining hotkeys, downloading RAP JSON, updating RAP data, and updating priorities.
; Operation:
;   - Updates the tray icon to indicate that the macro is running.
;   - Resizes the Roblox window to a predefined size.
;   - Defines hotkeys for various macro functions.
;   - Downloads the latest RAP JSON data from a specified URL.
;   - Updates the RAP data based on the downloaded JSON.
;   - Updates the priority of items based on a text file.
; Dependencies:
;   - updateTrayIcon: Updates the tray icon to indicate the macro status.
;   - resizeRobloxWindow: Resizes the Roblox window to a predefined size.
;   - defineHotKeys: Defines hotkeys for various macro functions.
;   - downloadRapJson: Downloads the latest RAP JSON data from a specified URL.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
completeInitialisationTasks() {
    replaceRobloxFonts()  ; Replace the Roblox fonts for better readability.
    updateTrayIcon()  ; Update the tray icon to indicate that the macro is running.
    resizeRobloxWindow()  ; Resize the Roblox window to a predefined size.
    defineHotKeys()  ; Define hotkeys for various macro functions.
    downloadRapJson()  ; Download the latest RAP JSON data from a specified URL.  
}

; ----------------------------------------------------------------------------------------
; replaceRobloxFonts Function
; Description: Replaces default Roblox fonts with the Times New Roman font for consistent text rendering.
; Operation:
;   - Copies the Times New Roman font file to overwrite the 'FredokaOne-Regular.ttf' and 'SourceSansPro-Bold.ttf' files in the Roblox font directory.
; Dependencies:
;   - FileCopy: Function used to copy files.
;   - TIMES_NEW_ROMAN, g_robloxFontPath: Global variables specifying the source font file and the destination font path.
; Return: None; updates the file system by copying font files.
; ----------------------------------------------------------------------------------------
replaceRobloxFonts() {
    robloxFontPath := StrReplace(WinGetProcessPath("ahk_exe RobloxPlayerBeta.exe"), "RobloxPlayerBeta.exe", "") "content\fonts\"  ; Path to Roblox fonts directory.
    FileCopy TIMES_NEW_ROMAN, robloxFontPath "FredokaOne-Regular.ttf", true  ; Replace 'FredokaOne-Regular' with Times New Roman.
}

; ----------------------------------------------------------------------------------------
; updateTrayIcon Function
; Description: Sets a custom icon for the application in the system tray.
; Operation:
;   - Composes the file path for the icon and sets it as the tray icon.
; Dependencies: None.
; Return: None; changes the tray icon appearance.
; ----------------------------------------------------------------------------------------
updateTrayIcon() {
    iconFile := A_WorkingDir . "\Assets\Secret_Key.ico"  ; Set the tray icon file path.
    TraySetIcon iconFile  ; Apply the new tray icon.
}

; ----------------------------------------------------------------------------------------
; defineHotKeys Function
; Description: Sets up hotkeys for controlling macros based on user settings.
; Operation:
;   - Retrieves hotkey settings and binds them to macro control functions.
; Dependencies: getSetting: Retrieves user-configured hotkey preferences.
; Return: None; configures hotkeys for runtime use.
; ----------------------------------------------------------------------------------------
defineHotKeys() {
    HotKey getSetting("pauseMacroKey"), pauseMacro  ; Bind pause macro hotkey.
    HotKey getSetting("exitMacroKey"), exitMacro  ; Bind exit macro hotkey.
}

; ----------------------------------------------------------------------------------------
; downloadRapJson Function
; Description: Downloads the RAP JSON data from the specified URL and saves it to a file.
; Operation:
;   - Uses the Download function to download JSON data from the specified URL.
;   - Saves the downloaded data to a specified file.
; Dependencies:
;   - UrlDownloadToFile: Function that downloads data from a specified URL and saves it to a file.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
downloadRapJson() {
    Download URL_RAP_API, RAP_JSON  ; Download the RAP JSON data from the specified URL and save it to the file specified by RAP_JSON.
}

; ----------------------------------------------------------------------------------------
; updateRap Function
; Description: Updates the RAP values in the ITEM_MAP based on the data from the RAP JSON file.
; Operation:
;   - Loads the JSON data from the specified RAP JSON file.
;   - Iterates through each item in the JSON data and updates the corresponding values in the ITEM_MAP.
;   - Checks for specific criteria such as category and matching id and tn values to perform the update.
;   - Extracts and returns the RAP value for the "Secret Key".
; Dependencies:
;   - loadJsonFromFile: Function that loads JSON data from a file.
; Parameters: None
; Return: secretKeyRap (the RAP value for the "Secret Key")
; ----------------------------------------------------------------------------------------
updateRap() {
    jsonObject := loadJsonFromFile(RAP_JSON)  ; Load the JSON data from the specified RAP JSON file.

    ; Iterate through each item in the JSON data.
    for _, jsonData in jsonObject["data"] {
        ; Iterate through each item in the ITEM_MAP.
        for itemName, itemDetails in ITEM_MAP {
            ; Check if the categories match.
            if (itemDetails.category == jsonData["category"]) {
                ; Check if the tn value is not "NA".
                if itemDetails.tn != "NA" {
                    ; Update the value if both id and tn match.
                    if (itemDetails.id == jsonData["configData"]["id"] && itemDetails.tn == jsonData["configData"]["tn"]) {
                        itemDetails.value := jsonData["value"]
                    }
                } else {
                    ; Update the value if only id matches.
                    if (itemDetails.id == jsonData["configData"]["id"]) {
                        itemDetails.value := jsonData["value"]
                    }
                }
            }
        }

        ; Check if the current item is the "Secret Key" and update the secretKeyRap value.
        if jsonData["configData"]["id"] == "Secret Key"
            secretKeyRap := jsonData["value"]
    }

    return secretKeyRap  ; Return the RAP value for the "Secret Key".
}

; ----------------------------------------------------------------------------------------
; updatePriority Function
; Description: Updates the priority of items in the ITEM_MAP based on the priorities read from a text file.
; Operation:
;   - Reads the priorities from the specified text file.
;   - Iterates through the priority list and updates the corresponding item's priority in ITEM_MAP.
; Dependencies:
;   - readPrioritiesFromFile: Function that reads priorities from a specified text file.
;   - StrReplace: Function that replaces substrings within a string.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
updatePriority() {
    priorityArray := readPrioritiesFromFile(PRIORITY_TXT)  ; Read the priorities from the specified text file.

    ; Iterate through each item in the priority array.
    for index, item in priorityArray {
        strippedContent := StrReplace(item, "`r", "")  ; Remove carriage return characters from the item string.
        strippedContent := StrReplace(strippedContent, "`n", "")  ; Remove newline characters from the item string.
        
        ; Check if the ITEM_MAP contains the stripped item string.
        if ITEM_MAP.Has(strippedContent)
            ITEM_MAP[strippedContent].priority := index  ; Update the priority of the item in ITEM_MAP.
    }
}

; ----------------------------------------------------------------------------------------
; readPrioritiesFromFile Function
; Description: Reads priorities from a specified text file and returns them as an array.
; Operation:
;   - Reads the content of the specified file.
;   - Splits the content by line breaks into an array.
;   - Trims any leading or trailing whitespace from each line.
;   - Pushes non-empty lines into the array.
; Dependencies:
;   - FileRead: Function that reads the content of a specified file.
;   - StrSplit: Function that splits a string into an array based on a delimiter.
;   - Trim: Function that removes leading and trailing whitespace from a string.
; Parameters:
;   - filePath: The path to the text file containing the priorities.
; Return: Array of priorities read from the file.
; ----------------------------------------------------------------------------------------
readPrioritiesFromFile(filePath) {
    array := []  ; Initialize an empty array to store the priorities.
    content := FileRead(filePath)  ; Read the content of the specified file.

    ; Split the file content by line breaks into an array.
    for line in StrSplit(content, "`n") {
        line := Trim(line)  ; Trim any leading or trailing whitespace.
        if (line != "") {  ; Check if the line is not empty.
            array.Push(line)  ; Push the non-empty line into the array.
        }
    }

    return array  ; Return the array of priorities.
}

; ----------------------------------------------------------------------------------------
; loadJsonFromFile Function
; Description: Loads and parses JSON data from a specified file.
; Operation:
;   - Reads the content of the specified JSON file into a string.
;   - Parses the JSON string into a JSON object using the Jxon library.
; Dependencies:
;   - FileRead: Function that reads the content of a specified file.
;   - Jxon_Load: Function from the Jxon library that parses a JSON string into a JSON object.
; Parameters:
;   - filePath: The path to the JSON file to be loaded and parsed.
; Return: JSON object parsed from the file content.
; ----------------------------------------------------------------------------------------
loadJsonFromFile(filePath) {
    jsonString := FileRead(filePath)  ; Read the content of the specified JSON file into a string.
    return Jxon_Load(&jsonString)  ; Parse the JSON string into a JSON object using the Jxon library and return it.
}


; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; ROBLOX CLIENT FUNCTIONS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; ----------------------------------------------------------------------------------------
; resizeRobloxWindow Function
; Description: Resizes the Roblox window to specific dimensions to fix any scaling issues with the Supercomputer.
; Operation:
;   - Activates the Roblox window.
;   - Restores the Roblox window if it is minimized.
;   - Resizes the window twice to ensure any scaling issues are fixed.
; Dependencies:
;   - WinActivate: Activates the specified window.
;   - WinRestore: Restores the specified window if it is minimized.
;   - WinMove: Resizes and moves the specified window.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
resizeRobloxWindow() {
    WinActivate "ahk_exe RobloxPlayerBeta.exe"  ; Activate the Roblox window.
    WinRestore "ahk_exe RobloxPlayerBeta.exe"   ; Restore the Roblox window if it is minimized.
    
    ; Resize the window twice to fix any scaling issues with the Supercomputer.
    WinMove , , A_ScreenWidth, 600, "ahk_exe RobloxPlayerBeta.exe"  ; Resize the window to screen width by 600 pixels height.
    WinMove , , 800, 600, "ahk_exe RobloxPlayerBeta.exe"  ; Resize the window to 800x600 pixels dimensions.
}

; ----------------------------------------------------------------------------------------
; activateRoblox Function
; Description: Activates the Roblox game window. If the window is not found, displays an error message and exits the application.
; Operation:
;   - Tries to activate the Roblox game window.
;   - If the window is not found, catches the error, displays an error message, and exits the application.
;   - Pauses briefly to ensure the window is activated.
; Dependencies:
;   - WinActivate: Function that activates the specified window.
;   - MsgBox: Function that displays a message box.
;   - ExitApp: Function that exits the application.
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
activateRoblox() {
    try {
        WinActivate "ahk_exe RobloxPlayerBeta.exe"  ; Try to activate the Roblox game window.
    } catch {
        MsgBox "Roblox window not found."  ; Display an error message if the window is not found.
        ExitApp  ; Exit the application.
    }
    Sleep 100  ; Pause briefly to ensure the window is activated.
}


; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; PIXEL SEARCHES
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; ----------------------------------------------------------------------------------------
; isSecretKeyNotConsumed Function
; Description: Checks if the secret key has not been consumed by performing a pixel search.
; Operation:
;   - Uses PixelSearch to detect a specific color at a given coordinate.
; Dependencies:
;   - PixelSearch: Searches a rectangular area of the screen for a pixel of the specified color.
; Parameters: None
; Return: Boolean value (true if the specific color is found, indicating the key is not consumed, false otherwise)
; ----------------------------------------------------------------------------------------
isSecretKeyNotConsumed() {
    return PixelSearch(&foundX, &foundY, 448, 428, 448, 428, "0x00FFFF", 2)  ; Search for the specific color at the given coordinate.
}

; ----------------------------------------------------------------------------------------
; isMerchantWindowOpen Function
; Description: Checks if the merchant window is open by searching for a specific pixel color at a given coordinate.
; Operation:
;   - Uses PixelSearch to check for the presence of a specific color at coordinate (52, 101).
; Dependencies:
;   - PixelSearch: Function that searches a rectangular area of the screen for a pixel of the specified color.
; Parameters: None
; Return: Boolean indicating whether the merchant window is open.
; ----------------------------------------------------------------------------------------
isMerchantWindowOpen() {
    return PixelSearch(&foundX, &foundY, 52, 101, 52, 101, "0xDC4000", 2)  ; Search for the specific color at the given coordinate.
}

; ----------------------------------------------------------------------------------------
; isTransitionScreen Function
; Description: Checks if the transition screen is active by searching for a specific pixel color at a given coordinate.
; Operation:
;   - Uses PixelSearch to check for the presence of a specific color at coordinate (604, 63).
; Dependencies:
;   - PixelSearch: Function that searches a rectangular area of the screen for a pixel of the specified color.
; Parameters: None
; Return: Boolean indicating whether the transition screen is active.
; ----------------------------------------------------------------------------------------
isTransitionScreen() {
    return PixelSearch(&foundX, &foundY, 43, 63, 43, 63, "0x070711", 2)  ; Search for the specific color at the given coordinate.
}

; ----------------------------------------------------------------------------------------
; isUseKeyWindowOpen Function
; Description: Checks if the "Use Key" window is open by searching for a specific pixel color at given coordinates.
; Operation:
;   - Uses PixelSearch to check for the presence of a specific color at coordinates (406, 316) and (406, 314).
; Dependencies:
;   - PixelSearch: Function that searches a rectangular area of the screen for a pixel of the specified color.
; Parameters: None
; Return: Boolean indicating whether the "Use Key" window is open.
; ----------------------------------------------------------------------------------------
isUseKeyWindowOpen() {
    return PixelSearch(&foundX, &foundY, 406, 314, 406, 314, "0xC34CE1", 2)  ; Search for the specific color at the given coordinates.
}


; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; AUTO-RECONNECT FUNCTIONS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; ----------------------------------------------------------------------------------------
; checkForDisconnection Function
; Description: Monitors the game to detect if a disconnection has occurred and attempts to reconnect.
; Operation:
;   - Updates the current action status to reflect the connection check.
;   - Determines if a disconnection has occurred.
;   - Initiates a reconnection process if disconnected.
;   - Resets the action status after checking.
; Dependencies:
;   - setCurrentAction, checkForDisconnect, Reconnect: Functions to update UI, check connection, and handle reconnection.
; Return: None; primarily controls game connectivity status.
; ----------------------------------------------------------------------------------------
checkForDisconnection() {
    ;setCurrentAction("Checking Connection")  ; Indicate checking connection status.

    isDisconnected := checkForDisconnect()  ; Check for any disconnection.
    if (isDisconnected == true) {
        reconnectClient()  ; Reconnect if disconnected.
        Reload  ; Reload the script to refresh all settings and start fresh.
    }

    ;setCurrentAction("-")  ; Reset action status.
}

; ----------------------------------------------------------------------------------------
; Reconnect Function
; Description: Handles the reconnection process by attempting to reconnect to a Roblox game, optionally using a private server.
; Operation:
;   - Retrieves the necessary reconnection settings (time and private server code).
;   - Initiates a connection to Roblox using the appropriate URL scheme.
;   - Displays the reconnect progress in the system tray icon.
; Dependencies:
;   - getSetting, setCurrentAction: Functions to retrieve settings and update UI.
; Return: None; attempts to reconnect to the game.
; ----------------------------------------------------------------------------------------
reconnectClient(*) {
    writeToActivityLog("*** RECONNECTING ***")
    reconnectTime := getSetting("ReconnectTimeSeconds")  ; Get the reconnect duration.

    privateServerLinkCode := getSetting("PrivateServerLinkCode")  ; Get the private server code.
    if (privateServerLinkCode == "") {
        try Run "roblox://placeID=8737899170"  ; Default reconnect without private server.
    }
    else {
        try Run "roblox://placeID=8737899170&linkCode=" privateServerLinkCode  ; Reconnect using private server link.
    }

    Loop reconnectTime {
        ;setCurrentAction("Reconnecting " A_Index "/" reconnectTime)  ; Update reconnecting progress.
        Sleep ONE_SECOND  ; Wait for 1 second.
    }
}

; ----------------------------------------------------------------------------------------
; checkForDisconnect Function
; Description: Checks if the Roblox game has been disconnected by searching for specific phrases within a designated window area.
; Operation:
;   - Activates the Roblox window to ensure it is in focus.
;   - Uses OCR to scan a specific window area for text.
;   - Matches the OCR result against known disconnection phrases.
; Dependencies:
;   - activateRoblox: Function to bring the Roblox window into focus.
;   - getOcrResult: Function to perform OCR on a specified area of the screen.
; Parameters: None
; Return: Boolean value indicating if disconnection phrases are detected (true) or not (false).
; ----------------------------------------------------------------------------------------
checkForDisconnect() {
    disconnectedWindowStart := [201, 175]  ; Define the start coordinates for the disconnection window.
    disconnectedWindowSize := [398, 248]   ; Define the size of the disconnection window.

    activateRoblox()  ; Focus the Roblox window.
    
    ; Perform OCR on the specified window area with a scaling factor of 20.
    ocrTextResult := getOcrResult(disconnectedWindowStart, disconnectedWindowSize, 20)
    
    ; Check for disconnection phrases in the OCR result.
    return (regexMatch(ocrTextResult, "Disconnected|Reconnect|Leave"))
}

; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; MOVEMENT FUNCTIONS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; ----------------------------------------------------------------------------------------
; moveToTree Function
; Description: Moves the character to the tree by equipping the hoverboard, moving right,
;              moving forward, and then unequipping the hoverboard.
; Operation:
;   - Equips the hoverboard.
;   - Moves right for a specified duration.
;   - Moves forward for a specified duration.
;   - Unequips the hoverboard.
; Dependencies: 
;   - equipHoverboard: Function that equips the hoverboard and stabilizes it.
;   - moveDirection: Function that moves the character in a specified direction.
;   - unequipHoverboard: Function that unequips the hoverboard.
; Parameters: None.
; Return: None.
; ----------------------------------------------------------------------------------------
moveToTree() {
    Sleep 500  ; Pause briefly before starting the movement.
    
    equipHoverboard("d")  ; Equip the hoverboard and start stabilizing it by moving right.
    moveDirection("d", 260)  ; Move right for 260 milliseconds to position the character.
    
    Sleep 200  ; Brief pause before the next movement.
    
    moveDirection("w", 1300)  ; Move forward for 1300 milliseconds to reach the tree.
    unequipHoverboard()  ; Unequip the hoverboard.
}

; ----------------------------------------------------------------------------------------
; travelToTree Function
; Description: Navigates the character to the tree by traveling to World 1, closing the leaderboard,
;              traveling to Zone 15, and moving to the tree.
; Operation:
;   - Travels to World 1.
;   - Closes the leaderboard.
;   - Travels to Zone 15.
;   - Moves to the tree.
; Dependencies: 
;   - travelToWorld1: Function to travel to World 1.
;   - closeLeaderboard: Function to close the leaderboard.
;   - travelToZone15: Function to travel to Zone 15.
;   - moveToTree: Function to move the character to the tree.
; Parameters: None.
; Return: None.
; ----------------------------------------------------------------------------------------
travelToTree() {
    travelToWorld1()  ; Ensure the character is in World 1.
    closeLeaderboard()  ; Close the leaderboard.
    travelToZone15()  ; Travel to Zone 15.
    moveToTree()  ; Move to the tree.
}

; ----------------------------------------------------------------------------------------
; travelToWorld1 Function
; Description: Teleports the character to World 1 if they are not already there.
; Operation:
;   - Checks the current world.
;   - Teleports to World 1 if not already there.
; Dependencies: 
;   - getWorld: Function that retrieves the current world.
;   - teleportToWorld: Function that teleports the character to a specified world.
; Parameters: None.
; Return: None.
; ----------------------------------------------------------------------------------------
travelToWorld1() {
    if getWorld() != 1
        teleportToWorld(1)  ; Teleport to World 1 if not already there.
}

; ----------------------------------------------------------------------------------------
; travelToZone15 Function
; Description: Teleports the character to Zone 15. If already in Zone 15, teleports to Zone 14 first
;              and then to Zone 15 again to ensure proper positioning.
; Operation:
;   - Attempts to teleport to Zone 15.
;   - If already in Zone 15, teleports to Zone 14 first, then to Zone 15 again.
; Dependencies: 
;   - teleportToZone: Function that teleports the character to a specified zone.
; Parameters: None.
; Return: None.
; ----------------------------------------------------------------------------------------
travelToZone15() {
    Loop {
        alreadyInZone := teleportToZone(15)  ; Attempt to teleport to Zone 15.
        if alreadyInZone
            teleportToZone(14)  ; If already in Zone 15, teleport to Zone 14.
        else
            break  ; Exit the loop if successfully teleported to Zone 15.
    }
}

; ----------------------------------------------------------------------------------------
; moveDirection Function
; Description: Simulates pressing a directional key for a specified duration to move the character in a game.
; Operation:
;   - Sends a key down event for the specified key to initiate movement.
;   - Waits for the specified number of milliseconds to continue the movement.
;   - Sends a key up event to stop the movement.
; Dependencies: None
; Parameters:
;   - key: The directional key to be pressed (e.g., "w", "a", "s", "d").
;   - milliseconds: The duration in milliseconds to hold the key down.
; Return: None
; ----------------------------------------------------------------------------------------
moveDirection(key, milliseconds) {
    Send "{" key " down}"  ; Send the key down event to initiate movement.
    Sleep milliseconds  ; Wait for the specified duration to continue movement.
    Send "{" key " up}"  ; Send the key up event to stop movement.
}

; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; HOVERBOARD FUNCTIONS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; ----------------------------------------------------------------------------------------
; equipHoverboard Function
; Description: Toggles the hoverboard and stabilizes it by moving in the specified direction.
; Operation:
;   - Presses the 'q' key to toggle the hoverboard.
;   - Waits for 2000 milliseconds.
;   - Stabilizes the hoverboard by moving in the specified direction in small increments.
;   - Waits again for 2000 milliseconds for final stabilization.
; Dependencies:
;   - moveDirection: Function that simulates movement in a specified direction.
; Parameters:
;   - direction: The direction in which to move to stabilize the hoverboard.
; Return: None
; ----------------------------------------------------------------------------------------
equipHoverboard(direction) {
    SendEvent "{q}"  ; Simulate pressing the 'q' key to toggle the hoverboard.
    Sleep 2000  ; Wait for 2000 milliseconds to ensure the hoverboard is activated.

    ; Stabilize the hoverboard by moving in the specified direction in small increments.
    Loop 3 {
        moveDirection(direction, 10)  ; Move in the specified direction for 10 milliseconds.
        Sleep 10  ; Brief pause before the next movement.
    }

    Sleep 2000  ; Wait for 2000 milliseconds to allow the hoverboard to stabilize.
}

; ----------------------------------------------------------------------------------------
; unequipHoverboard Function
; Description: Toggles the hoverboard off by simulating a key press.
; Operation:
;   - Presses the 'q' key to toggle the hoverboard off.
; Dependencies: None
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
unequipHoverboard() {
    SendEvent "{q}"  ; Simulate pressing the 'q' key to toggle the hoverboard off.
}


; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; WINDOW FUNCTIONS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; ----------------------------------------------------------------------------------------
; closeLeaderboard Function
; Description: Searches for the leaderboard rank star icon on the screen and closes the leaderboard if found.
; Operation:
;   - Uses PixelSearch to find the leaderboard rank star icon within specified coordinates and color.
;   - If the leaderboard rank star icon is found, sends the Tab key to close the leaderboard.
; Dependencies: None
; Parameters: None
; Return: None; performs the search and send key operations to close the leaderboard.
; ----------------------------------------------------------------------------------------
closeLeaderboard() {
    pixel := MENU_PIXEL["LEADERBOARD_RANK_STAR"]     
    if PixelSearch(&foundX, &foundY,  ; Perform a pixel search.
        pixel["START"][1], pixel["START"][2],  ; Starting coordinates for the search area.
        pixel["END"][1], pixel["END"][2],  ; Ending coordinates for the search area.
        pixel["COLOUR"], pixel["TOLERANCE"])  ; Color and tolerance for the search.    
        SendEvent "{Tab}"  ; Send the Tab key to close the leaderboard.       
}

; ----------------------------------------------------------------------------------------
; closeChatLog Function
; Description: Searches for the chat log icon on the screen and closes the chat log if found.
; Operation:
;   - Uses PixelSearch to find the chat log icon within specified coordinates and color.
;   - If the chat log icon is found, clicks on it to close the chat log.
; Dependencies:
;   - leftClickMouse: Function to simulate mouse click at given coordinates.
; Parameters: None
; Return: None; performs the search and click operations to close the chat log.
; ----------------------------------------------------------------------------------------
closeChatLog() {
    pixel := MENU_PIXEL["LEADERBOARD_RANK_STAR"]     
    if PixelSearch(&foundX, &foundY,  ; Perform a pixel search.
        pixel["START"][1], pixel["START"][2],  ; Starting coordinates for the search area.
        pixel["END"][1], pixel["END"][2],  ; Ending coordinates for the search area.
        pixel["COLOUR"], pixel["TOLERANCE"])  ; Color and tolerance for the search. 
        SendEvent "{Click, " foundX ", " foundY ", 1}"  ; Click on the found coordinates to close the chat log.
}