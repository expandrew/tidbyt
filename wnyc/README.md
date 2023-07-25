# WNYC

Show what's currently playing on [WNYC](https://wnyc.org) on Tidbyt

| Horizontal                                      | Vertical                                      |
| ----------------------------------------------- | --------------------------------------------- |
| ![WNYC "What's On?"](/wnyc/wnyc-horizontal.gif) | ![WNYC "What's On?"](/wnyc/wnyc-vertical.gif) |

## Development

Use VS Code Task **Pixlet: Serve** and select `wnyc` to get started, then open `http://127.0.0.1:8080` in the browser to see the Pixlet output.

I have some mock API responses from WNYC in the [`wnyc-mock-api`](wnyc-mock-api) folder that can be used with Pixlet by running the **API: Serve mock API** VS Code task and selecting `wnyc`, then uncommenting the appropriate `WHATS_ON` lines in the main [wnyc.star](/wnyc/wnyc.star) file.
