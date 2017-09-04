module Model.PredefinedPrograms.Programs exposing (allPrograms, allProgramsDict)

import Dict exposing (Dict)
import Model.Model as Model
import Model.PredefinedPrograms.TexasMethod as TexasMethod

allPrograms : List Model.TrainingProgram
allPrograms =
    [ TexasMethod.basicProgram
    ]

allProgramsDict : Dict String Model.TrainingProgram
allProgramsDict =
    Dict.fromList <| List.map (\p -> (p.id, p)) allPrograms
