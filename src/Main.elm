port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MAIN


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }




-- PORTS


port sendMessage : String -> Cmd msg
port save : String -> Cmd msg
port messageReceiver : (String -> msg) -> Sub msg



-- MODEL


type alias Model = {fileContent:String}


init : () -> ( Model, Cmd Msg )
init flags =
  ( {fileContent=""}
  , Cmd.none
  )



-- UPDATE


type Msg
  = Clicked
  | FilePicked String
  | Save
  | Update String


-- Use the `sendMessage` port when someone presses ENTER or clicks
-- the "Send" button. Check out index.html to see the corresponding
-- JS where this is piped into a WebSocket.
--
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Clicked ->
      ( model
      , sendMessage "file_picker"
      )
    FilePicked str->
      ( {fileContent=str}
      , Cmd.none
      )
    Save ->
      ( model
      , save model.fileContent
      )
    Update s -> 
      ( {fileContent = s}
      , Cmd.none
      )


-- SUBSCRIPTIONS


-- Subscribe to the `messageReceiver` port to hear about messages coming in
-- from JS. Check out the index.html file to see how this is hooked up to a
-- WebSocket.
--
subscriptions : Model -> Sub Msg
subscriptions _ =
  messageReceiver FilePicked

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Clicked ] [ text "Upload" ]
    , button [ onClick Save ] [ text "Save"]
    , input
        [ type_ "text"
        , placeholder "File content"
        , onInput Update
        , value model.fileContent
        ]
        []
    ]
