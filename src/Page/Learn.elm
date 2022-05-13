module Page.Learn exposing (Data, Model, Msg, chapterBox, page)

import Data.GuideChapter as GuideChapter exposing (Chapter)
import DataSource exposing (DataSource)
import DataSource.File as File
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attribute
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


type alias Data =
    List Chapter


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    GuideChapter.filePaths
        |> DataSource.map
            (List.map (\file -> File.bodyWithFrontmatter (GuideChapter.decoder file.name) file.path))
        |> DataSource.resolve


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Gren"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "Gren logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Learn how to program in Gren"
        , locale = Nothing
        , title = "Gren - Learn"
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View msg
view _ _ payload =
    { title = "Gren - Learn"
    , body =
        [ Html.h3 []
            [ Html.text "Learn" ]
        , chapterBox payload.data
        , Html.p []
            [ Html.text description ]
        ]
    }


description : String
description =
    String.trim """
    Welcome to the official Gren Guide.
    Once you've read through this guide, you might want to check out some example projects.
    You can ask questions in our #beginner channel on Zulip.
    Note: This guide is still being worked on.
    """


chapterBox : List Chapter -> Html msg
chapterBox chapters =
    Html.ul []
        (List.map chapterLink chapters)


chapterLink : Chapter -> Html msg
chapterLink chapter =
    Html.li []
        [ Html.a
            [ Attribute.href <| "/learn/" ++ chapter.slug
            , Attribute.title <| "Read '" ++ chapter.title ++ "'"
            ]
            [ Html.text chapter.title ]
        ]
