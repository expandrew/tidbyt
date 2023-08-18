# All Classical Radio

Show what's currently playing on [All Classical Radio](https://allclassical.org) on Tidbyt

| Horizontal                                                                      | Vertical                                                                      |
| ------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| ![All Classical Radio "Now Playing"](/allclassical/allclassical-horizontal.gif) | ![All Classical Radio "Now Playing"](/allclassical/allclassical-vertical.gif) |

## Settings

You can change the following settings:

- **Scroll direction**: Choose whether to scroll text horizontally or vertically
- **Scroll speed**: Slow down the scroll speed of the text
- **Show ensemble info**: Show the ensemble name, conductor, and/or soloist(s), if applicable
- **Use custom colors**: Choose your own text colors
  - **Color: Title**: Choose your own text color for the title of the current piece
  - **Color: Composer**: Choose your own text color for the composer of the current piece
  - **Color: Ensemble info**: Choose your own text color for the ensemble name/conductor/soloists

## Development

Use VS Code Task **Pixlet: Serve** and select `allclassical` to get started, then open `http://127.0.0.1:8080` in the browser to see the Pixlet output.

I have some mock responses from All Classical Radio in the [`mocks`](/allclassical/mocks) folder that can be used with Pixlet by running the **Mocks: Start server** VS Code task and selecting `allclassical`, then uncommenting the appropriate `ENDPOINT` lines in the main [allclassical.star](/allclassical/allclassical.star) file.
