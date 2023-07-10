# KQAC

Show what's currently playing on [All Classical Portland (KQAC)](https://allclassical.org) on Tidbyt

## Development

Use VS Code Task **Pixlet: (KQAC): Serve** to get started, then open `http://127.0.0.1:8080` in the browser to see the Pixlet output.

I have some mock API responses from KQAC in the [`kqac-mock-api`](kqac-mock-api) folder that can be used with Pixlet by running the **API: (KQAC): Serve mock API** VS Code task and uncommenting the appropriate `NOW_PLAYING` lines in the main [kqac.star](/kqac/kqac.star) file.
