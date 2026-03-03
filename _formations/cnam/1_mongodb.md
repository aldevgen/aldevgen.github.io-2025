---
layout: page
title: TP1
description: Introduction à MongoDB
importance: 0
category: "Cnam CS103 - Bases de données à grande échelle"
permalink: /cnam/mongodb
type: formation
visible: true
mermaid:
  enabled: true
  zoomable: true
---

# Installation et configuration MongoDB

## Configuration de la base de données

### Création du compte Atlas

Nous allons créer un [compte Atlas](https://account.mongodb.com/account/register?signedOut=true) afin de pouvoir héberger une base de données MongoDB.

### Création d'un projet Atlas

Une fois que vous avez créé votre compte vous allez pouvoir créer un projet, nommé `cnam` ici. Ensuite, une page demandera d'ajouter des membres, il n'y a rien à faire. Confirmez simplement la création du projet en cliquant sur **Create project**.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/creation-project.png" title="Creation project" class="img-fluid rounded z-depth-1" %}

### Création d'un utilisateur Atlas

Une fois ceci fait on aura besoin de créer un utilisateur, afin de pouvoir requêter la base de données. Pour cela, dans le menu à gauche, cliquez sur **Database access**.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/create-user.png" title="Create user" class="img-fluid rounded z-depth-1" %}

Une fois sur la page des **Database access** cliquez sur **Add new database user** afin d'ajouter un utilisateur de la base de données. Cela ouvrira un nouvel onglet comme ci-dessous. Il faudra ainsi définir son nom, son mot de passe et son rôle. Dans notre cas, nous appelerons notre utilisateur `user_mongo` et nous générerons le mot de passe aléatoirement en cliquant sur **Autogenerate Secure Password**. Enfin, nous lui assignerons le rôle d'administrateur Atlas.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/creation-user.png" title="Creation user" class="img-fluid rounded z-depth-1" %}

> :warning: Pensez à bien enregistrer le mot de passe dans un endroit sécurisé de votre ordinateur, nous en aurons besoin par la suite pour nous connecter à la base de données.
>
{: .block-warning }

Une fois ceci fait vous aurez la vue suivante :

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/user-created.png" title="User created" class="img-fluid rounded z-depth-1" %}

### Création d'un cluster Atlas

Maintenant nous pouvons créer un cluster qui hébergera notre base de données.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/create-cluster.png" title="Create cluster" class="img-fluid rounded z-depth-1" %}

Nous prenons l'instance M0 qui est gratuite et donnons un nom à cette dernière, ici `cluster-but-sd`. Il n'y a pas besoin de changer les autres paramètres.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/creation-cluster.png" title="Creation cluster" class="img-fluid rounded z-depth-1" %}

### Connexion au cluster Atlas

Enfin, la dernière étape consiste à choisir le connecteur à la base de données. Dans notre cas, nous utiliserons l'API Python donc nous sélectionnons **Drivers**.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/connection-method.png" title="Connection method" class="img-fluid rounded z-depth-1" %}

Sur la page suivante nous pouvons choisir le type de Driver, Python dans notre cas.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/mongodb-driver.png" title="MongoDB driver" class="img-fluid rounded z-depth-1" %}

> Copiez la *connection string*, cela nous servira ensuite à nous connecter en Python à la base de données que nous venons de créer.
>
{: .block-example }

## Installation de MongoDB Compass

Pour visualiser les données de notre base de données, nous allons installer [MongoDB Compass](https://www.mongodb.com/try/download/compass). Pour cela, cliquez sur le lien et suivez les instructions d'installation selon votre OS.

## Connexion à MongoDB Compass

Maintenant nous allons pouvoir utiliser le cluster créé sur Atlas. Commençons par se connecter à notre instance.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/compass-connection.png" title="Compass connection" class="img-fluid rounded z-depth-1" %}

La connexion va se faire via la *connection string* qui peut être trouvée dans la configuration du cluster Atlas.

> :warning: N'oubliez pas de remplacer le mot de passe sur l'image ci-dessous par celui que vous avez enregistré plus haut et de remplacer `mon_super_mot_de_passe_genere` dans `mongodb+srv://user_mongo:mon_super_mot_de_passe_genere@cluster-cnam.douiht4.mongodb.net/?appName=cluster-cnam` (sans les <>).
{: .block-warning }

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/compass-add-connection.png" title="Compass add connection" class="img-fluid rounded z-depth-1" %}

Une fois ceci fait, nous allons créer une base de données appelée `tp` qui contiendra une collection nommée `pathologies`.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/create-database-collection.png" title="Create database collection" class="img-fluid rounded z-depth-1" %}
{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/create-database.png" title="Create database" class="img-fluid rounded z-depth-1" %}

## Import des données

Ensuite, il suffit d'importer le fichier JSON qui se situe [ici](https://github.com/aldevgen/data/blob/main/Pathologies/pathologies.json).

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/import-data.png" title="Import data" class="img-fluid rounded z-depth-1" %}

Les données sont issues de la base de données [Caisse nationale de l'Assurance Maladie (Cnam)](https://www.data.gouv.fr/datasets/pathologies-effectif-de-patients-par-pathologie-sexe-classe-dage-et-territoire-departement-region/informations). Seules 8000 lignes ont été importées pour des raisons de temps de traitement, car la base de données d'origine représente 2 Go de données.

## Interrogation des données MongoDB en Python

Pour requêter les données dans notre base de données, nous allons utiliser le package [`pymongo`](https://docs.mongodb.com/drivers/pymongo/). Pour l'installer, il faut exécuter la commande dans un terminal :

```bash
pip install pymongo
```

Et voilà, vous êtes prêts à requêter les données ! :tada:

# Modèle des données MongoDB

Le principe de base de MongoDB repose sur la représentation des données qui sont modélisées sous la forme de `documents`.

- Stocké en *Binary JSON* (`BSON`).
- Documents similaires rassemblés dans des `collections` : au sein d'une base de données, il peut y avoir plusieurs collections.
- Pas de schéma des documents définis en amont (contrairement à une BD relationnel ou une BD NoSQL de type *Column*).
- Les documents peuvent n'avoir aucun point commun entre eux.
- Un document contient (généralement) l'ensemble des informations.
- Idéalement il n'y a pas (ou très peu) de jointure à faire.
- MongoDB respecte les propriétés **CP** dans le théorème *CAP*.
- Au niveau d'un document, les propriétés ACID sont généralement respectées.

## Format `JSON`

- Le format de données `JSON` a été créé en 2005 et signifie `JavaScript Object Notation`.
- C'est un format léger d'échange de données structurées.
- Le schéma des données n'est pas connu (contenu dans les données)
- Basé sur deux notions :
	- collection de couples clé/valeur
	- liste de valeurs ordonnées
- Structures possibles :
	- objet (couples clé/valeur) : `{"nom": "dupont", "prenom": "jeanne"}`
	- tableau (collection de valeurs) : `[1, 5, 10]`
	- une valeur dans un objet ou dans un tableau peut être elle-même un littéral
- Deux types atomiques (`string` et `number`) et trois constantes (`true`, `false`, `null`)

Vous pouvez valider la structure d'un JSON sur [jsonlint.com/](http://jsonlint.com/)

### Exemple de `JSON`

```json
{
  "_id": {
    "$oid": "69a6c5d9b831adc7bd251641"
  },
  "annee": "2023",
  "patho_niv1": "Maladies cardioneurovasculaires",
  "patho_niv2": "Troubles du rythme ou de la conduction cardiaque",
  "patho_niv3": "Troubles du rythme ou de la conduction cardiaque",
  "top": "MCV_TRC_IND",
  "cla_age_5": "45-49",
  "sexe": "9",
  "region": "53",
  "dept": "22",
  "ntop": 210,
  "npop": 34660,
  "prev": 0.603,
  "niveau_prioritaire": [
    "2",
    "3"
  ],
  "libelle_classe_age": "de 45 à 49 ans",
  "libelle_sexe": "tous sexes",
  "tri": 32
}
```

# Requêtage avec MongoDB

Les données `JSON` sont similaires à un dictionnaire `Python`. Pour récupérer le premier document, nous utilisons la fonction `find()` de l'objet créé `first_doc`.

```python
first_doc = db.collection_name.find(limit = 1)
```

> Dans notre cas, `collection_name` correspond à `pathologies` et `db` correspond à la base de données `tp` que nous avons créée précédemment.
>
{: .block-example }

L'objet retourné est un **curseur**, et non le résultat. Nous avons celui-ci lorsque nous utilisons `first_doc` dans une commande telle qu'une transformation en `list` par exemple.

```python
list(first_doc)
```

Une fois le résultat retourné (un seul élément ici), le curseur ne renvoie plus rien.

```python
list(first_doc)
```

## Dénombrement

La fonction `count_documents({})` permet de dénombrer les documents présents dans la collection.

```python
db.collection_name.count_documents({})
```
La fonction `estimated_document_count()` permet d'estimer le nombre de documents, cela est particulièrement utile lorsque la base de données
est déployée sur plusieurs servers avec une grande quantité de données et qu'une estimation précise du volume de données n'est pas nécessaire.

```python
db.collection_name.estimated_document_count()
```

## Sélection de documents

Pour sélectionner les documents, nous allons utiliser le paramètre dans la fonction `count_documents()` (ainsi que dans les fonctions `distinct()` et `find()` que nous verrons plus tard).

- `{}` : tous les documents
- `{ "champs": valeur }` : documents ayant cette valeur pour ce champs
- `{ condition1, condition2 }` : documents remplissant la condition 1 **ET** la condition 2
- `"champs.sous_champs"` : permet d'accéder donc à un sous-champs d'un champs (que celui-ci soit un littéral ou un tableau)
- `{ "champs": { "$opérateur": expression }}` : utilisation d'opérateurs dans la recherche
    - `$in` : comparaison à un ensemble de valeurs
    - `$gt`, `$gte`, `$lt`, `$lte`, `$ne` : comparaison (resp. *greater than*, *greater than or equal*, *less than*, *less than or equal*, *not equal*)

### Comptage de certains documents

> Les requêtes ci-dessous sont des exemples de requêtes sur une base de données fictive `students` à propos des étudiants et des cours qu'ils suivent à l'université.
>
{: .block-example }

- Nombre d'étudiants de l'Université de Paris

```python
db.students.count_documents({ "university": "Université de Paris" })
```

- Nombre d'étudiants de l'Université de Paris ayant suivi le cours de NoSQL

```python
db.students.count_documents({ "university": "Université de Paris", "course": "NoSQL" })
```

-  Nombre d'étudiants de l'Université de Paris ayant suivi le cours de NoSQL ou de Python

```python
db.students.count_documents(
  {
    "university": "Université de Paris",
    "course": { "$in": ["NoSQL", "Python"]}
  }
)
```

- Nombre d'étudiants qui vivent Boulevard des Capucines

```python
db.students.count_documents(
  {
    "address.street": "Boulevard des Capucines"
  }
)
```

- Étudiants.es ayant eu une note moyenne de 10

```python
db.students.count_documents(
  {
    "grades.average": 10
  }
)
```
Ici le champ `average` est inclus dans `grades` autrement dit, nous avons la structure de données suivante :
```json
{
    "grades" : [
      {
        "average" : 10,
        "min" : 8,
        "max" : 16,
      }
    ],
    "..." : "..."
}
```

- Étudiants.es ayant eu une note moyenne inférieure à 8

```python
db.students.count_documents(
  {
    "grades.average":{ "$lte": 8 }
  }
)
```

### Valeurs distinctes

On peut aussi voir la liste des valeurs distinctes d'un attribut, avec la fonction `distinct()`.

- Nombre de cours différents enseignés dans toutes les universités

```python
db.collection_name.distinct(key = "course")
```

- Nombre de cours enseignés à l'Université de Paris

```python
db.collection_name.distinct(
  key = "course",
  query = { "university": "Université de Paris" }
)
```

### Restriction et Projection

- Fonction `find()` pour réaliser les *restrictions* et *projections*
- Plusieurs paramètres :
    - Restriction (quels documents prendre) : même format que précédemment
    - Projection (quels champs afficher)
    - `limit` pour n'avoir que les $n$ premiers documents
    - `sort` pour effectuer un tri des documents
- PyMongo renvoi un curseur, qu'il faut donc gérer pour avoir le résultat
- Transformation en `DataFrame` (du module `pandas`)
  - Ce format n'est pas forcément idéal pour certains champs, notamment ceux imbriqués.

### Sélection de champs à afficher ou non

Dans la fonction `find()`, pour choisir les champs à afficher, le deuxième paramètre permet de faire une projection avec les critères suivants :

- sans précision, l'identifiant interne est toujours affiché (`_id`)
- `{ "champs": 1 }` : champs à afficher
- `{ "champs": 0 }` : champs à ne pas afficher
- Pas de mélange des 2 sauf pour l'identifiant interne à MongoDB (`_id`)
    - `{ "_id": 0, "champs": 1, ...}`

### Tri et limites

Toujours dans la fonction `find()`, il est possible de faire le tri des documents, avec le paramètre `sort` qui prend un tuple composé d'un ou plusieurs tuples indiquant les critères de tri.

- `( "champs", 1 )` : tri croissant
- `( "champs", -1 )` : tri décroissant
- plusieurs critères de tri possibles (dans les 2 sens)

Dans ces fonctions, on peut aussi limiter l'exploration à une partie, avec les paramètres suivant :

- `limit` : restreint le nombre de résultats fournis
- `skip` : ne considère pas les *n* premiers documents

### Récupération des 5 premiers documents

Notez le contenu des colonnes `address` et `grades`.

```python
import pandas as pd
pd.DataFrame(list(db.collection_name.find(limit = 5)))
```

### Exemples

- Cours de NoSQL (uniquement les attributs `"name"` et `"surname"`)

```python
nosql_students = db.collection_name.find(
    { "course": "NoSQL" },
    { "student.name": 1, "student.surname": 1 }
)
pd.DataFrame(list(nosql_students))
```

- Idem sans l'identifiant interne

```python
nosql_students = db.collection_name.find(
    { "course": "NoSQL" },
    { "_id": 0, "student.name": 1, "student.surname": 1 }
)
pd.DataFrame(list(nosql_students))
```

- 5 meilleures notes de l'évaluation de NoSQL, supérieures à 15 (on affiche le nom et le prénom de l'étudiant)

```python
first_grades = db.collection_name.find(
    { "course": "NoSQL", "grades.score": { "$gte":  15}},
    { "_id": 0, "student.name": 1, "student.surname": 1 }
    limit = 5
)
pd.DataFrame(list(first_grades))
```

- Étudiants du cours de NoSQL, ayant une note supérieure à 12, trié par ordre décroissant des notes et ordre croissant du nom de famille (on affiche le nom et le prénom de l'étudiant).

```python
sorted = db.collection_name.find(
    { "course": "NoSQL", "grades.score": { "$gte":  12}},
    {"_id": 0, "student.name": 1, "student.surname": 1 },
    sort = (("grades.score", -1), ("student.surname", 1))
)
pd.DataFrame(list(c))
```

## Connexion à la base de données

Maintenant que tout est mis en place nous pouvons nous connecter à la base de données que nous avons créé.

```python
import pymongo

# Remplacer l'URI par celle récupéree sur Atlas, en n'oubliant pas de remplacer le mot de passe
URI = 'mongodb+srv://<user_name>:<password>@<cluster_name>.zrugz.mongodb.net/?retryWrites=true&w=majority&appName=<cluster_name>'
client = pymongo.MongoClient(URI)
db = client.tp

# output the name of the collections in the database
print("Collections: ", tp.list_collection_names())
print("Pathologies: ", tp.pathologies)
```

## A faire

1. Lister toutes les catégories de pathologies de niveau 1
2. Lister toutes les catégories de pathologies de niveau 2
3. Compter le nombre de documents concernant les "Maladies cardioneurovasculaires"
4. Compter le nombre de documents concernant la tranche d'âge "45-49 ans"
5. Compter le nombre de documents où la prévalence (prev) est supérieure à 0.2
6. Lister tous les documents, en n'affichant que l'année, la pathologie de niveau 1, la région et le département
7. Lister toutes les pathologies de niveau 3 pour les femmes (sexe=2), en affichant seulement la pathologie et la classe d'âge
8. Lister les pathologies pour les régions "32" ou "44", en affichant la pathologie de niveau 1, le département et la prévalence
9. Lister les pathologies où le niveau prioritaire contient "2", en affichant la pathologie de niveau 2, la région et le niveau prioritaire
10. Lister les pathologies où la prévalence est nulle (prev=null), en affichant la pathologie de niveau 3, la région et le département

# Agrégats dans MongoDB

Il est bien évidemment possible de réaliser des calculs d'agrégats (de type somme, moyenne, minimum et maximum) dans MongoDB, avec la fonction `aggregate()`. Celle-ci permet beaucoup d'autres opérations.

## Fonctions possibles

Cette fonction va prendre en paramètre un tableau nommé `pipeline` : tableau composé d'une suite d'opérations.

> Chaque opération sera faite après la précédente. L'ordre des opérations a donc une importance cruciale. Et le même opérateur
peut apparaître plusieurs fois.

Voici quelques unes des opérations possibles :

| Fonction       | Opération |
|-|-|
| `$limit`       | restriction à un petit nombre de documents (très utiles pour tester son calcul) |
| `$sort`        | tri sur les documents |
| `$match`       | restriction sur les documents à utiliser |
| `$unwind`      | séparation d'un document en plusieurs sur la base d'un tableau |
| `$addFields`   | ajout d'un champs dans les documents |
| `$project`     | redéfinition des documents |
| `$group`       | regroupements et calculs d'aggégrats |
| `$sortByCount` | agrégat + tri |
| `$lookup`      | jointure avec une autre collection |
| ...            | |

## Syntaxe des opérations dans le `pipeline`

### `$limit`

On indique juste avec un entier le nombre de document que l'on veut afficher.

- Limite aux 10 premiers restaurants

```python
first10 = db.restaurants.aggregate([
    { "$limit": 10 }
])
pandas.DataFrame(list(first10))
```

### `$sort`

On indique de façon identique à celle du paramètre `sort` de la fonction `find()`

- Idem avec tri sur le nom du restaurant

```python
first10_sorted_name = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$sort": { "name": 1 }}
])
pandas.DataFrame(list(first10_sorted_name))
```

### `$match`

Ici, c'est identique à celle du paramètre `query` des autres fonctions

- Idem en se restreignant à *Brooklyn*
    - Notez que nous obtenons uniquement 5 restaurants au final

```python
brooklyn = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$sort": { "name": 1 }},
    { "$match": { "borough": "Brooklyn" }}
])
pandas.DataFrame(list(brooklyn))
```

- Mêmes opérations mais avec la restriction en amont de la limite
    - Nous avons ici les 10 premiers restaurants de *Brooklyn* donc

```python
c = db.restaurants.aggregate([
    { "$match": { "borough": "Brooklyn" }},
    { "$limit": 10 },
    { "$sort": { "name": 1 }}
])
pandas.DataFrame(list(c))
```

### `"$unwind"`

Le but de cette opération est d'**exploser** un tableau dans un document.

> Un document avec un tableau à *n* éléments deviendra *n* documents avec chacun un des éléments du tableau en lieu et place de celui-ci

Nous devons mettre le nom du tableau servant de base pour le découpage (précédé d'un `$`)

- Séparation des 10 premiers restaurants sur la base des évaluations (`grades`)
    - Chaque ligne correspond maintenant a une évaluation pour un restaurant

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$unwind": "$grades" }
])
pandas.DataFrame(list(c))
```

- Idem précédemment, en se restreignant à celle ayant eu *B*

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$unwind": "$grades" },
    { "$match": { "grades.grade": "B" }}
])
pandas.DataFrame(list(c))
```

- Si on inverse les opérations `$unwind` et `$match`, le résultat est clairement différent

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$match": { "grades.grade": "B" }},
    { "$unwind": "$grades" }
])
pandas.DataFrame(list(c))
```

### `"$addFields"` et  `"$project"`

On souhaite ici rédéfinir les documents en ajoutant des éléments (`$addFields`) ou en se restreignant à certains éléments
(`$project`)

- `{ "champs" : 1 }` : conservation du champs (0 si suppression - idem que dans `find()`, pas de mélange sauf pour `_id`)
    - valable uniquement dans `$project`
- `{ "champs": { "$opérateur" : expression }}` : permet de définir un nouveau champs
- `{ "nouveau_champs": "$ancien_champs" }` : renommage d'un champs

Quelques opérateurs utiles pour la projection (plus d'info [ici](https://docs.mongodb.com/manual/reference/operator/aggregation/))

- `$arrayElemAt` : élément d'un tableau
- `$first` : premier élément du tableau
- `$last` : dernier élément du tableau
- `$size` : taille d'un tableau
- `$substr` : sous-chaîne de caractères
- `$cond` : permet de faire une condition (équivalent de *if then else*)
- ...


- On peut aussi vouloir ajouter un champs, comme ici le nombre d'évaluations

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$addFields": { "nb_grades": { "$size": "$grades" } } }
])
pandas.DataFrame(list(c))
```

- On souhaite ici ne garder que le nom et le quartier des 10 premiers restaurants
    - Notez l'ordre (alphabétique) des variables, et pas celui de la déclaration

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": { "name": 1, "borough": 1 } }
])
pandas.DataFrame(list(c))
```

- Ici, on supprime l'adresse et les évaluations

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": { "address": 0, "grades": 0 } }
])
pandas.DataFrame(list(c))
```

- En plus du nom et du quartier, on récupère l'adresse mais dans un nouveau champs

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": { "name": 1, "borough": 1 , "street": "$address.street"} }
])
pandas.DataFrame(list(c))
```

- On ajoute le nombre de visites pour chaque restaurant (donc la taille du tableau `grades`)

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": { "name": 1, "borough": 1, "nb_grades": { "$size": "$grades" } } }
])
pandas.DataFrame(list(c))
```

- On trie ce résultat par nombre de visites, et on affiche les 10 premiers

Notez qu'il y a des restaurants sans visite donc (pour lesquels `grades` est présent mais égal à `NULL`). Dans l'idéal, ces restaurants ne devraient pas avoir de champs `grades`.

```python
c = db.restaurants.aggregate([
    { "$project": { "name": 1, "borough": 1, "nb_grades": { "$size": "$grades" } } },
    { "$sort": { "nb_grades": 1 }},
    { "$limit": 10 }
])
pandas.DataFrame(list(c))
```

- On ne garde maintenant que le premier élément du tableau `grades` (à l'indice 0)

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": { "name": 1, "borough": 1, "grade": { "$arrayElemAt": [ "$grades", 0 ]} } }
])
pandas.DataFrame(list(c))
```

- On peut aussi faire des opérations sur les chaînes, tel que la mise en majuscule du nom

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": { "nom": { "$toUpper": "$name" }, "borough": 1 } }
])
pandas.DataFrame(list(c))
```

- On extrait ici les trois premières lettres du quartier

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": {
        "nom": { "$toUpper": "$name" },
        "quartier": { "$substr": [ "$borough", 0, 3 ] }
    } }
])
pandas.DataFrame(list(c))
```

- On fait de même, mais on met en majuscule et on note *BRX* pour le *Bronx*
    - on garde le quartier d'origine pour vérification ici

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$addFields": { "quartier": { "$toUpper": { "$substr": [ "$borough", 0, 3 ] } } }},
    { "$project": {
        "nom": { "$toUpper": "$name" },
        "quartier": { "$cond": { "if": { "$eq": ["$borough", "Bronx"] }, "then": "BRX", "else": "$quartier" } },
        "borough": 1
    } }
])
pandas.DataFrame(list(c))
```

### `"$group"`

Cet opérateur permet le calcul d'agrégats tel qu'on le connaît.

- `_id` : déclaration du critère de regroupement
    - chaîne de caractères : pas de regroupement (tous les documents)
    - `$champs` : regroupement selon ce champs
    - `{ "a1": "$champs1", ... }` : regroupement multiple (avec modification des valeurs possible)
- Calculs d'agrégats à faire :
    - `$sum` : somme (soit de valeur fixe - 1 pour faire un décompte donc, soit d'un champs spécifique)
    - `$avg, $min, $max`
    - `$addToSet` : regroupement des valeurs distinctes d'un champs dans un tableau
    - `$push` : aggrégation de champs dans un tableau

- On calcule ici le nombre total de restaurants

```python
c = db.restaurants.aggregate([
    { "$group": { "_id": "Total", "NbRestos": { "$sum": 1 }}}
])
pandas.DataFrame(list(c))
```

- On fait de même, mais par quartier

```python
c = db.restaurants.aggregate([
    { "$group": { "_id": "$borough", "NbRestos": { "$sum": 1 }}}
])
pandas.DataFrame(list(c))
```

- Pour faire le calcul des notes moyennes des restaurants du *Queens*, on exécute le code suivant

```python
c = db.restaurants.aggregate([
    { "$match": { "borough": "Queens" }},
    { "$unwind": "$grades" },
    { "$group": { "_id": "null", "score": { "$avg": "$grades.score" }}}
])
pandas.DataFrame(list(c))
```

-  Il est bien évidemment possible de faire ce calcul par quartier et de les trier selon les notes obtenues (dans l'ordre décroissant)

```python
c = db.restaurants.aggregate([
    { "$unwind": "$grades" },
    { "$group": { "_id": "$borough", "score": { "$avg": "$grades.score" }}},
    { "$sort": { "score": -1 }}
])
pandas.DataFrame(list(c))
```

- On peut aussi faire un regroupement par quartier et par rue (en ne prenant que la première évaluation - qui est la dernière en date a priori), pour afficher les 10 rues où on mange le plus sainement
    - Notez que le premier `$match` permet de supprimer les restaurants sans évaluations (ce qui engendrerait des moyennes = `NA`)

```python
c = db.restaurants.aggregate([
    { "$project": {
        "borough": 1, "street": "$address.street",
        "eval": { "$arrayElemAt": [ "$grades", 0 ]}
    } },
    { "$match": { "eval": { "$exists": True } } },
    { "$match": { "eval.score": { "$gte": 0 } } },
    { "$group": {
        "_id": { "quartier": "$borough", "rue": "$street" },
        "score": { "$avg": "$eval.score" }
    }},
    { "$sort": { "score": 1 }},
    { "$limit": 10 }
])
pandas.DataFrame(list(c))
```

- Pour comprendre la différence entre `$addToSet` et `$push`, on les applique sur les grades obtenus pour les 10 premiers restaurants
    - `$addToSet` : valeurs distinctes
    - `$push` : toutes les valeurs présentes

```python
c = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$unwind": "$grades" },
    { "$group": {
        "_id": "$name",
        "avec_addToSet": { "$addToSet": "$grades.grade" },
        "avec_push": { "$push": "$grades.grade" }
    }}
])
pandas.DataFrame(list(c))
```

### `$sortBycount`

Cet opérateur réalise un regroupement sur le champs spécifié (précédé d'un `$`), compte le nombre de document pour chaque
modalité de ce champs, puis fait un tri décroissant sur le nombre calculé. Il est clairement fait pour réaliser des TOPs donc.

- Quartiers de New-York triés par nombre décroissant de restaurants

```python
c = db.restaurants.aggregate([
    { "$sortByCount": "$borough" }
])
pandas.DataFrame(list(c))
```

- C'est l'équivalent de la commande suivante

```python
c = db.restaurants.aggregate([
    { "$group": { "_id": "$borough", "count": { "$sum": 1 } } },
    { "$sort": { "count": -1 }}
])
pandas.DataFrame(list(c))
```


## Gestion des variables spéciales dans le DataFrame

Une fois importées dans un DataFrame, les champs complexes (comme `address` et `grades`) sont des variables d'un type un peu particulier.

```python
df = pandas.DataFrame(list(db.restaurants.find(limit = 10)))
df
```

### Variables ayant des dictionnaires comme valeurs

Le champs address est une liste de dictionnaires, ayant chacun plusieurs champs (ici tous les mêmes).

```python
df.address
```

#### Manipulation simple

Nom du bâtiment et rue concaténés dans une nouvelle variable de `df` (utilisation de *list comprehension* ici)

```python
df.assign(info = [e["building"] + ", " + e["street"] for e in df.address])
```

#### Manipulation plus complexe

Transformation de la liste en un DataFrame

```python
pandas.DataFrame([e for e in df.address])
```

#### Idem en intégrant le résultat dans le DataFrame original

```python
pandas.concat([df.drop("address", axis = 1), pandas.DataFrame([e for e in df.address])], axis = 1)
```

### Variables ayant des tableaux comme valeurs

Le champs `grades` est une liste de tableaux, ayant chacun potentiellement plusieurs valeurs (des dictionnaires de plus)

```python
df.grades
```

### Manipulation simple

Récupération d'un élément du tableau (premier ou dernier)

```python
df.assign(derniere = [e[0] for e in df.grades], premiere = [e[-1] for e in df.grades]).drop("grades", axis = 1)
```

### Manipulation plus complexe

Transformation de la liste de tableaux en un seul DataFrame

- `zip()` permet d'itérer sur plusieurs tableaux en même temps
- `concat()` permet de concaténer les tableaux entre eux

```python
dfgrades = pandas.concat([pandas.DataFrame(g).assign(_id = i) for (i, g) in zip(df._id, df.grades)])
dfgrades
```

### Combinaison avec les données originales

Jointure entre les deux DataFrames avec merge()

```python
pandas.merge(df.drop("grades", axis = 1), dfgrades.reset_index())
```

## A faire

1. Quelles sont les 10 plus grandes chaînes de restaurants (i.e les restaurants avec un nom identique) ? Il existe deux façons de faire.
1. Donner le Top 5 des types de cuisine, en terme de nombre de restaurants.
1. Donner le Flop 5 des types de cuisine, en terme de nombre de restaurants.
1. Quelles sont les 10 rues avec le plus de restaurants ?
1. Quelles sont les rues situées sur strictement plus de 2 quartiers ? Essayez d'ajouter le nom des quartiers de chaque rue (cf `addToSet`).
1. Lister par quartier le nombre de restaurants et le score moyen. Attention à bien découper le tableau `grades`
1. Donner les dates de début et de fin des évaluations
1. Quels sont les 10 restaurants (nom, quartier, addresse et score) avec le plus petit score moyen ? &rarr; découpage, regroupement par restaurant, tri et limite
1. Quels sont les restaurants (nom, quartier et addresse) avec uniquement des grades "A" ?
    - restriction à ceux qui ont A, découpage, suppression des autres grades que "A" et affichage des infos
    - on peut envisager d'autres choses (découpage, `addToSet`, et restriction à ceux pour lequel le tableau créé = ["A"] - par exemple)
1. Compter le nombre d'évaluation par jour de la semaine.
    &rarr; Recherche sur l'extraction du jour de la semaine à partir d'une date à faire.
1. Donner les 3 types de cuisine les plus présents par quartier
    - Piste de réflexion
        1. double regroupement à prévoir
        2. tri à prévoir
        3. regroupement avec `push`
        4. `slice` pour prendre une partie d'un tableau
