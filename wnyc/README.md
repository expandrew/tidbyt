# WNYC

Show what's currently playing on [WNYC](https://wnyc.org) on Tidbyt

| Layout               | Preview                                      |
| -------------------- | -------------------------------------------- |
| Name and Image       | ![WNYC](/wnyc/wnyc-name-and-image.gif)       |
| Name and Description | ![WNYC](/wnyc/wnyc-name-and-description.gif) |
| Name only            | ![WNYC](/wnyc/wnyc-name-only.gif)            |

## Settings

You can change the following settings:

- **Stream**: Choose which stream to display info for (93.9 FM or AM 820)
- **Layout**: Choose which layout to use for the info
  - **Name and Image**: The show's title, and the show's image. Title scrolls horizontally next to the image.
  - **Name and Description**: The show's title, and the "description" of the show. Scrolls vertically, but slower. (For some shows, the "description" is used for information about the particular episode; for other shows, it's just generic information about the show)
  - **Name only**: Just the show's title, no other info. Wraps and scrolls vertically if it gets too long.
- **Use custom colors**: Choose your own text colors
  - **Color: Show Title**: Choose your own color for the show's title
  - **Color: Description**: Choose your own color for the description of the show

## Development

Use VS Code Task **Pixlet: Serve** and select `wnyc` to get started, then open `http://127.0.0.1:8080` in the browser to see the Pixlet output.

I have some mock API responses from WNYC in the [`wnyc-mock-api`](wnyc-mock-api) folder that can be used with Pixlet by running the **API: Serve mock API** VS Code task and selecting `wnyc`, then uncommenting the appropriate `WHATS_ON` lines in the main [wnyc.star](/wnyc/wnyc.star) file.
