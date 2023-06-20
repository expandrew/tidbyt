"""
Applet: WQXR
Summary: WQXR Now Playing
Description: Displays song, artist, and info currently streaming on WQXR
Author: Andrew Westling
"""

load("http.star", "http")
load("render.star", "render")

WHATS_ON = "https://api.wnyc.org/api/v1/whats_on/wqxr"

def now_playing(top_line, middle_line, bottom_line):
    return render.Root(
        child = render.Column(
            children = [
                # WQXR Heading
                render.Stack(
                    children = [
                        render.Box(width = 64, height = 8, color = "12518A"),
                        render.WrappedText(content = "WQXR", height = 8, font = "tb-8"),
                    ],
                ),
                render.Column(
                    children = [
                        render.Marquee(width = 64, child = render.Text(top_line)),
                        render.Marquee(width = 64, child = render.Text(middle_line)),
                        render.Marquee(width = 64, child = render.Text(bottom_line)),
                    ],
                ),
            ],
        ),
    )

def main():
    whats_on = http.get(url = WHATS_ON, ttl_seconds = 30)

    top_line = ""
    middle_line = ""
    bottom_line = ""

    if (whats_on.status_code) != 200:
        return now_playing("", "Can't connect to WQXR :(", "")

    has_current_show = whats_on.json()["current_show"]
    has_playlist_item = whats_on.json()["current_playlist_item"]
    has_catalog_entry = has_playlist_item and whats_on.json()["current_playlist_item"]["catalog_entry"]

    if has_current_show:
        top_line = ""
        middle_line = whats_on.json()["current_show"]["title"]
        bottom_line = ""

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

        top_line = title
        middle_line = composer
        bottom_line = build_bottom_line(ensemble, conductor, soloists)

    return now_playing(top_line, middle_line, bottom_line)

def build_bottom_line(ensemble, conductor, soloists):
    """Makes a string that combines the the ensemble name, conductor name, and soloist names/instruments in a nice way

    Args:
        ensemble: string
        conductor: string
        soloists: list

    Returns:
        string like "Aarhus Symphony Orchestra, Jean Thorel, conductor, Flemming Aksnes, horn, Lisa Maria Cooper, horn"
    """

    bottom_line_parts = []

    if ensemble:
        bottom_line_parts.append(ensemble)

    if conductor:
        bottom_line_parts.append("%s, conductor" % (conductor))

    if soloists:
        soloist_parts = []
        for soloist in soloists:
            soloist_parts.append("%s, %s" % (soloist["musician"]["name"], soloist["instruments"][0]))
        bottom_line_parts.append(", ".join(soloist_parts))

    return ", ".join(bottom_line_parts)
