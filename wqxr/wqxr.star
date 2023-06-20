"""
Applet: WQXR
Summary: WQXR What's On
Description: Shows what's currently playing on WQXR, New York's Classical Music Radio Station
Author: Andrew Westling
"""

load("http.star", "http")
load("render.star", "render")

WHATS_ON = "https://api.wnyc.org/api/v1/whats_on/wqxr"

BLUE_HEADER_BAR = render.Stack(
    children = [
        render.Box(width = 64, height = 5, color = "12518A"),
        render.Text(content = "WQXR", height = 6, font = "tom-thumb"),
    ],
)

ERROR_CONTENT = render.Column(
    expanded = True,
    main_align = "space_around",
    children = [
        render.Marquee(width = 64, child = render.Text(content = "Can't connect to WQXR :(", color = "f00")),
    ],
)

def main():
    # Test data (run the "API: (WQXR): Serve mock API" VS Code task then uncomment a line below to test):
    # WHATS_ON = "http://localhost:1059/between-songs.json" # No catalog item (ex. between songs)
    # WHATS_ON = "http://localhost:1059/conductor.json" # Regular orchestral work, with conductor (ex. symphony)
    # WHATS_ON = "http://localhost:1059/no-conductor.json" # Regular orchestral work, without conductor (ex. symphony)
    # WHATS_ON = "http://localhost:1059/conductor-and-soloists.json" # Regular orchestral work, with soloists (ex. concerto)
    # WHATS_ON = "http://localhost:1059/no-ensemble-two-soloists.json" # No ensemble name, two soloists (ex. sonata)
    # WHATS_ON = "http://localhost:1059/404.json" # To test "Can't connect" (ex. API is down)

    whats_on = http.get(url = WHATS_ON, ttl_seconds = 30)

    if (whats_on.status_code) != 200:
        return render.Root(
            child = render.Column(
                children = [
                    BLUE_HEADER_BAR,
                    ERROR_CONTENT,
                ],
            ),
        )

    has_current_show = whats_on.json()["current_show"]
    has_playlist_item = whats_on.json()["current_playlist_item"]
    has_catalog_entry = has_playlist_item and whats_on.json()["current_playlist_item"]["catalog_entry"]

    title = ""
    composer = ""
    ensemble = ""
    people = ""

    if has_current_show:
        title = whats_on.json()["current_show"]["title"]

    if has_catalog_entry:
        title = has_catalog_entry and whats_on.json()["current_playlist_item"]["catalog_entry"]["title"]
        composer = has_catalog_entry and whats_on.json()["current_playlist_item"]["catalog_entry"]["composer"]["name"]

        # Ensemble
        has_ensemble = has_catalog_entry and whats_on.json()["current_playlist_item"]["catalog_entry"]["ensemble"]
        ensemble = has_ensemble and whats_on.json()["current_playlist_item"]["catalog_entry"]["ensemble"]["name"]

        # Conductor
        has_conductor = has_catalog_entry and whats_on.json()["current_playlist_item"]["catalog_entry"]["conductor"]
        conductor = has_conductor and whats_on.json()["current_playlist_item"]["catalog_entry"]["conductor"]["name"]

        # Soloists
        has_soloists = has_catalog_entry and len(whats_on.json()["current_playlist_item"]["catalog_entry"]["soloists"]) > 0
        soloists = has_soloists and whats_on.json()["current_playlist_item"]["catalog_entry"]["soloists"]

        people = build_people(conductor, soloists)

    CHILDREN = []

    if title:
        CHILDREN.append(render.Marquee(width = 64, child = render.Text(content = title, font = "tb-8")))
    if composer:
        CHILDREN.append(render.Marquee(width = 64, child = render.Text(content = composer, font = "tom-thumb")))
    if ensemble:
        CHILDREN.append(render.Marquee(width = 64, child = render.Text(content = ensemble, font = "tom-thumb")))
    if people:
        CHILDREN.append(render.Marquee(width = 64, child = render.Text(content = people, font = "tom-thumb")))

    return render.Root(
        child = render.Column(
            children = [
                BLUE_HEADER_BAR,
                render.Column(
                    expanded = True,
                    main_align = "space_evenly",
                    children = CHILDREN,
                ),
            ],
        ),
    )

def build_people(conductor, soloists):
    """Makes a string that combines the the ensemble name, conductor name, and soloist names/instruments in a nice way

    Args:
        conductor: string
        soloists: list

    Returns:
        string like "Aarhus Symphony Orchestra, Jean Thorel, conductor, Flemming Aksnes, horn, Lisa Maria Cooper, horn"
    """

    output = []

    if conductor:
        output.append("%s, conductor" % (conductor))

    if soloists:
        soloist_parts = []
        for soloist in soloists:
            soloist_parts.append("%s, %s" % (soloist["musician"]["name"], soloist["instruments"][0]))
        output.append(", ".join(soloist_parts))

    return ", ".join(output)
