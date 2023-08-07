# KQAC (All Classical Portland)

Show what's currently playing on [All Classical Portland](https://allclassical.org) on Tidbyt

| Horizontal                                       | Vertical                                       |
| ------------------------------------------------ | ---------------------------------------------- |
| ![KQAC "Now Playing"](/kqac/kqac-horizontal.gif) | ![KQAC "Now Playing"](/kqac/kqac-vertical.gif) |

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

Use VS Code Task **Pixlet: Serve** and select `kqac` to get started, then open `http://127.0.0.1:8080` in the browser to see the Pixlet output.

I have some mock responses from KQAC in the [`mocks`](/kqac/mocks) folder that can be used with Pixlet by running the **Mocks: Start server** VS Code task and selecting `kqac`, then uncommenting the appropriate `ENDPOINT` lines in the main [kqac.star](/kqac/kqac.star) file.
