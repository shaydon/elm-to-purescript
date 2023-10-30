module PureScript exposing (fromElm)

import Elm.Parser as Parser
import Elm.Processing as Processing
import Parser exposing (DeadEnd)
import PureScript.ElmDependencies as Dependencies
import PureScript.Writer as Writer


fromElm : String -> Result (List DeadEnd) String
fromElm elmSource =
    let
        dependencies =
            Processing.init
                |> Processing.addDependency Dependencies.elmCore
                |> Processing.addDependency Dependencies.elmParser
                |> Processing.addDependency Dependencies.elmUrl
    in
    Parser.parse elmSource
        |> Result.map (Processing.process dependencies)
        |> Result.map Writer.writeFile
        |> Result.map Writer.write
