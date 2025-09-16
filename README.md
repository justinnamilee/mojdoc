# Mojolicious Markdown Docs Viewer

A tiny Mojolicious::Lite app that serves and renders a folder (and subfolders) of Markdown files.

---

## Features

* Renders `.md` / `.markdown` files (recursively) from a docs folder
* GitHub-style fenced code blocks (`lang … `) and Syntax via `highlight.js`
* Pluggable Markdown backends (first found wins):
  `Text::MultiMarkdown` → `Text::Markdown` → `Markdown::Tiny` → fallback to `<pre>`
* Safe path resolution (prevents path traversal)
* Code written by someone with zero Mojolicious experience

---

## Quickstart

```bash
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

You can configure via a `Config` plugin file (e.g. `mojdoc.conf`) **or** environment variables. Defaults are shown below.

|   Setting | Env Var          | Default                           | What it does                     |
| --------: | ---------------- | --------------------------------- | -------------------------------- |
|   `badge` | `MOJDOC_BADGE`   | `cyber-docs`                      | Label used by the template UI.   |
|     `dox` | `MOJDOC_DOX`     | `private/dox`                     | Root folder to scan for docs.    |
| `welcome` | `MOJDOC_WELCOME` | `public/welcome.md`               | Welcome file rendered on `/`.    |

Example `mojdoc.conf` that would be read by morbo or hypnotoad:

```json
{
  "badge": "super-secret-dox",
  "dox": "/var/www/secure/dox",
  "welcome": "/var/www/secure/welcome.md"
}
```

> The app logs a warning if the `DOX` folder is missing and if the `WELCOME` file can’t be found, but will keep running.

---

## Routes

* `GET /`
  Renders the welcome page and shows a file list discovered under `DOX`.

* `GET /view/*doc`
  Renders a specific Markdown file. Only files within the `DOX` tree are allowed.

* `GET /health`
  Returns `OK`. Useful for health checks.

---

## Directory Structure

```
├── mojdoc
├── mojdoc.conf         ## optional mojdoc.conf is in .gitignore
├── private             ## optional private is in .gitignore
│   ├── welcome.md      ## optional if you wanted to override default welcome.md
│   └── dox             ## default path for documents
│       └── example.md  ## this would be one of your files
├── public
│   ├── css
│   │   └── mojdoc.css
│   ├── favicon.svg
│   └── welcome.md      ## default included welcome.md
├── README.md
└── templates
    ├── dox.html.ep
    ├── layouts
    │   └── mojdoc.html.ep
    ├── nodox.html.ep
    └── sidebar.html.ep
```
