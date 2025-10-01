# Mojolicious Markdown Docs Viewer

A tiny [Mojolicious::Lite](https://mojolicious.org/) app that serves and renders a folder (and subfolders) of Markdown files.

<p align="center"><img src="https://raw.githubusercontent.com/justinnamilee/mojdoc/refs/heads/main/.github/preview.png" alt="MOJDOC Preview" width="720"></p>

---

## Features

* **Renders markdown** (`.md`/`.markdown`) files (recursively) from a docs folder (ignores everything else)
* **Nested filetree** on the left hand side, great for navigation
* **GitHub-style** fenced code block support
* **Syntax highlighting** via `highlight.js`
* **Pluggable Markdown backends** (first found wins):
  1. `Text::MultiMarkdown`
  1. `Text::Markdown`
  1. `Markdown::Tiny`
  1. fallback to `<pre>`
* **Safe path resolution** (prevents path traversal)...hopefully
* **A fun cyberpunk theme** (with theme support hopefully coming at some point)
* Code written by someone with no Mojolicious experience, but lots of Perl experience

---

## Quickstart

```bash

# Setup Mojolicious (see URL above), for example
cpanm Mojolicious

# Install a Markdown Renderer (three supported)
cpanm Text::MultiMarkdown

# Clone the app
git clone 'https://github.com/justinnamilee/mojdoc.git'

# Create the documents directory and fill it with Markdown files
cd mojdoc && mkdir -p private/dox

# Run in dev with hot-reload
morbo mojdoc
```

---

## Configuration

You can configure via a `Config` plugin file (e.g. `mojdoc.conf`) **or** environment variables.  If you're going to be running under something like PM2 the ENV var configuration may be the easiest method as you can stick it all in your environement (**or** `ecosystem.config.js`) when you add it to PM2.  If using Systemd maybe the config files are easiest?  Hard to say.  Lots of ways to skin that particular cat, so use whatever is best for you.  For Docker deploys I would **100% recommend** using a config file mounted to `/opt/mojdoc/mojdoc.conf`.

### Specific Settings for `mojdoc`

|   Setting | ENV Var          | Default                           | What it does                     |
| --------: | ---------------- | --------------------------------: | -------------------------------- |
|   `badge` | `MOJDOC_BADGE`   | `cyber-docs`                      | Label used by the template UI.   |
|     `dox` | `MOJDOC_DOX`     | `private/dox`                     | Root folder to scan for docs.    |
| `welcome` | `MOJDOC_WELCOME` | `public/welcome.md`               | Welcome file rendered on `/`.    |
|   `logit` | `MOJDOC_LOGIT`   | `0`                               | Enable `view` GET logs with `1`. |

### Useful Settings for Mojolicious

| Setting              | ENV Var                   |                                 Default | What it does                                                             |
| -------------------: | ------------------------- | --------------------------------------: | -------------------------------------------------------------------------|
|             `listen` | `MOJO_LISTEN`             |                         `http://*:3000` | List of listen URLs for the built-in server.                             |
|              `proxy` | `MOJO_REVERSE_PROXY`      |  `0` (auto-on if `trusted_proxies` set) | Treat `X-Forwarded-*` headers as authoritative (behind a trusted proxy). |
|    `trusted_proxies` | `MOJO_TRUSTED_PROXIES`    |                                   empty | CIDR/IP list of proxies to trust for client IP.                          |
|          `log_level` | `MOJO_LOG_LEVEL`          |       `trace` (dev), `info` (otherwise) | Forces logger level (`trace`/`debug`/`info`/`warn`/`error`/`fatal`).     |
|   `max_request_size` | `MOJO_MAX_REQUEST_SIZE`   |                                  16 MiB | Caps total HTTP request size (body + params).                            |
| `keep_alive_timeout` | `MOJO_KEEP_ALIVE_TIMEOUT` |                                       5 | Seconds that idle connections may stay open.                             |


### Example `mojdoc.conf` File

```json
{
  "badge": "super-secret-dox",
  "dox": "/var/www/secure/dox",
  "welcome": "/var/www/secure/welcome.md",
  "logit": 0,
  /* vv this could all go in mojdoc.production.conf vv */
  "hypnotoad": {
    "listen": "http://*:9009",
    "max_request_size": 524288,
    /* vv assuming nginx or haproxy on localhost vv */
    "proxy": 1,
    "trusted_proxies": "127.0.0.1, ::1"
  }
}
```

> For more information on this topic see [The Mojolicious Cookbook](https://docs.mojolicious.org/Mojolicious/Guides/Cookbook).

---

## Routes

* `GET /`
  Renders the welcome page and shows a list of matching files discovered under `DOX`.

* `GET /view/*doc`
  Renders a specific Markdown file. From files within the `DOX` tree.

* `GET /health`
  Returns `OK`. Useful for health checks.

---

## Deploy Methods

* Direct via Systemd with Hypnotoad, fairly [well documented](https://docs.mojolicious.org/Mojolicious/Guides/Cookbook#Hypnotoad) if you search the net!
  It would be best to use the `WorkingDirectory` Service variable to have it run from inside the mojdoc folder, that's the only recommended change from what is suggested in the cookbook.

* Managed by PM2, if you use the Hypnotoad foreground mode then it should work fairly well.

* Docker is also available, with an example compose file provided [here](https://raw.githubusercontent.com/justinnamilee/mojdoc/refs/heads/main/docker-compose.example.yml).
  See the [packages](https://github.com/justinnamilee/mojdoc/pkgs/container/mojdoc) section on GitHub for more info there.

---

## Directory Structure

```
├── docker-compose.example.yml   ## useful if you want to deploy with Docker instead
├── Dockerfile
├── LICENSE
├── Makefile.PL
├── mojdoc                       ## main application
├── mojdoc.conf                  ## your example config, it's in .gitignore
├── private                      ## this folder is in .gitignore
│   ├── dox
│   │   └── yourExample.md       ## where your files or subdirectories go
│   └── welcome.md               ## your replacement welcome.md if you wanted
├── public
│   ├── css
│   │   └── mojdoc.css
│   ├── favicon.svg
│   └── welcome.md               ## default welcome page
├── README.md
├── t                            ## a non-zero amount of testing
│   ├── 00-load.t
│   ├── 01-health.t
│   ├── 02-badge.t
│   ├── 03-badpath.t
│   └── 04-view.t
└── templates                    ## actual web stuff for mojolicious
    ├── dox.html.ep
    ├── exception.html.ep
    ├── layouts
    │   └── mojdoc.html.ep
    ├── nodox.html.ep
    ├── not_found.html.ep
    └── sidebar.html.ep
```
