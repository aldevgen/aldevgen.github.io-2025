---
layout: page
type: formation
title: Contexte
description: Présentation des données
category: BUT 3 - SAÉ migration vers NoSQL
visible: true
img:
tabs: true
mermaid:
  enabled: true
  zoomable: true
---

## :car: Contexte

La directrice d'une entreprise de voitures, Paula DUPONT, veut opérer une migration depuis une base de données relationnelle vers une base de données NoSQL. En effet, la BDD actuelle commence à présenter des limites : requête avec forte latence, perte de données dues à des défaillances serveur (qui arrivent de plus en plus fréquement), etc.

Paula DUPONT vous missionne pour opérer la migration vers une base de données NoSQL. Pour cela elle vous met à disposition son jeu de données nommé `ClassicModel`.

## Méthodologie

Pour cette SAÉ, l'objectif est de procéder suivant la méthodologie décrite ci-dessous :

1. Création de requêtes SQL sur la BD initiale ;
2. Réflexion sur le format des données à obtenir et l’algorithme à réaliser ;
3. Écriture du script Python permettant le passage de SQLite à NoSQL ;
4. S’assurer que la migration s’est bien passée.
