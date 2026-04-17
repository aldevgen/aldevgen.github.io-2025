---
layout: page
title: Formations
permalink: /formations/
description: >
  Ressources pédagogiques pour les étudiants du BUT Science des Données
  et les auditeurs du certificat CS103 Intelligence Artificielle en Santé du Cnam
nav: true
nav_order: 1
display_categories: [
#  "Prérequis",
#  "Versionnage avec git",
  "BUT 2 - Programmation Orientée Objet en Python",
#  "BUT 3 - Des bases de données distribuées au NoSQL",
#  "BUT 3 - SAÉ migration vers NoSQL",
  "Cnam CS103 - Introduction au NoSQL"
]
horizontal: false
---

<!-- pages/formations.md -->
<div class="projects">
{% if site.enable_project_categories and page.display_categories %}
  <!-- Display categorized formations -->
  {% for category in page.display_categories %}
  <a id="{{ category }}" href=".#{{ category }}">
    <h2 class="category">{{ category }}</h2>
  </a>
  {% assign categorized_projects = site.formations | where: "category", category %}
  {% assign sorted_projects = categorized_projects | sort: "importance" %}
  <!-- Generate cards for each project -->
  {% if page.horizontal %}
  <div class="container">
    <div class="row row-cols-1 row-cols-md-2">
    {% for project in sorted_projects %}
      {% include projects_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="row row-cols-1 row-cols-md-3">
    {% for project in sorted_projects %}
      {% include formations.liquid %}
    {% endfor %}
  </div>
  {% endif %}
  {% endfor %}

{% else %}

<!-- Display formations without categories -->

{% assign sorted_projects = site.formations | sort: "importance" %}

  <!-- Generate cards for each project -->

{% if page.horizontal %}

  <div class="container">
    <div class="row row-cols-1 row-cols-md-2">
    {% for project in sorted_projects %}
      {% include projects_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="row row-cols-1 row-cols-md-3">
    {% for project in sorted_projects %}
      {% include formations.liquid %}
    {% endfor %}
  </div>
  {% endif %}
{% endif %}
</div>
