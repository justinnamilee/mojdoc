# 👋 Welcome to **MOJDOC**

* **A simple Markdown document viewer powered by [Mojolicious](https://mojolicious.org).**
* Important Settings:
  * Most settings can be changed with environmental variables (see [GitHub](https://github.com/justinnamilee/mojdoc)).
  * Drop docs into **`./private/dox`** (or change path with `MOJDOC_DOX="/var/www/docs"`).
  * Change the badge in the top right with `MOJDOC_BADGE="my-cool-badge"`.
* Available Routes:
  * `/` — welcome page
  * `/view/<file>` — render a document
  * `/health` — status check
* Markdown Parsers:
  * MojDoc will try **Text::MultiMarkdown** first,
  * then **Text::Markdown**,
  * then **Markdown::Tiny**,
  * before finally just using `<pre>` tags.

---

✨ Replace this page (`public/welcome.md`) with your own file using `MOJDOC_WELCOME=/var/www/welcome.md`.

---

> Happy documenting!
