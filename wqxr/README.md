# WQXR

Show what's currently playing on [WQXR](https://wqxr.org) on Tidbyt

| Horizontal                                      | Vertical                                      |
| ----------------------------------------------- | --------------------------------------------- |
| ![WQXR "What's On?"](/wqxr/wqxr-horizontal.gif) | ![WQXR "What's On?"](/wqxr/wqxr-vertical.gif) |

## Settings

You can change the following settings:

- **Scroll direction**: Choose whether to scroll text horizontally or vertically
- **Scroll speed**: Slow down the scroll speed of the text
- **Show ensemble**: Show the ensemble, if applicable
- **Show conductor and soloists**: Show the conductor and/or soloist(s), if applicable
- **Use custom colors**: Choose your own text colors
  - **Color: Title**: Choose your own text color for the title of the current piece
  - **Color: Composer**: Choose your own text color for the composer of the current piece
  - **Color: Ensemble**: Choose your own text color for the ensemble
  - **Color: Conductor/Soloists**: Choose your own text color for the conductor/soloists

## Development

Use VS Code Task **Pixlet: Serve** and select `wqxr` to get started, then open `http://127.0.0.1:8080` in the browser to see the Pixlet output.

I have some mock responses from WQXR in the [`mocks`](/wqxr/mocks) folder that can be used with Pixlet by running the **Mocks: Start server** VS Code task and selecting `wqxr`, then uncommenting the appropriate `WHATS_ON` lines in the main [wqxr.star](/wqxr/wqxr.star) file.
