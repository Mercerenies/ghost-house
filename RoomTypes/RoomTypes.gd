extends Node

enum Tile {
    EmptyTile = 0, DebugFloor, DebugWall, TileFloor1, TileFloor2, LightGrayCarpet, GrayCarpet, DarkGrayCarpet, TileFloor3, WoodFloor1,
    WoodFloor2, WoodFloor3, ConcreteFloor, StripedWall1, StripedWall2, DiamondWall, CircleWall, GradientWall1, GradientWall2, RockyWall,
    PipeWall
}

enum RT {
    Hallway = 0, Bedroom, MasterBedroom, Bathroom, Washroom, WardrobeRoom,
    Closet, LongCloset, Theater, Foyer, Study, SittingRoom,
    LaundryRoom, Kitchen, StorageRoom, DiningRoom, DiningHall,
    Garage
}

var walls: Array = [Tile.DebugWall, Tile.StripedWall1, Tile.StripedWall2, Tile.DiamondWall, Tile.CircleWall,
                    Tile.GradientWall1, Tile.GradientWall2, Tile.RockyWall, Tile.PipeWall]

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

var _floortypes: Dictionary = {
    RT.Hallway: [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.Bedroom: [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.MasterBedroom: [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.Bathroom: [Tile.TileFloor1, Tile.TileFloor3],
    RT.Washroom: [Tile.TileFloor1, Tile.TileFloor3],
    RT.WardrobeRoom: [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.Closet: [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.LongCloset: [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.Theater: [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.Foyer: [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.Study: [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.SittingRoom: [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.LaundryRoom: [Tile.TileFloor1, Tile.TileFloor3, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3, Tile.ConcreteFloor],
    RT.Kitchen: [Tile.TileFloor1, Tile.TileFloor3],
    RT.StorageRoom: [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.DiningRoom: [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.DiningHall: [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
    RT.Garage: [Tile.ConcreteFloor]
}

var _walltypes: Dictionary = {
    RT.Hallway: [Tile.StripedWall1, Tile.StripedWall2],
    RT.Bedroom: [Tile.StripedWall1, Tile.StripedWall2],
    RT.MasterBedroom: [Tile.StripedWall1, Tile.StripedWall2],
    RT.Bathroom: [Tile.DiamondWall, Tile.CircleWall],
    RT.Washroom: [Tile.DiamondWall, Tile.CircleWall],
    RT.WardrobeRoom: [Tile.StripedWall1, Tile.StripedWall2],
    RT.Closet: [Tile.StripedWall1, Tile.StripedWall2, Tile.GradientWall1, Tile.GradientWall2, Tile.PipeWall],
    RT.LongCloset: [Tile.StripedWall1, Tile.StripedWall2, Tile.GradientWall1, Tile.GradientWall2, Tile.PipeWall],
    RT.Theater: [Tile.DebugWall],
    RT.Foyer: [Tile.DebugWall],
    RT.Study: [Tile.DebugWall],
    RT.SittingRoom: [Tile.StripedWall1, Tile.StripedWall2],
    RT.LaundryRoom: [Tile.StripedWall1, Tile.StripedWall2, Tile.GradientWall1, Tile.GradientWall2, Tile.RockyWall, Tile.PipeWall],
    RT.Kitchen: [Tile.DiamondWall, Tile.CircleWall],
    RT.StorageRoom: [Tile.GradientWall1, Tile.GradientWall2, Tile.RockyWall, Tile.PipeWall],
    RT.DiningRoom: [Tile.DiamondWall, Tile.CircleWall],
    RT.DiningHall: [Tile.DiamondWall, Tile.CircleWall],
    RT.Garage: [Tile.GradientWall1, Tile.GradientWall2, Tile.RockyWall, Tile.PipeWall]
}

func decide_room_type(dims: Vector2) -> int:
    if dims.x > dims.y:
        dims = Vector2(dims.y, dims.x)
    var arr = _roomtypes[dims]
    return arr[randi() % len(arr)]

func decide_floor_type(rtype: int) -> int:
    var arr = _floortypes[rtype]
    return arr[randi() % len(arr)]

func decide_wall_type(rtype: int) -> int:
    var arr = _walltypes[rtype]
    return arr[randi() % len(arr)]

func _ready():
    pass
