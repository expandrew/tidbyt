"""
Applet: All Classical Portland (KQAC)
Summary: All Classical Portland (KQAC) Now Playing
Description: Shows what's currently playing on All Classical Portland (KQAC)
Author: Andrew Westling
"""

load("http.star", "http")
load("render.star", "render")
load("schema.star", "schema")

NOW_PLAYING = "https://daisy.allclassical.org/json/now_play3.json"

COLORS = {
    "dark_blue": "#263741",
    "medium_blue": "#0162AB",
    "light_blue": "#98F6EF",
    "white": "#FFFFFF",
    "light_gray": "#AAAAAA",
    "medium_gray": "#888888",
    "dark_gray": "#444444",
    "red": "#FF0000",
}

SCROLL_DIRECTION_OPTIONS = [
    schema.Option(
        display = "Horizontal",
        value = "horizontal",
    ),
    schema.Option(
        display = "Vertical",
        value = "vertical",
    ),
]

SCROLL_SPEED_OPTIONS = [
    schema.Option(
        display = "Fast",
        value = "0",
    ),
    schema.Option(
        display = "Slower",
        value = "100",
    ),
    schema.Option(
        display = "Slowest",
        value = "200",
    ),
]

DEFAULT_SCROLL_DIRECTION = SCROLL_DIRECTION_OPTIONS[0].value
DEFAULT_SCROLL_SPEED = SCROLL_SPEED_OPTIONS[0].value
DEFAULT_SHOW_ENSEMBLE = False
DEFAULT_SHOW_PEOPLE = True
DEFAULT_USE_CUSTOM_COLORS = False
DEFAULT_COLOR_TITLE = COLORS["light_blue"]
DEFAULT_COLOR_COMPOSER = COLORS["white"]
DEFAULT_COLOR_ENSEMBLE = COLORS["medium_gray"]
DEFAULT_COLOR_PEOPLE = COLORS["medium_gray"]

HEADER_BAR = render.Stack(
    children = [
        render.Box(width = 64, height = 5, color = COLORS["dark_blue"]),
        render.Text(content = "All Classical", height = 6, font = "tom-thumb"),
    ],
)

ERROR_CONTENT = render.Column(
    expanded = True,
    main_align = "space_around",
    children = [
        render.Marquee(width = 64, child = render.Text(content = "Can't connect to All Classical", color = COLORS["red"])),
    ],
)

def main(config):
    # Test data (run the "API: (KQAC): Serve mock API" VS Code task then uncomment a line below to test):
    # NOW_PLAYING = "http://localhost:60899/between-songs.json" # No catalog item (ex. between songs)
    # NOW_PLAYING = "http://localhost:60899/specific-show.json" # A particular show without catalog item (ex. NYPhil broadcast)
    # NOW_PLAYING = "http://localhost:60899/conductor.json" # Regular orchestral work, with conductor (ex. symphony)
    # NOW_PLAYING = "http://localhost:60899/no-conductor.json" # Regular orchestral work, without conductor (ex. symphony)
    # NOW_PLAYING = "http://localhost:60899/conductor-and-soloists.json" # Regular orchestral work, with soloists (ex. concerto)
    # NOW_PLAYING = "http://localhost:60899/no-ensemble-two-soloists.json" # No ensemble name, two soloists (ex. sonata)
    # NOW_PLAYING = "http://localhost:60899/404.json" # To test "Can't connect" (ex. API is down)

    # Get settings values
    scroll_direction = config.str("scroll_direction", DEFAULT_SCROLL_DIRECTION)
    scroll_speed = int(config.str("scroll_speed", DEFAULT_SCROLL_SPEED))
    should_show_ensemble = config.bool("show_ensemble", DEFAULT_SHOW_ENSEMBLE)
    should_show_people = config.bool("show_people", DEFAULT_SHOW_PEOPLE)
    use_custom_colors = config.bool("use_custom_colors", DEFAULT_USE_CUSTOM_COLORS)

    # Get data
    now_playing = http.get(url = NOW_PLAYING, ttl_seconds = 30)

    if (now_playing.status_code) != 200:
        return render.Root(
            child = render.Column(
                children = [
                    HEADER_BAR,
                    ERROR_CONTENT,
                ],
            ),
        )

    # Parse data
    has_current_show = now_playing.json()["title"]
    has_song = now_playing.json()["song"]["displaySong"] == True

    title = ""
    composer = ""
    ensemble = ""
    people = ""

    if has_current_show:
        title = now_playing.json()["title"]

    if has_song:
        title = has_song and now_playing.json()["song"]["title"]
        composer = has_song and now_playing.json()["song"]["composer"]

        # Ensemble
        has_ensemble = has_song and now_playing.json()["song"]["ensemble"]
        ensemble = has_ensemble and now_playing.json()["song"]["ensemble"]

        # Conductor
        has_conductor = has_song and now_playing.json()["song"]["conductor"]
        conductor = has_conductor and now_playing.json()["song"]["conductor"]

        # Soloists
        has_soloists = has_song and now_playing.json()["song"]["soloist"]
        soloists = has_soloists and now_playing.json()["song"]["soloist"]

        people = build_people(conductor, soloists)

    # Handle colors
    if use_custom_colors:
        color_title = config.str("color_title", DEFAULT_COLOR_TITLE)
        color_composer = config.str("color_composer", DEFAULT_COLOR_COMPOSER)
        color_ensemble = config.str("color_ensemble", DEFAULT_COLOR_ENSEMBLE)
        color_people = config.str("color_people", DEFAULT_COLOR_PEOPLE)
    else:
        color_title = DEFAULT_COLOR_TITLE
        color_composer = DEFAULT_COLOR_COMPOSER
        color_ensemble = DEFAULT_COLOR_ENSEMBLE
        color_people = DEFAULT_COLOR_PEOPLE

    # These are just for putting the content into
    root_contents = None
    data_parts = []

    # Vertical scrolling
    if scroll_direction == "vertical":
        # For vertical mode, each child needs to be a WrappedText widget, so the text will wrap to the next line

        # (I also wrap each child in a Padding widget with appropriate spacing, so things can breathe a little bit)
        pad = (0, 4, 0, 0)  # (left, top, right, bottom)

        if title:
            # Don't pad the top one because it doesn't need it
            data_parts.append(render.Padding(pad = 0, child = render.WrappedText(align = "center", width = 64, content = title, font = "tb-8", color = color_title)))
        if composer:
            data_parts.append(render.Padding(pad = pad, child = render.WrappedText(align = "center", width = 64, content = composer, font = "tom-thumb", color = color_composer)))
        if should_show_ensemble and ensemble:
            data_parts.append(render.Padding(pad = pad, child = render.WrappedText(align = "center", width = 64, content = ensemble, font = "tom-thumb", color = color_ensemble)))
        if should_show_people and people:
            data_parts.append(render.Padding(pad = pad, child = render.WrappedText(align = "center", width = 64, content = people, font = "tom-thumb", color = color_people)))

        root_contents = render.Marquee(
            scroll_direction = "vertical",
            height = 27,
            child = render.Column(children = data_parts),
        )

    # Horizontal scrolling
    if scroll_direction == "horizontal":
        # For horizontal mode, each child needs to be its own Marquee widget, so each line will scroll individually when too long
        if title:
            data_parts.append(render.Marquee(width = 64, child = render.Text(content = title, font = "tb-8", color = color_title)))
        if composer:
            data_parts.append(render.Marquee(width = 64, child = render.Text(content = composer, font = "tom-thumb", color = color_composer)))
        if should_show_ensemble and ensemble:
            data_parts.append(render.Marquee(width = 64, child = render.Text(content = ensemble, font = "tom-thumb", color = color_ensemble)))
        if should_show_people and people:
            data_parts.append(render.Marquee(width = 64, child = render.Text(content = people, font = "tom-thumb", color = color_people)))

        root_contents = render.Column(
            expanded = True,
            main_align = "space_evenly",
            children = data_parts,
        )

    return render.Root(
        max_age = 60,
        delay = scroll_speed,
        child = render.Column(
            children = [
                HEADER_BAR,
                root_contents,
            ],
        ),
    )

def build_people(conductor, soloists):
    output = []

    if soloists:
        output.append(soloists)

    if conductor:
        output.append("%s, conductor" % (conductor))

    return ", ".join(output)

def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Dropdown(
                id = "scroll_direction",
                name = "Scroll direction",
                desc = "Choose whether to scroll text horizontally or vertically",
                icon = "alignJustify",
                options = SCROLL_DIRECTION_OPTIONS,
                default = DEFAULT_SCROLL_DIRECTION,
            ),
            schema.Dropdown(
                id = "scroll_speed",
                name = "Scroll speed",
                desc = "Slow down the scroll speed of the text",
                icon = "gauge",
                options = SCROLL_SPEED_OPTIONS,
                default = DEFAULT_SCROLL_SPEED,
            ),
            schema.Toggle(
                id = "show_ensemble",
                name = "Show ensemble",
                desc = "Show the ensemble, if applicable",
                icon = "peopleGroup",
                default = DEFAULT_SHOW_ENSEMBLE,
            ),
            schema.Toggle(
                id = "show_people",
                name = "Show conductor and soloists",
                desc = "Show the conductor and/or soloist(s), if applicable",
                icon = "wandMagicSparkles",
                default = DEFAULT_SHOW_PEOPLE,
            ),
            schema.Toggle(
                id = "use_custom_colors",
                name = "Use custom colors",
                desc = "Choose your own text colors",
                icon = "palette",
                default = DEFAULT_USE_CUSTOM_COLORS,
            ),
            schema.Generated(
                id = "custom_colors",
                source = "use_custom_colors",
                handler = custom_colors,
            ),
        ],
    )

def custom_colors(use_custom_colors):
    if use_custom_colors == "true":  # Not a real Boolean, it's a string!
        return [
            schema.Color(
                id = "color_title",
                name = "Color: Title",
                desc = "Choose your own color for the title of the current piece",
                icon = "palette",
                default = DEFAULT_COLOR_TITLE,
                palette = [
                    COLORS["white"],
                    COLORS["light_blue"],
                    COLORS["medium_blue"],
                ],
            ),
            schema.Color(
                id = "color_composer",
                name = "Color: Composer",
                desc = "Choose your own color for the composer of the current piece",
                icon = "palette",
                default = DEFAULT_COLOR_COMPOSER,
                palette = [
                    COLORS["white"],
                    COLORS["light_blue"],
                    COLORS["medium_blue"],
                    COLORS["dark_blue"],
                ],
            ),
            schema.Color(
                id = "color_ensemble",
                name = "Color: Ensemble",
                desc = "Choose your own color for the ensemble",
                icon = "palette",
                default = DEFAULT_COLOR_ENSEMBLE,
                palette = [
                    COLORS["white"],
                    COLORS["light_gray"],
                    COLORS["medium_gray"],
                    COLORS["dark_gray"],
                ],
            ),
            schema.Color(
                id = "color_people",
                name = "Color: Conductor/Soloists",
                desc = "Choose your own color for the conductor/soloists",
                icon = "palette",
                default = DEFAULT_COLOR_PEOPLE,
                palette = [
                    COLORS["white"],
                    COLORS["light_gray"],
                    COLORS["medium_gray"],
                    COLORS["dark_gray"],
                ],
            ),
        ]
    else:
        return []
