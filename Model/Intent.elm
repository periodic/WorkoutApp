module Model.Intent exposing (Intent(..))

import Model.Model as Model

type Intent
    = ListProgramsIntent
    | ViewProgramIntent Model.TrainingProgram
