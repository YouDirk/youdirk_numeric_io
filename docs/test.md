---
permalink: /test/
---

## All forge builds

{% assign builds_ordered = site.data.forge_builds | sort: 0, "last" %}
{{ builds_ordered }}

{% for build_hash in site.data.forge_builds %}
{% assign build = build_hash[1] %}

* **Minecraft Forge build version {{ build.mf_version }}**  
  *{{ build.time | date: "%a, %e. %b %Y %R %z" }} for Minecraft {{
    build.mc_version
  }}*
  - **[Download Installer {{ build.jar_installer.name }}]({{
    site.numeric_io.github_maven_url }}/{{ build.jar_installer.maven-url
    }})**  
    `sha1sum: {% include_relative {{ site.numeric_io.maven_path }}/{{
      build.jar_installer.maven-sha1
    }} %}`
  - **[Download Universal {{ build.jar_universal.name }}]({{
    site.numeric_io.github_maven_url }}/{{ build.jar_universal.maven-url
    }})**  
    `sha1sum: {% include_relative {{ site.numeric_io.maven_path }}/{{
      build.jar_universal.maven-sha1
    }} %}`

        Changelog
        *********
        
        {% for line in build.changelog %}{{ line }}
        {% endfor %}
{% endfor %}

```
Hello Worl

this is a test

blaaah ...
```
