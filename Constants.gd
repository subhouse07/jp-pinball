extends Node

enum { CHAR_ID_OA, CHAR_ID_CM, CHAR_ID_EXEC }
enum { LUNCH, NETWORK, TRAFFIC, BASEMENT }

const BOARDROOM_DOORS_MAX = 3
const BOARDROOM_VENT_MAX = 1
const CENTERPIECE_MAX = 5
const COMPUTER_MAX = 3
const COPIER_MAX = 3
const FILE_CAB_MAX = 6
const JANITOR_MAX = 3
const AREA_CUBE = "cube"
const AREA_BOARDROOM = "boardroom"
const AREA_LOBBY = "lobby"
const SP_NAME_BRAIN = "SpecialBrain"
const SP_NAME_COPIER = "SpecialCopier"
const SP_NAME_COURIER = "SpecialCourier"
const SP_NAME_FILES = "SpecialFiles"
const SP_NAME_WORK = "SpecialWork"
const SP_NAME_DUNGEON = "SpecialDungeon"
const SP_NAME_BOSS = "SpecialBoss"
const SP_NAME_SEWER = "SpecialSewer"
const SP_NAME_CENTER = "SpecialCenter"
const SP_NAME_NETWORK = "SpecialNetwork"
const SP_NAME_LUNCH = "SpecialLunch"
const SP_NAME_TRAFFIC = "SpecialTraffic"
const LOBBY_TASKS = ["lunch", "networking", "traffic", "basement"]
const LOBBY_TARGET_TASKS = ["lunch", "networking"]
const LOBBY_TARGET_TASK_THRESHOLDS = [8, 4]
const POINTS = {
	"Car": 10,
	"OfficeAdmin": 50,
	"LobbyDesk": 10,
	"AllLobbyDesks": 100,
	"CopyWorker": 25,
	"Copier": 25,
	"CopierActive": 100,
	"Lift": 50,
	"CubeMates": 50,
	"FileCabinets": 100,
	"SpecialEntrance": 500,
	"Brainstorm": 100,
	"CourierCapture": 150,
	"Courier": 100,
	"CourierRelease": 100,
	"LobbyWorker": 25,
	"LobbyVisitor": 25,
	"Janitor": 25,
	"JanitorMove": 100,
	"BoardRoomDoors": 50,
	"BoardRoomOpen": 250,
	"BoardRoomVent": 250,
	"SublvlEnter": 150,
	"ElevatorOpen": 100,
	"Elevator": 150,
	"LobbyBumper": 25,
	"CubicleBumper": 50,
	"WaterCooler": 50,
	"WorkComputer": 50,
	"DoorManKicker": 150,
	"UpperTrapDoor": 250,
	"LowerTrapDoor": 150,
	"LeftCubeMate": 200,
	"RightCubeMate": 200,
	"OADoor": 50,
	"SpecialTestSuccess": 300,
	"TimeClockDoor": 50
}
