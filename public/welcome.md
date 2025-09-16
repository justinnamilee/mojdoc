# Welcome to **MOJDOC**

A tiny, no-fuss Markdown docs viewer. Drop `.md` files into your docs folder, click in the sidebar, and read.

---

## Quick start

1. Put your docs under the **dox folder** (see below).
2. Run the app.
3. Click a file in the sidebar.

See [GitHub](https://github.com/justinnamilee/mojdoc) for more details.

---

## Docs root (where files live)

MOJDOC looks for your docs directory in this order:

1. `dox` in `mojdoc.conf` (if present)
2. `$ENV{MOJDOC_DOX}`
3. `./private/dox`

**Examples**

```bash
# Dev with auto-reload
morbo mojdoc -l http://*:3000

# Simple daemon on a different port
MOJO_LISTEN=http://172.31.29.50:4000 perl mojdoc daemon

# Production (setup your mojdoc.conf)
hypnotoad mojdoc
```

To pin the docs folder and production settings, create `mojdoc.conf` next to `mojdoc`:

```perl
{
  dox => "/absolute/path/to/public/dox",
  hypnotoad  => { listen => ["http://*:8080"], workers => 2 },
  # welcome => "WELCOME.md"   # optional: which file to show on "/"
  # banner => "My Documents"   # optional: which banner to show on "/" and "/view"
}
```

---

## Notes & troubleshooting

* **Security:** Paths are resolved under the docs root; traversal outside is blocked.
* **“Not Found”:** Ensure the file exists under the docs root and the path is correct (case-sensitive on most UNIX filesystems).
* **CSP errors:** Check the browser console and adjust your CSP or move inline scripts to files.

---

Happy documenting!
