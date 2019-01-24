---
permalink: /test/
---

## All forge builds

{% for build_hash in site.data.forge_builds %}
-------
{{ build_hash }}
-------
{% assign build = build_hash[1] %}
{{ build }}
-------

{% endfor %}
