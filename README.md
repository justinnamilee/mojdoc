# Mojolicious Markdown Docs Viewer

A tiny [Mojolicious::Lite](https://mojolicious.org/) app that serves and renders a folder (and subfolders) of Markdown files.

---

## Features

* Renders `.md` / `.markdown` files (recursively) from a docs folder (ignores everything else)
* GitHub-style fenced code blocks (`lang … `)
* Syntax highlighting via `highlight.js`
* Pluggable Markdown backends (first found wins):
  1. `Text::MultiMarkdown`
  1. `Text::Markdown`
  1. `Markdown::Tiny`
  1. fallback to `<pre>`
* Safe path resolution (prevents path traversal)...hopefully
* Code written by someone with zero Mojolicious experience, but lots of Perl experience

---

## Quickstart

```bash
# Setup Mojolicious (see URL above), for example
cpanm Mojolicious

# Install (pick your favorite Markdown backend; MultiMarkdown recommended)
cpanm Text::MultiMarkdown

# Clone the app
git clone 'https://github.com/justinnamilee/mojdoc.git'

# Create the documents directory and fill it with Markdown files
cd mojdoc && mkdir -p private/dox

# Run in dev with hot-reload
morbo mojdoc

# Or run the built-in daemon
perl mojdoc daemon -l http://*:3000
```

---

## Configuration

You can configure via a `Config` plugin file (e.g. `mojdoc.conf`) **or** environment variables.  If you're going to be running under something like PM2 the ENV var configuration may be the easiest method as you can stick it all in your environement (**or** `ecosystem.config.js`) when you add it to PM2.  If using Systemd maybe the config files are easiest?  Hard to say.  Lots of ways to skin that particular cat, so use whatever is best for you.

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
  // vv this could all go in mojdoc.production.conf vv
  "hypnotoad": {
    "listen": "http://*:9009",
    "max_request_size": 524288,
    // vv assuming nginx or haproxy on localhost vv
    "proxy": 1,
    "trusted_proxies": "127.0.0.1, ::1"
  }
}
```

> For more information on this topic see [The Cookbook](https://docs.mojolicious.org/Mojolicious/Guides/Cookbook).

---

## Routes

* `GET /`
  Renders the welcome page and shows a list of matching files discovered under `DOX`.

* `GET /view/*doc`
  Renders a specific Markdown file. From files within the `DOX` tree.

* `GET /health`
  Returns `OK`. Useful for health checks.

---

## Directory Structure

```
├── mojdoc              ## main application
├── mojdoc.conf         ## optional: mojdoc.conf is in .gitignore
├── private             ## optional: private is in .gitignore, you can store things here
│   ├── welcome.md      ## optional: if you wanted to override default welcome.md
│   └── dox             ## optional: default path for documents
│       └── example.md  ## (this would be one of your files)
├── public
│   ├── css
│   │   └── mojdoc.css
│   ├── favicon.svg
│   └── welcome.md      ## default included welcome.md
├── README.md           ## you are here
└── templates           ## mojolicious application templates
    ├── dox.html.ep
    ├── exception.html.ep
    ├── layouts
    │   └── mojdoc.html.ep
    ├── nodox.html.ep
    ├── not_found.html.ep
    └── sidebar.html.ep
```
