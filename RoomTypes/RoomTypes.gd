extends Node

const EdgeBookshelfPlacement = preload("res://Furniture/Bookshelf/EdgeBookshelfPlacement.gd")
const EdgeLongBookshelfPlacement = preload("res://Furniture/LongBookshelf/EdgeLongBookshelfPlacement.gd")
const EdgeTelevisionPlacement = preload("res://Furniture/Television/EdgeTelevisionPlacement.gd")
const EdgeVacuousFurniturePlacement = preload("res://Furniture/EdgeVacuousFurniturePlacement.gd")
const EdgeLaundryMachinePlacement = preload("res://Furniture/LaundryMachine/EdgeLaundryMachinePlacement.gd")
const EdgeDryerPlacement = preload("res://Furniture/Dryer/EdgeDryerPlacement.gd")
const EdgeSofaPlacement = preload("res://Furniture/Sofa/EdgeSofaPlacement.gd")
const EdgeReclinerPlacement = preload("res://Furniture/Recliner/EdgeReclinerPlacement.gd")
const EdgeDiningChairPlacement = preload("res://Furniture/DiningChair/EdgeDiningChairPlacement.gd")
const EdgeOfficeChairPlacement = preload("res://Furniture/OfficeChair/EdgeOfficeChairPlacement.gd")
const EdgeToiletPlacement = preload("res://Furniture/Toilet/EdgeToiletPlacement.gd")
const EdgeLongCabinetPlacement = preload("res://Furniture/LongCabinet/EdgeLongCabinetPlacement.gd")
const EdgeCabinetPlacement = preload("res://Furniture/Cabinet/EdgeCabinetPlacement.gd")
const EdgeDresserPlacement = preload("res://Furniture/Dresser/EdgeDresserPlacement.gd")
const EdgeKitchenCounterPlacement = preload("res://Furniture/KitchenCounter/EdgeKitchenCounterPlacement.gd")
const EdgeKitchenSinkPlacement = preload("res://Furniture/KitchenSink/EdgeKitchenSinkPlacement.gd")
const EdgeWasherDryerPlacement = preload("res://Furniture/LaundryMachine/EdgeWasherDryerPlacement.gd")
const EdgeBathroomCounterPlacement = preload("res://Furniture/BathroomCounter/EdgeBathroomCounterPlacement.gd")
const EdgeBathroomSinkPlacement = preload("res://Furniture/BathroomSink/EdgeBathroomSinkPlacement.gd")
const EdgeCoffeeTablePlacement = preload("res://Furniture/CoffeeTable/EdgeCoffeeTablePlacement.gd")
const EdgeFloorLampPlacement = preload("res://Furniture/FloorLamp/EdgeFloorLampPlacement.gd")
const EdgeDeskLampPlacement = preload("res://Furniture/DeskLamp/EdgeDeskLampPlacement.gd")
const EdgeTorchPlacement = preload("res://Furniture/Torch/EdgeTorchPlacement.gd")
const EdgeBenchPlacement = preload("res://Furniture/Bench/EdgeBenchPlacement.gd")
const EdgeCardboardBoxPlacement = preload("res://Furniture/CardboardBox/EdgeCardboardBoxPlacement.gd")
const EdgeWardrobePlacement = preload("res://Furniture/Wardrobe/EdgeWardrobePlacement.gd")
const EdgeClothesRackPlacement = preload("res://Furniture/ClothesRack/EdgeClothesRackPlacement.gd")
const EdgeWorkbenchPlacement = preload("res://Furniture/Workbench/EdgeWorkbenchPlacement.gd")

const TwinBedPlacement = preload("res://Furniture/TwinBed/TwinBedPlacement.gd")
const KingBedPlacement = preload("res://Furniture/KingBed/KingBedPlacement.gd")
const ShowerPlacement = preload("res://Furniture/Shower/ShowerPlacement.gd")
const BathtubPlacement = preload("res://Furniture/Bathtub/BathtubPlacement.gd")
const ToiletPlacement = preload("res://Furniture/Toilet/ToiletPlacement.gd")
const BathroomSinkPlacement = preload("res://Furniture/BathroomSink/BathroomSinkPlacement.gd")
const MirrorPlacement = preload("res://Furniture/Mirror/MirrorPlacement.gd")

const Study = preload("res://RoomTypes/Study.gd")
const SittingRoom = preload("res://RoomTypes/SittingRoom.gd")
const Washroom = preload("res://RoomTypes/Washroom.gd")
const StorageRoom = preload("res://RoomTypes/StorageRoom.gd")
const WardrobeRoom = preload("res://RoomTypes/WardrobeRoom.gd")
const Garage = preload("res://RoomTypes/Garage.gd")

const UniformDistr = SpecialPlacement.UniformDistr
const WeightedDistr = SpecialPlacement.WeightedDistr

enum Tile {
    EmptyTile = 0, DebugFloor, DebugWall, TileFloor1, TileFloor2, LightGrayCarpet, GrayCarpet, DarkGrayCarpet, TileFloor3, WoodFloor1,
    WoodFloor2, WoodFloor3, ConcreteFloor, StripedWall1, StripedWall2, DiamondWall, CircleWall, GradientWall1, GradientWall2, RockyWall,
    PipeWall, RedRegalWall, OrangeRegalWall, ColumnedWall1, ColumnedWall2, ColumnedWall3
}

enum RT {
    Hallway = 0, Bedroom, MasterBedroom, Bathroom, Washroom, WardrobeRoom,
    Closet, LongCloset, Theater, Foyer, Study, SittingRoom,
    LaundryRoom, Kitchen, StorageRoom, DiningRoom, DiningHall,
    Garage
}

var walls: Array = [Tile.DebugWall, Tile.StripedWall1, Tile.StripedWall2, Tile.DiamondWall, Tile.CircleWall,
                    Tile.GradientWall1, Tile.GradientWall2, Tile.RockyWall, Tile.PipeWall, Tile.RedRegalWall,
                    Tile.OrangeRegalWall, Tile.ColumnedWall1, Tile.ColumnedWall2, Tile.ColumnedWall3]

var _roomtypes: Dictionary = {
    Vector2(1, 1): [RT.Washroom, RT.Closet, RT.LaundryRoom, RT.StorageRoom],
    Vector2(1, 2): [RT.Washroom, RT.Closet, RT.LaundryRoom, RT.StorageRoom],
    Vector2(1, 3): [RT.Closet, RT.LongCloset, RT.LaundryRoom, RT.StorageRoom],
    Vector2(1, 4): [RT.LongCloset, RT.LaundryRoom, RT.StorageRoom],
    Vector2(2, 2): [RT.Bedroom, RT.Washroom, RT.Bathroom, RT.WardrobeRoom, RT.Study,
                    RT.SittingRoom, RT.LaundryRoom, RT.Kitchen, RT.StorageRoom, RT.DiningRoom,
                    RT.Garage],
    Vector2(2, 3): [RT.Bedroom, RT.Bathroom, RT.WardrobeRoom, RT.Study, RT.SittingRoom,
                    RT.Kitchen, RT.StorageRoom, RT.DiningRoom, RT.DiningHall, RT.Garage],
    Vector2(2, 4): [RT.Bathroom, RT.WardrobeRoom, RT.Theater, RT.SittingRoom, RT.StorageRoom,
                    RT.DiningHall],
    Vector2(3, 3): [RT.Bedroom, RT.MasterBedroom, RT.WardrobeRoom, RT.Foyer, RT.Study, RT.SittingRoom,
                    RT.Kitchen, RT.DiningRoom, RT.DiningHall, RT.Garage],
    Vector2(3, 4): [RT.MasterBedroom, RT.Theater, RT.Foyer, RT.SittingRoom, RT.DiningHall],
    Vector2(4, 4): [RT.MasterBedroom, RT.Theater, RT.Foyer, RT.DiningHall]
}

var _config: Dictionary = {
    RT.Hallway: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.ColumnedWall1, Tile.ColumnedWall2, Tile.ColumnedWall3],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 50 },
                {"placement": EdgeLongBookshelfPlacement.new(), "chance": 10 },
                {"placement": EdgeBookshelfPlacement.new(), "chance": 10 },
                {"placement": EdgeFloorLampPlacement.new(), "chance": 20 },
                {"placement": EdgeDeskLampPlacement.new(), "chance": 20 },
                {"placement": EdgeTorchPlacement.new(), "chance": 20 }
            ])
        ],
        "special": UniformDistr.new([[]])
    },
    RT.Bedroom: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.ColumnedWall1, Tile.ColumnedWall2, Tile.ColumnedWall3],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 20 },
                {"placement": EdgeLongBookshelfPlacement.new(), "chance": 10 },
                {"placement": EdgeBookshelfPlacement.new(), "chance": 10 },
                {"placement": EdgeTelevisionPlacement.new(), "chance": 10 },
                {"placement": EdgeSofaPlacement.new(), "chance": 20 },
                {"placement": EdgeReclinerPlacement.new(), "chance": 30 },
                {"placement": EdgeOfficeChairPlacement.new(), "chance": 10 },
                {"placement": EdgeCabinetPlacement.new(), "chance": 20 },
                {"placement": EdgeLongCabinetPlacement.new(), "chance": 20 },
                {"placement": EdgeDresserPlacement.new(), "chance": 20 },
                {"placement": EdgeCoffeeTablePlacement.new(), "chance": 10 },
                {"placement": EdgeFloorLampPlacement.new(), "chance": 15 },
                {"placement": EdgeDeskLampPlacement.new(), "chance": 15 },
                {"placement": EdgeTorchPlacement.new(), "chance": 15 },
                {"placement": EdgeBenchPlacement.new(), "chance": 10 },
                {"placement": EdgeWardrobePlacement.new(), "chance": 20 },
                {"placement": EdgeClothesRackPlacement.new(), "chance": 5 }
            ])
        ],
        "special": UniformDistr.new([
            [TwinBedPlacement.new(), TwinBedPlacement.new()],
            [TwinBedPlacement.new()],
            [KingBedPlacement.new()],
            [TwinBedPlacement.new(), TwinBedPlacement.new(), MirrorPlacement.new()],
            [TwinBedPlacement.new(), MirrorPlacement.new()],
            [KingBedPlacement.new(), MirrorPlacement.new()]
        ])
    },
    RT.MasterBedroom: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.RedRegalWall, Tile.OrangeRegalWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 20 },
                {"placement": EdgeLongBookshelfPlacement.new(), "chance": 15 },
                {"placement": EdgeBookshelfPlacement.new(), "chance": 10 },
                {"placement": EdgeTelevisionPlacement.new(), "chance": 10 },
                {"placement": EdgeSofaPlacement.new(), "chance": 30 },
                {"placement": EdgeReclinerPlacement.new(), "chance": 30 },
                {"placement": EdgeOfficeChairPlacement.new(), "chance": 5 },
                {"placement": EdgeCabinetPlacement.new(), "chance": 10 },
                {"placement": EdgeLongCabinetPlacement.new(), "chance": 20 },
                {"placement": EdgeDresserPlacement.new(), "chance": 20 },
                {"placement": EdgeCoffeeTablePlacement.new(), "chance": 10 },
                {"placement": EdgeFloorLampPlacement.new(), "chance": 20 },
                {"placement": EdgeDeskLampPlacement.new(), "chance": 30 },
                {"placement": EdgeTorchPlacement.new(), "chance": 20 },
                {"placement": EdgeBenchPlacement.new(), "chance": 10 },
                {"placement": EdgeWardrobePlacement.new(), "chance": 15 },
                {"placement": EdgeClothesRackPlacement.new(), "chance": 5 }
            ])
        ],
        "special": UniformDistr.new([
            [TwinBedPlacement.new(), TwinBedPlacement.new()],
            [KingBedPlacement.new(), TwinBedPlacement.new()],
            [KingBedPlacement.new()],
            [TwinBedPlacement.new(), TwinBedPlacement.new(), MirrorPlacement.new()],
            [KingBedPlacement.new(), TwinBedPlacement.new(), MirrorPlacement.new()],
            [KingBedPlacement.new(), MirrorPlacement.new()]
        ])
    },
    RT.Bathroom: {
        "floors": [Tile.TileFloor1, Tile.TileFloor3],
        "walls": [Tile.DiamondWall, Tile.CircleWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 100 },
                {"placement": EdgeToiletPlacement.new(), "chance": 5 },
                {"placement": EdgeBathroomCounterPlacement.new(), "chance": 10 },
                {"placement": EdgeBathroomSinkPlacement.new(), "chance": 5 }
            ])
        ],
        "special": UniformDistr.new([
            [BathtubPlacement.new(), MirrorPlacement.new()],
            [ShowerPlacement.new(), MirrorPlacement.new()]
        ])
    },
    RT.Washroom: {
        "floors": [Tile.TileFloor1, Tile.TileFloor3],
        "walls": [Tile.DiamondWall, Tile.CircleWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 50 },
                {"placement": EdgeToiletPlacement.new(), "chance": 5 },
                {"placement": EdgeBathroomCounterPlacement.new(), "chance": 10 },
                {"placement": EdgeBathroomSinkPlacement.new(), "chance": 10 }
            ])
        ],
        "special": UniformDistr.new([
            [Washroom.CentralBar.new(), ToiletPlacement.new(), BathroomSinkPlacement.new(), MirrorPlacement.new()],
            [Washroom.CentralBar.new(), ToiletPlacement.new(), BathroomSinkPlacement.new(), ShowerPlacement.new(), MirrorPlacement.new()]
        ])
    },
    RT.WardrobeRoom: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.ColumnedWall1, Tile.ColumnedWall2, Tile.ColumnedWall3],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 20 },
                {"placement": EdgeSofaPlacement.new(), "chance": 10 },
                {"placement": EdgeReclinerPlacement.new(), "chance": 10 },
                {"placement": EdgeDiningChairPlacement.new(), "chance": 20 },
                {"placement": EdgeCabinetPlacement.new(), "chance": 40 },
                {"placement": EdgeLongCabinetPlacement.new(), "chance": 40 },
                {"placement": EdgeDresserPlacement.new(), "chance": 40 },
                {"placement": EdgeCoffeeTablePlacement.new(), "chance": 10 },
                {"placement": EdgeFloorLampPlacement.new(), "chance": 20 },
                {"placement": EdgeDeskLampPlacement.new(), "chance": 20 },
                {"placement": EdgeBenchPlacement.new(), "chance": 30 },
                {"placement": EdgeCardboardBoxPlacement.new(), "chance": 5 },
                {"placement": EdgeWardrobePlacement.new(), "chance": 40 },
                {"placement": EdgeClothesRackPlacement.new(), "chance": 30 }
            ])
        ],
        "special": UniformDistr.new([
            [WardrobeRoom.HorizontalRows.new(), MirrorPlacement.new()],
            [WardrobeRoom.HorizontalRows.new(), MirrorPlacement.new(), MirrorPlacement.new()],
            [WardrobeRoom.VerticalRows.new(), MirrorPlacement.new()],
            [WardrobeRoom.VerticalRows.new(), MirrorPlacement.new(), MirrorPlacement.new()],
        ])
    },
    RT.Closet: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.GradientWall1, Tile.GradientWall2, Tile.PipeWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 5 },
                {"placement": EdgeLongBookshelfPlacement.new(), "chance": 5 },
                {"placement": EdgeBookshelfPlacement.new(), "chance": 5 },
                {"placement": EdgeDiningChairPlacement.new(), "chance": 10 },
                {"placement": EdgeCabinetPlacement.new(), "chance": 20 },
                {"placement": EdgeLongCabinetPlacement.new(), "chance": 20 },
                {"placement": EdgeDresserPlacement.new(), "chance": 20 },
                {"placement": EdgeFloorLampPlacement.new(), "chance": 5 },
                {"placement": EdgeDeskLampPlacement.new(), "chance": 5 },
                {"placement": EdgeTorchPlacement.new(), "chance": 5 },
                {"placement": EdgeBenchPlacement.new(), "chance": 10 },
                {"placement": EdgeCardboardBoxPlacement.new(), "chance": 10 },
                {"placement": EdgeWardrobePlacement.new(), "chance": 20 },
                {"placement": EdgeClothesRackPlacement.new(), "chance": 20 }
            ])
        ],
        "special": UniformDistr.new([[]])
    },
    RT.LongCloset: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.GradientWall1, Tile.GradientWall2, Tile.PipeWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 5 },
                {"placement": EdgeLongBookshelfPlacement.new(), "chance": 5 },
                {"placement": EdgeBookshelfPlacement.new(), "chance": 5 },
                {"placement": EdgeDiningChairPlacement.new(), "chance": 10 },
                {"placement": EdgeCabinetPlacement.new(), "chance": 30 },
                {"placement": EdgeLongCabinetPlacement.new(), "chance": 30 },
                {"placement": EdgeDresserPlacement.new(), "chance": 30 },
                {"placement": EdgeFloorLampPlacement.new(), "chance": 10 },
                {"placement": EdgeDeskLampPlacement.new(), "chance": 10 },
                {"placement": EdgeTorchPlacement.new(), "chance": 5 },
                {"placement": EdgeBenchPlacement.new(), "chance": 10 },
                {"placement": EdgeCardboardBoxPlacement.new(), "chance": 10 },
                {"placement": EdgeWardrobePlacement.new(), "chance": 20 },
                {"placement": EdgeClothesRackPlacement.new(), "chance": 20 }
            ])
        ],
        "special": UniformDistr.new([[]])
    },
    RT.Theater: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.RedRegalWall, Tile.OrangeRegalWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 30 },
                {"placement": EdgeLongBookshelfPlacement.new(), "chance": 20 },
                {"placement": EdgeBookshelfPlacement.new(), "chance": 20 },
                {"placement": EdgeTelevisionPlacement.new(), "chance": 15 },
                {"placement": EdgeSofaPlacement.new(), "chance": 40 },
                {"placement": EdgeReclinerPlacement.new(), "chance": 40 },
                {"placement": EdgeCoffeeTablePlacement.new(), "chance": 10 },
                {"placement": EdgeFloorLampPlacement.new(), "chance": 20 },
                {"placement": EdgeDeskLampPlacement.new(), "chance": 15 },
                {"placement": EdgeTorchPlacement.new(), "chance": 10 }
            ])
        ],
        "special": UniformDistr.new([[]])
    },
    RT.Foyer: {
        "floors": [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.RedRegalWall, Tile.OrangeRegalWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 40 },
                {"placement": EdgeLongBookshelfPlacement.new(), "chance": 20 },
                {"placement": EdgeBookshelfPlacement.new(), "chance": 20 },
                {"placement": EdgeTelevisionPlacement.new(), "chance": 20 },
                {"placement": EdgeSofaPlacement.new(), "chance": 15 },
                {"placement": EdgeReclinerPlacement.new(), "chance": 15 },
                {"placement": EdgeCoffeeTablePlacement.new(), "chance": 20 },
                {"placement": EdgeFloorLampPlacement.new(), "chance": 10 },
                {"placement": EdgeDeskLampPlacement.new(), "chance": 10 },
                {"placement": EdgeTorchPlacement.new(), "chance": 20 }
            ])
        ],
        "special": UniformDistr.new([[]])
    },
    RT.Study: {
        "floors": [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.ColumnedWall1, Tile.ColumnedWall2, Tile.ColumnedWall3],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 10 },
                {"placement": EdgeLongBookshelfPlacement.new(), "chance": 50 },
                {"placement": EdgeBookshelfPlacement.new(), "chance": 50 },
                {"placement": EdgeTelevisionPlacement.new(), "chance": 10 },
                {"placement": EdgeSofaPlacement.new(), "chance": 10 },
                {"placement": EdgeReclinerPlacement.new(), "chance": 25 },
                {"placement": EdgeDiningChairPlacement.new(), "chance": 20 },
                {"placement": EdgeOfficeChairPlacement.new(), "chance": 10 },
                {"placement": EdgeCabinetPlacement.new(), "chance": 15 },
                {"placement": EdgeLongCabinetPlacement.new(), "chance": 15 },
                {"placement": EdgeDresserPlacement.new(), "chance": 5 },
                {"placement": EdgeCoffeeTablePlacement.new(), "chance": 10 },
                {"placement": EdgeFloorLampPlacement.new(), "chance": 15 },
                {"placement": EdgeDeskLampPlacement.new(), "chance": 20 },
                {"placement": EdgeTorchPlacement.new(), "chance": 20 },
                {"placement": EdgeWardrobePlacement.new(), "chance": 5 }
            ])
        ],
        "special": WeightedDistr.new([
            { "result": [Study.HorizontalRows.new()], "weight": 10 },
            { "result": [Study.VerticalRows.new()], "weight": 10 },
            { "result": [Study.Labyrinth.new()], "weight": 3 },
        ])
    },
    RT.SittingRoom: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 10 },
                {"placement": EdgeLongBookshelfPlacement.new(), "chance": 20 },
                {"placement": EdgeBookshelfPlacement.new(), "chance": 10 },
                {"placement": EdgeTelevisionPlacement.new(), "chance": 5 },
                {"placement": EdgeSofaPlacement.new(), "chance": 50 },
                {"placement": EdgeReclinerPlacement.new(), "chance": 50 },
                {"placement": EdgeDiningChairPlacement.new(), "chance": 10 },
                {"placement": EdgeOfficeChairPlacement.new(), "chance": 10 },
                {"placement": EdgeCabinetPlacement.new(), "chance": 10 },
                {"placement": EdgeLongCabinetPlacement.new(), "chance": 20 },
                {"placement": EdgeDresserPlacement.new(), "chance": 15 },
                {"placement": EdgeCoffeeTablePlacement.new(), "chance": 15 },
                {"placement": EdgeFloorLampPlacement.new(), "chance": 20 },
                {"placement": EdgeDeskLampPlacement.new(), "chance": 20 },
                {"placement": EdgeTorchPlacement.new(), "chance": 20 },
                {"placement": EdgeWardrobePlacement.new(), "chance": 5 }
            ])
        ],
        "special": UniformDistr.new([
            [SittingRoom.InnerCircle.new()],
        ])
    },
    RT.LaundryRoom: {
        "floors": [Tile.TileFloor1, Tile.TileFloor3, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3, Tile.ConcreteFloor],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.GradientWall1, Tile.GradientWall2, Tile.RockyWall, Tile.PipeWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 20 },
                {"placement": EdgeLaundryMachinePlacement.new(), "chance": 5 },
                {"placement": EdgeDryerPlacement.new(), "chance": 5 },
                {"placement": EdgeWasherDryerPlacement.new(), "chance": 30 },
                {"placement": EdgeCabinetPlacement.new(), "chance": 10 },
                {"placement": EdgeLongCabinetPlacement.new(), "chance": 10 },
                {"placement": EdgeDresserPlacement.new(), "chance": 10 },
                {"placement": EdgeBenchPlacement.new(), "chance": 10 },
                {"placement": EdgeCardboardBoxPlacement.new(), "chance": 5 },
                {"placement": EdgeWardrobePlacement.new(), "chance": 10 },
                {"placement": EdgeClothesRackPlacement.new(), "chance": 10 },
                {"placement": EdgeWorkbenchPlacement.new(), "chance": 10 }
            ])
        ],
        "special": UniformDistr.new([[]])
    },
    RT.Kitchen: {
        "floors": [Tile.TileFloor1, Tile.TileFloor3],
        "walls": [Tile.DiamondWall, Tile.CircleWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 50 },
                {"placement": EdgeKitchenCounterPlacement.new(), "chance": 10 },
                {"placement": EdgeKitchenSinkPlacement.new(), "chance": 10 }
            ])
        ],
        "special": UniformDistr.new([[]])
    },
    RT.StorageRoom: {
        "floors": [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.GradientWall1, Tile.GradientWall2, Tile.RockyWall, Tile.PipeWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 10 },
                {"placement": EdgeLongBookshelfPlacement.new(), "chance": 10 },
                {"placement": EdgeBookshelfPlacement.new(), "chance": 10 },
                {"placement": EdgeLaundryMachinePlacement.new(), "chance": 10 },
                {"placement": EdgeDryerPlacement.new(), "chance": 10 },
                {"placement": EdgeSofaPlacement.new(), "chance": 10 },
                {"placement": EdgeReclinerPlacement.new(), "chance": 10 },
                {"placement": EdgeDiningChairPlacement.new(), "chance": 10 },
                {"placement": EdgeOfficeChairPlacement.new(), "chance": 10 },
                {"placement": EdgeCabinetPlacement.new(), "chance": 10 },
                {"placement": EdgeLongCabinetPlacement.new(), "chance": 10 },
                {"placement": EdgeDresserPlacement.new(), "chance": 10 },
                {"placement": EdgeFloorLampPlacement.new(), "chance": 10 },
                {"placement": EdgeDeskLampPlacement.new(), "chance": 5 },
                {"placement": EdgeBenchPlacement.new(), "chance": 10 },
                {"placement": EdgeCardboardBoxPlacement.new(), "chance": 15 },
                {"placement": EdgeWardrobePlacement.new(), "chance": 10 },
                {"placement": EdgeClothesRackPlacement.new(), "chance": 10 },
                {"placement": EdgeWorkbenchPlacement.new(), "chance": 10 }
            ])
        ],
        "special": UniformDistr.new([
            [StorageRoom.FullRoomRandomStorage.new()]
        ])
    },
    RT.DiningRoom: {
        "floors": [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.DiamondWall, Tile.CircleWall, Tile.RedRegalWall, Tile.OrangeRegalWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 60 },
                {"placement": EdgeDiningChairPlacement.new(), "chance": 10 },
                {"placement": EdgeTorchPlacement.new(), "chance": 30 }
            ])
        ],
        "special": UniformDistr.new([[]])
    },
    RT.DiningHall: {
        "floors": [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.DiamondWall, Tile.CircleWall, Tile.RedRegalWall, Tile.OrangeRegalWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 50 },
                {"placement": EdgeDiningChairPlacement.new(), "chance": 10 },
                {"placement": EdgeTorchPlacement.new(), "chance": 40 }
            ])
        ],
        "special": UniformDistr.new([[]])
    },
    RT.Garage: {
        "floors": [Tile.ConcreteFloor],
        "walls": [Tile.GradientWall1, Tile.GradientWall2, Tile.RockyWall, Tile.PipeWall],
        "edges": [
            EdgePlacementManager.new([
                {"placement": EdgeVacuousFurniturePlacement.new(), "chance": 10 },
                {"placement": EdgeLongBookshelfPlacement.new(), "chance": 10 },
                {"placement": EdgeBookshelfPlacement.new(), "chance": 10 },
                {"placement": EdgeTelevisionPlacement.new(), "chance": 10 },
                {"placement": EdgeLaundryMachinePlacement.new(), "chance": 5 },
                {"placement": EdgeDryerPlacement.new(), "chance": 5 },
                {"placement": EdgeWasherDryerPlacement.new(), "chance": 30 },
                {"placement": EdgeDiningChairPlacement.new(), "chance": 20 },
                {"placement": EdgeCardboardBoxPlacement.new(), "chance": 15 },
                {"placement": EdgeWorkbenchPlacement.new(), "chance": 20 }
            ])
        ],
        "special": UniformDistr.new([
            [Garage.GarageRandomStorage.new(4, 4)]
        ])
    }
}

func decide_room_type(dims: Vector2) -> int:
    if dims.x > dims.y:
        dims = Vector2(dims.y, dims.x)
    var arr = _roomtypes[dims]
    return arr[randi() % len(arr)]

func decide_floor_type(rtype: int) -> int:
    var arr = _config[rtype]["floors"]
    return arr[randi() % len(arr)]

func decide_wall_type(rtype: int) -> int:
    var arr = _config[rtype]["walls"]
    return arr[randi() % len(arr)]

func decide_edge_manager(rtype: int) -> EdgePlacementManager:
    var arr = _config[rtype]["edges"]
    return arr[randi() % len(arr)]

func decide_special_manager(rtype: int) -> Array:
    var arr = _config[rtype]["special"]
    return arr.determine_placements()

var _tmp = null

func get_edge_manager(rtype: int) -> EdgePlacementManager:
    # DEBUG CODE (Just returns a constant right now that doesn't depend on the room type)
    if _tmp == null:
        var vac = EdgeVacuousFurniturePlacement.new()
        var bks = EdgeBookshelfPlacement.new()
        var lbk = EdgeLongBookshelfPlacement.new()
        var tlv = EdgeTelevisionPlacement.new()
        var lau = EdgeLaundryMachinePlacement.new()
        var dry = EdgeDryerPlacement.new()
        var sof = EdgeSofaPlacement.new()
        var rec = EdgeReclinerPlacement.new()
        var dnc = EdgeDiningChairPlacement.new()
        var ofc = EdgeOfficeChairPlacement.new()
        var toi = EdgeToiletPlacement.new()
        var dre = EdgeDresserPlacement.new()
        var lca = EdgeLongCabinetPlacement.new()
        var cab = EdgeCabinetPlacement.new()
        var kco = EdgeKitchenCounterPlacement.new()
        var ksi = EdgeKitchenSinkPlacement.new()
        _tmp = EdgePlacementManager.new([{ "placement": bks, "chance": 10 },
                                         { "placement": lbk, "chance": 20 },
                                         { "placement": lau, "chance": 10 },
                                         { "placement": dry, "chance": 10 },
                                         { "placement": tlv, "chance": 20 },
                                         { "placement": sof, "chance": 10 },
                                         { "placement": rec, "chance": 10 },
                                         { "placement": dnc, "chance": 10 },
                                         { "placement": ofc, "chance": 10 },
                                         { "placement": toi, "chance": 10 },
                                         { "placement": dre, "chance": 15 },
                                         { "placement": lca, "chance": 15 },
                                         { "placement": cab, "chance": 15 },
                                         { "placement": kco, "chance": 15 },
                                         { "placement": ksi, "chance": 15 }])
    return _tmp

func _ready():
    pass
