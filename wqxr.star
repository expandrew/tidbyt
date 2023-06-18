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
                        render.WrappedText(content = "WQXR", height = 8, font = "tb-8")
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
    whats_on = http.get(url = WHATS_ON, ttl_seconds=30)

    if (whats_on.status_code) != 200:
        return now_playing("", "Can't connect to WQXR :(", "")

    has_current_show = whats_on.json()["current_show"]
    has_playlist_item = whats_on.json()["current_playlist_item"]

    if has_current_show:
        top_line = ""
        middle_line = whats_on.json()["current_show"]["title"]
        bottom_line = ""

    if has_playlist_item:
        top_line = whats_on.json()["current_playlist_item"]["catalog_entry"]["composer"]["name"]
        middle_line = whats_on.json()["current_playlist_item"]["catalog_entry"]["title"]
        bottom_line = whats_on.json()["current_playlist_item"]["catalog_entry"]["ensemble"]["name"] or ""

    return now_playing(top_line, middle_line, bottom_line)

