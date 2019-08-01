extends Node

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
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.ColumnedWall1, Tile.ColumnedWall2, Tile.ColumnedWall3]
    },
    RT.Bedroom: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.ColumnedWall1, Tile.ColumnedWall2, Tile.ColumnedWall3]
    },
    RT.MasterBedroom: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.RedRegalWall, Tile.OrangeRegalWall]
    },
    RT.Bathroom: {
        "floors": [Tile.TileFloor1, Tile.TileFloor3],
        "walls": [Tile.DiamondWall, Tile.CircleWall]
    },
    RT.Washroom: {
        "floors": [Tile.TileFloor1, Tile.TileFloor3],
        "walls": [Tile.DiamondWall, Tile.CircleWall]
    },
    RT.WardrobeRoom: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.ColumnedWall1, Tile.ColumnedWall2, Tile.ColumnedWall3]
    },
    RT.Closet: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.GradientWall1, Tile.GradientWall2, Tile.PipeWall]
    },
    RT.LongCloset: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.GradientWall1, Tile.GradientWall2, Tile.PipeWall]
    },
    RT.Theater: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.RedRegalWall, Tile.OrangeRegalWall]
    },
    RT.Foyer: {
        "floors": [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.RedRegalWall, Tile.OrangeRegalWall]
    },
    RT.Study: {
        "floors": [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.ColumnedWall1, Tile.ColumnedWall2, Tile.ColumnedWall3]
    },
    RT.SittingRoom: {
        "floors": [Tile.LightGrayCarpet, Tile.GrayCarpet, Tile.DarkGrayCarpet, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.StripedWall1, Tile.StripedWall2]
    },
    RT.LaundryRoom: {
        "floors": [Tile.TileFloor1, Tile.TileFloor3, Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3, Tile.ConcreteFloor],
        "walls": [Tile.StripedWall1, Tile.StripedWall2, Tile.GradientWall1, Tile.GradientWall2, Tile.RockyWall, Tile.PipeWall]
    },
    RT.Kitchen: {
        "floors": [Tile.TileFloor1, Tile.TileFloor3],
        "walls": [Tile.DiamondWall, Tile.CircleWall]
    },
    RT.StorageRoom: {
        "floors": [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.GradientWall1, Tile.GradientWall2, Tile.RockyWall, Tile.PipeWall]
    },
    RT.DiningRoom: {
        "floors": [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.DiamondWall, Tile.CircleWall, Tile.RedRegalWall, Tile.OrangeRegalWall]
    },
    RT.DiningHall: {
        "floors": [Tile.WoodFloor1, Tile.WoodFloor2, Tile.WoodFloor3],
        "walls": [Tile.DiamondWall, Tile.CircleWall, Tile.RedRegalWall, Tile.OrangeRegalWall]
    },
    RT.Garage: {
        "floors": [Tile.ConcreteFloor],
        "walls": [Tile.GradientWall1, Tile.GradientWall2, Tile.RockyWall, Tile.PipeWall]
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

func _ready():
    pass
