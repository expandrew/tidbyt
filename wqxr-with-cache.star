"""
Applet: WQXR
Summary: WQXR Now Playing
Description: Displays song, artist, and info currently streaming on WQXR
Author: Andrew Westling
"""

load("http.star", "http")
load("render.star", "render")
load("time.star", "time")
load("cache.star", "cache")

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
    top_line = cache.get("wqxr_whats_on_top_line") or ""
    middle_line = cache.get("wqxr_whats_on_middle_line") or ""
    bottom_line = cache.get("wqxr_whats_on_bottom_line") or ""
    ttl_seconds = cache.get("wqxr_whats_on_ttl")

    if ttl_seconds == None:
        ttl_seconds = 15

    # Cache stores everything as a string, so we need to put it back to integer
    if type(ttl_seconds) == "string":
      ttl_seconds = int(ttl_seconds)

    whats_on = http.get(url = WHATS_ON, ttl_seconds=ttl_seconds)

    if (whats_on.status_code) != 200:
        return now_playing("", "Can't connect to WQXR :(", "")

    has_current_show = whats_on.json()["current_show"]
    has_playlist_item = whats_on.json()["current_playlist_item"]
    time_until_refetch = time.parse_duration("15s")

    if has_current_show:
        top_line = ""
        middle_line = whats_on.json()["current_show"]["title"]
        bottom_line = ""

        # Figure out when to check for updates
        end_time = time.parse_time(whats_on.json()["current_show"]["iso_end"])
        when_to_refetch = end_time
        time_until_refetch = when_to_refetch - time.now()

    if has_playlist_item:
        top_line = whats_on.json()["current_playlist_item"]["catalog_entry"]["composer"]["name"]
        middle_line = whats_on.json()["current_playlist_item"]["catalog_entry"]["title"]
        bottom_line = whats_on.json()["current_playlist_item"]["catalog_entry"]["ensemble"]["name"] or ""

        # Figure out when to check for updates
        start_time = time.parse_time(whats_on.json()["current_playlist_item"]["iso_start_time"])
        duration = time.parse_duration(("%ss" % whats_on.json()["current_playlist_item"]["catalog_entry"]["length"]))
        when_to_refetch = start_time + duration
        time_until_refetch = when_to_refetch - time.now()

    ttl_seconds = duration_to_seconds(time_until_refetch) or 15

    # Set cache to know when to refetch
    cache.set("wqxr-whats-on-ttl", str(ttl_seconds), ttl_seconds=ttl_seconds)
    cache.set("wqxr-whats-on-top-line", top_line, ttl_seconds=ttl_seconds)
    cache.set("wqxr-whats-on-middle-line", middle_line, ttl_seconds=ttl_seconds)
    cache.set("wqxr-whats-on-bottom-line", bottom_line, ttl_seconds=ttl_seconds)

    return now_playing(top_line, middle_line, bottom_line)

def duration_to_seconds(duration):
    hours = duration.hours
    minutes = duration.minutes
    seconds = duration.seconds

    total_seconds = (hours * 3600) + (minutes * 60) + seconds

    if total_seconds < 0:
        total_seconds = 0

    return int(total_seconds)
