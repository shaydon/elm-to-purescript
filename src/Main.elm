module Main exposing (main)

import Browser
import Color.OneDark exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes
import PureScript


type alias Model =
    { elmSource : String
    , purescriptSource : String
    }


initialModel : Model
initialModel =
    { elmSource = ""
    , purescriptSource = ""
    }


type Msg
    = ElmSourceChanged String
    | TranslatePressed


update : Msg -> Model -> Model
update msg model =
    case msg of
        ElmSourceChanged source ->
            { model | elmSource = source }

        TranslatePressed ->
            { model
                | purescriptSource =
                    case PureScript.fromElm model.elmSource of
                        Ok purescriptSource ->
                            purescriptSource

                        Err err ->
                            Debug.toString err
            }


view : Model -> Html Msg
view model =
    column [ width fill, height fill, padding 10, spacing 10 ]
        [ Input.multiline
            sourceAttrs
            { onChange = ElmSourceChanged
            , text = model.elmSource
            , placeholder = Nothing
            , label =
                Input.labelAbove [ Font.family [ Font.sansSerif ] ]
                    (text "Elm Source")
            , spellcheck = False
            }
        , Input.button [ Background.color green, Border.rounded 5, padding 10 ]
            { onPress = Just TranslatePressed
            , label = text "Translate >>"
            }
        , column [ width fill, height fill, spacing 5 ]
            [ text "PureScript source"
            , pre sourceAttrs model.purescriptSource
            ]
        ]
        |> layout []


sourceAttrs : List (Attribute msg)
sourceAttrs =
    [ width fill
    , height fill
    , Border.width 1
    , Border.color black
    , Border.rounded 3
    , padding 12
    , Font.family [ Font.monospace ]
    ]


pre : List (Attribute msg) -> String -> Element msg
pre attrs text =
    paragraph
        (Element.htmlAttribute
            (Html.Attributes.style "white-space" "pre")
            :: attrs
        )
        [ Element.html
            (Html.text text)
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
