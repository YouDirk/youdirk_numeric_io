---
permalink: /test/
---

## All forge builds

{% for build in site.data.forge_builds %}
-----
{{ build }}
-----
{% endfor %}
