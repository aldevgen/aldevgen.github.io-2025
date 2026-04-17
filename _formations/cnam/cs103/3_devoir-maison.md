---
layout: page
type: formation
title: DM
description: Devoir Maison sur MongoDB et Apache Cassandra
category: Cnam CS103 - Introduction au NoSQL
visible: true
img:
tabs: true
mermaid:
  enabled: true
  zoomable: true
---

# Consignes

Le devoir maison est composé de deux parties sur MongoDB et Apache Cassandra. Il peut être fait binôme si vous le souhaitez.

Le format attendu est un notebook Jupyter contenant les réponses. Si vous préférez écrire un script CQL pour la partie Apache Cassandra, cela est également possible. Dans ce cas, j'attends un Notebook pour la partie MongoDB et un fichier `script.cql` pour la partie Apache Cassandra.

La date de rendu est fixée pour le dimanche 17 mai à 23 h 59 maximum.

# Partie 1

## Présentation des données

Pour ce TP, nous utiliserons les données **movies** qui contiennent des informations sur des films de différentes époques et genres.

<a class="download-btn"
    href="https://raw.githubusercontent.com/aldevgen/data/main/json/movies.json"
    download="movies.json"
    rel="noopener noreferrer">
    <button><i class="fa fa-download"></i> Données movies</button>
</a>

Le tableau, ci-dessous, présente les données ainsi qu'un exemple du format attendu

| Colonne          | Type   | Description                                                     | Exemple                                                    |
|------------------|--------|-----------------------------------------------------------------|------------------------------------------------------------|
| title            | string | Titre du film                                                   | Intolerance: Love's Struggle Throughout the Ages           |
| year             | int    | Année de sortie du film                                         | 1916                                                       |
| genres           | list   | Liste des genres du film                                        | ["Drama", "History"]                                       |
| cast             | list   | Liste des acteurs principaux                                    | ["Lillian Gish", "Spottiswoode Aitken", "Mary Alden"]      |
| directors        | list   | Liste des réalisateurs du film                                  | ["D.W. Griffith"]                                          |
| writers          | list   | Liste des scénaristes du film                                   | ["D.W. Griffith", "Anita Loos"]                            |
| countries        | list   | Liste des pays de production                                    | ["USA"]                                                    |
| languages        | list   | Langues du film                                                 | ["English"]                                                |
| plot             | string | Résumé court du film                                            | The story of a poor young woman, separated by prejudice... |
| fullplot         | string | Résumé détaillé du film                                         | Intolerance and its terrible effects are examined in...    |
| imdb.rating      | float  | Note IMDb du film                                               | 8.0                                                        |
| imdb.votes       | int    | Nombre de votes IMDb                                            | 9880                                                       |
| tomatoes.viewer.rating | float | Note des spectateurs Rotten Tomatoes                       | 3.8                                                        |
| tomatoes.viewer.numReviews | int | Nombre de critiques des spectateurs sur Rotten Tomatoes  | 4718                                                       |
| tomatoes.viewer.metter | int | Notes des critiques sur Rotten Tomatoes                      | 77                                                         |
| awards           | object | Prix du film                                                    | {"wins": 1, "nominations": 0, "text": "1 win."}            |
| type             | string | Type du contenu (film, série, etc.)                             | movie                                                      |

Voici un exemple de données :

```json
{
  "_id": {
    "$oid": "573a13e9f29313caabdcd99c"
  },
  "plot": "An imaginative children's film about a young Australian boy's passion for flight and his challenge to compete in the World Paper Plane Championships in Japan.",
  "genres": [
    "Family"
  ],
  "cast": [
    "Ed Oxenbould",
    "Sam Worthington",
    "Julian Dennison",
    "Peter Rowsthorn"
  ],
  "num_mflix_comments": 2,
  "title": "Paper Planes",
  "fullplot": "An imaginative children's film about a young Australian boy's passion for flight and his challenge to compete in the World Paper Plane Championships in Japan.",
  "languages": [
    "English"
  ],
  "released": {
    "$date": "2015-01-15T00:00:00Z"
  },
  "directors": [
    "Robert Connolly"
  ],
  "writers": [
    "Robert Connolly",
    "Steve Worland"
  ],
  "awards": {
    "wins": 1,
    "nominations": 4,
    "text": "1 win & 4 nominations."
  },
  "lastupdated": "2015-08-29 00:01:59.890000000",
  "year": 2014,
  "imdb": {
    "rating": 6.2,
    "votes": 1635,
    "id": 3328716
  },
  "countries": [
    "Australia"
  ],
  "type": "movie"
}
```

## Questions

Importez les données dans MongoDB Compass et répondez aux questions suivantes :

1. Combien de films sont dans la base de données ?
2. Combien de films ont une note IMDb supérieure à 8 ?
3. Afficher le titre et le plot des films réalisés par D.W. Griffith.
4. Quelles sont les 6 années avec le plus de films produits ?
5. Combien de films ont été réalisés avant l'année 2000 et ont une note IMDb supérieure à 7 ?


# Partie 2

Dans cette partie du TP, vous allez manipuler une base de données Apache Cassandra destinée à stocker des informations issues d’un système de suivi hospitalier.
Nous travaillerons avec deux nouveaux jeux de données : les **consultations médicales** et les **professionnels de santé**.

## Contexte

Chaque consultation correspond à une visite d’un patient chez un professionnel de santé.
Les consultations contiennent des informations médicales ainsi que des données sur le praticien.

## 1. Modélisation des données

### Table `consultations`

| Colonne             | Description                           |
| ------------------- | ------------------------------------- |
| `consultation_id`   | Identifiant unique de la consultation |
| `patient_id`        | Identifiant du patient                |
| `medecin_id`        | Identifiant du professionnel de santé |
| `date_consultation` | Date de la consultation               |
| `specialite`        | Spécialité du médecin                 |
| `diagnostic`        | Diagnostic posé                       |
| `traitement`        | Traitement prescrit                   |
| `region`            | Région de la consultation             |

---

### Table `medecins`

| Colonne         | Description                  |
| --------------- | ---------------------------- |
| `id`            | Identifiant du médecin       |
| `nom`           | Nom du médecin               |
| `prenom`        | Prénom du médecin            |
| `specialite`    | Spécialité                   |
| `annee_diplome` | Année d’obtention du diplôme |
| `regions`       | Liste des régions d’exercice |

## 2. Travail demandé

### 1 - Création du keyspace

Créez un keyspace nommé `sante_systeme` avec un facteur de réplication de 1.

### 2 - Création des tables

Créez les tables `consultations` et `medecins` en respectant les structures décrites ci-dessus.

> Vous choisirez judicieusement les clés primaires en fonction des futures requêtes.

### 3 - Insertion de données

Insérez les données suivantes :

Dans la table `consultations`

| consultation_id | patient_id | medecin_id | date_consultation | specialite  | diagnostic   | traitement     | region        |
| --------------- | ---------- | ---------- | ----------------- | ----------- | ------------ | -------------- | ------------- |
| c1023           | p88        | m12        | 2024-03-15        | Cardiologie | Hypertension | Bêta-bloquants | Île-de-France |

Dans la table `medecins`

| id  | nom    | prenom | specialite  | annee_diplome | regions                        |
| --- | ------ | ------ | ----------- | ------------- | ------------------------------ |
| m12 | Durand | Sophie | Cardiologie | 2010          | ['Île-de-France', 'Normandie'] |

### 4 - Requêtage des données

4.1 Affichez les consultations du patient `p88`.
La requête est-elle valide avec votre modèle ? Justifiez.

4.2 Modifiez le traitement de la consultation `c1023` pour remplacer *Bêta-bloquants* par *Inhibiteurs calciques*.

4.3 Supprimez la consultation `c1023`.

### 5 - Conception orientée requêtes

On souhaite répondre efficacement à la question suivante : comment trouver toutes les consultations réalisées par spécialité dans une région donnée, triées par date ?

1. Proposez une **nouvelle table adaptée** à cette requête.
2. Définissez sa structure (colonnes + clé primaire).
3. Expliquez vos choix de modélisation (partition key, clustering columns).
