module Model.PredefinedPrograms.Programs exposing (allPrograms, allProgramsDict)

import Dict exposing (Dict)
import Model.Model as Model
import Model.PredefinedPrograms.TexasMethod as TexasMethod

allPrograms : List Model.TrainingProgramDefinition
allPrograms =
    [ TexasMethod.basicProgram
    ]

allProgramsDict : Dict String Model.TrainingProgramDefinition
allProgramsDict =
    Dict.fromList <| List.map (\p -> (p.id, p)) allPrograms
