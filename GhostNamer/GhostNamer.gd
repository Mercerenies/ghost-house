extends Reference

enum Gender {
    Male = 0,
    Female = 1,
}

const MaleGhost = preload("res://Ghost/MaleGhost.png")
const FemaleGhost = preload("res://Ghost/FemaleGhost.png")

const NAMES = [
    # A
    ["Antonio", "Arthur", "Antoine"],
    ["Angelica", "Amanda"],
    # B
    ["Bartholomew", "Barney"],
    ["Bernadette", "Brigitte"],
    # C
    ["Charles", "Chris"],
    ["Claire", "Clara", "Cornelia"],
    # D
    ["Davis", "Dudley", "Damian"],
    ["Deborah", "Diane", "Dana"],
    # E
    ["Emmett", "Ellsworth", "Emmanuel"],
    ["Elizabeth", "Evangeline", "Eva"],
    # F
    ["Floyd", "Freddie", "Frances"],
    ["Faith", "Florence"],
    # G
    ["Geoffrey", "Guido", "Guillermo"],
    ["Georgette", "Gracie", "Gertrude"],
    # H
    ["Hans", "Harold"],
    ["Hallie", "Hillary", "Hannah"],
    # I
    ["Isaac", "Ian"],
    ["Isabella"],
    # J
    ["Jake", "Jackson", "Jamison"],
    ["Janine", "Johanna", "Josephine"],
    # K
    ["Kermit", "Kelvin", "Kasey"],
    ["Kathy", "Katherine", "Kaitlin"],
    # L
    ["Lawrence", "Lyle"],
    ["Laura", "Louise", "Leah"],
    # M
    ["Malcolm", "Marcus", "Maxwell"],
    ["Marisol", "Minerva", "Molly", "Maggie"],
    # N
    ["Nigel", "Noah"],
    ["Nina", "Nancy", "Naomi"],
    # O
    [],
    ["Odessa"],
    # P
    ["Porfirio"],
    ["Pearl"],
    # Q
    ["Quincy", "Quentin"],
    [],
    # R
    ["Ralph", "Renaldo", "Richard"],
    ["Rena", "Rhonda", "Rosanna", "Rosella"],
    # S
    ["Spencer", "Sergio"],
    ["Sonya", "Selma", "Sadie"],
    # T
    ["Timothy", "Toby", "Tomas", "Tristan"],
    ["Tamera", "Toni", "Tiffany"],
    # U
    ["Ulysses"],
    [],
    # V
    ["Vincent", "Vance", "Victor"],
    ["Victoria"],
    # W
    ["William", "Willy"],
    ["Wendy", "Wanda"],
    # X
    [],
    [],
    # Y
    [],
    ["Yvette"],
    # Z
    [],
    [],
]


var letters: Array
var male: int = -1
var female: int = -1

func _init() -> void:
    letters = range(26)
    letters.shuffle()

func _get_name_list(index: int, gender: int) -> Array:
    return NAMES[letters[index % 26] * 2 + gender]

func generate_name(gender: int):
    if gender == Gender.Male:
        while true:
            male += 1
            if not _get_name_list(male, Gender.Male).empty():
                if _get_name_list(female, Gender.Female).empty() or male > female:
                    return {
                        "index": letters[male % 26],
                        "name": Util.choose(_get_name_list(male, Gender.Male)),
                    }
    else:
        while true:
            female += 1
            if not _get_name_list(female, Gender.Female).empty():
                if _get_name_list(male, Gender.Male).empty() or male < female:
                    return {
                        "index": letters[female % 26],
                        "name": Util.choose(_get_name_list(female, Gender.Female)),
                    }

static func gender_to_image(gender: int) -> Texture:
    return MaleGhost if gender == Gender.Male else FemaleGhost
