module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, span, text)
import Html.Attributes exposing (class, hidden, placeholder, value)
import Html.Events exposing (onClick, onInput)
import List.Extra
import Random



---- MODEL ----


type alias Model =
    { luxuriousName : String, hideNewName : Bool, positionOfName : Int }


init : ( Model, Cmd Msg )
init =
    ( { luxuriousName = "", hideNewName = True, positionOfName = 0 }, Cmd.none )



---- UPDATE ----


type Msg
    = ChangeName String
    | Send
    | YubabaSelect Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeName inputName ->
            ( { model | luxuriousName = inputName }, Cmd.none )

        Send ->
            ( { model | hideNewName = False }, Random.generate YubabaSelect (Random.int 0 (String.length model.luxuriousName - 1)) )

        YubabaSelect randomValue ->
            ( { model | positionOfName = randomValue }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "契約書だよ。そこに名前を書きな。" ]
        , div []
            [ span []
                [ input [ class "input", placeholder "名前", value model.luxuriousName, onInput ChangeName ] []
                , button [ onClick Send ] [ text "書いた" ]
                ]
            ]
        , div [ hidden model.hideNewName ]
            [ text
                ("フン。"
                    ++ model.luxuriousName
                    ++ "というのかい。贅沢な名だねぇ。"
                )
            ]
        , div [ hidden model.hideNewName ]
            [ text
                ("今からお前の名前は"
                    ++ convertNewName model.positionOfName model.luxuriousName
                    ++ "だ。いいかい、"
                    ++ convertNewName model.positionOfName model.luxuriousName
                    ++ "だよ。分かったら返事をするんだ、"
                    ++ convertNewName model.positionOfName model.luxuriousName
                    ++ "!!"
                )
            ]
        ]

convertNewName : Int -> String -> String
convertNewName index oldName =
    Maybe.withDefault "" (List.Extra.getAt index (String.split "" oldName))



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
