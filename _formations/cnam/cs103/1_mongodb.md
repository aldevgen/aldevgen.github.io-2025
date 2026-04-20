---
layout: page
type: formation
title: TP1
description: Introduction à MongoDB
category: Cnam CS103 - Introduction au NoSQL
visible: true
img: /assets/img/mongodb.png
tabs: true
mermaid:
  enabled: true
  zoomable: true
---

# Installation et configuration MongoDB

Durant le TP, nous allons utiliser différents outils. La première partie du TP explique l'installation de ces derniers. La seconde partie présente comment requêter les données d'une base MongoDB.

Dans un premier temps, nous allons installer MongoDB Compass qui est une interface permettant de visualiser les données.
Puis, dans un second temps, vous avez deux possibilités pour la gestion de la base de données :
1. Utiliser Docker pour créer une base de données en local (recommandé).
2. Instancier une base de données sur MongoDB Atlas (cloud).

## Installation de MongoDB Compass

Pour gérer notre base de données, nous allons utiliser [MongoDB Compass](https://www.mongodb.com/try/download/compass).
Pour cela, cliquez sur le lien pour télécharger **MongoDB Compass Download (GUI)** et suivez les instructions d'installation selon votre OS.

## Configuration de la base de données avec Docker

Téléchargement de l’image MongoDB en local.
```shell
docker pull mongodb/mongodb-community-server:latest
```

Exécuter le serveur `mongodb` en local.

```shell
docker run --rm --name mongodb -d -p 27017:27017 mongodb/mongodb-community-server
```

Une fois ceci fait, vous pouvez sauter à la section [Connexion à MongoDB Compass](#connexion-à-mongodb-compass).

Une fois que vous avez fini le TP, vous pouvez supprimer la base de données grâce à la commande suivante.

```shell
docker stop mongodb
```

## Configuration de la base de données avec MongoDB Atlas

### Création du compte Atlas

Nous allons créer un [compte Atlas](https://account.mongodb.com/account/register?signedOut=true) afin de pouvoir héberger une base de données MongoDB.

### Création d'un projet Atlas

Une fois que vous avez créé votre compte, vous allez pouvoir créer un projet, nommé `cnam` ici. Ensuite, une page demandera d'ajouter des membres, il n'y a rien à faire. Confirmez simplement la création du projet en cliquant sur **Create project**.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/creation-project.png" title="Creation project" class="img-fluid rounded z-depth-1" %}

### Création d'un utilisateur Atlas

Une fois ceci fait on aura besoin de créer un utilisateur, afin de pouvoir requêter la base de données. Pour cela, dans le menu à gauche, cliquez sur **Database & Network Access**.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/create-user.png" title="Create user" class="img-fluid rounded z-depth-1" %}

Une fois sur la page des **Database access**, cliquez sur **Add new database user** afin d'ajouter un utilisateur de la base de données. Cela ouvrira un nouvel onglet comme ci-dessous. Il faudra ainsi définir son nom, son mot de passe et son rôle. Dans notre cas, nous appelerons notre utilisateur `user_mongo` et nous générerons le mot de passe aléatoirement en cliquant sur **Autogenerate Secure Password**. Enfin, nous lui assignerons le rôle d'administrateur Atlas.

> :warning: Pensez à bien enregistrer le mot de passe dans un endroit sécurisé de votre ordinateur, nous en aurons besoin par la suite pour nous connecter à la base de données.
>
{: .block-warning }

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/creation-user.png" title="Creation user" class="img-fluid rounded z-depth-1" %}

Une fois ceci fait vous aurez la vue suivante :

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/user-created.png" title="User created" class="img-fluid rounded z-depth-1" %}

### Création d'un cluster Atlas

Maintenant nous pouvons créer un cluster qui hébergera notre base de données.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/create-cluster.png" title="Create cluster" class="img-fluid rounded z-depth-1" %}

Nous prenons l'instance M0 qui est gratuite et donnons un nom à cette dernière, ici `cluster-cnam`. Il n'y a pas besoin de changer les autres paramètres.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/creation-cluster.png" title="Creation cluster" class="img-fluid rounded z-depth-1" %}

> :warning: Il n'est possible de créer qu'**un seul cluster gratuit par compte**, donc si vous avez déjà créé un cluster gratuit avec ce compte, vous ne pourrez pas en créer un nouveau. Dans ce cas, vous devez supprimer le cluster existant avant d'en créer un nouveau.
{: .block-warning }

### Connexion au cluster Atlas

Enfin, la dernière étape consiste à choisir le connecteur à la base de données. Dans notre cas, nous utiliserons l'API Python donc nous sélectionnons **Drivers**.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/connection-method.png" title="Connection method" class="img-fluid rounded z-depth-1" %}

Sur la page suivante nous pouvons choisir le type de Driver, puis choisir **Python**.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/mongodb-driver.png" title="MongoDB driver" class="img-fluid rounded z-depth-1" %}

> Copiez la *connection string*, cela nous servira ensuite à nous connecter en Python à la base de données que nous venons de créer.
>
{: .block-example }

## Connexion à MongoDB Compass

Maintenant nous allons pouvoir utiliser le cluster créé sur Atlas. Commençons par se connecter à notre instance.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/compass-connection.png" title="Compass connection" class="img-fluid rounded z-depth-1" %}

### Connexion à MongoDB Compass avec Docker

Ensuite, il faut connecter l'image locale Docker à MongoDB Compass. Pour cela, il faut renseigner une connection string, qui est celle par défaut, à savoir `mongodb://localhost:27017`. Vous pouvez sauvegarder et fermer le page de connexion. Puis aller à la section [Import des données dans MongoDB Compass](#import-des-données-dans-mongodb-compass).

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/compass-add-connection-localhost.png" title="Compass add connection" class="img-fluid rounded z-depth-1" %}

### Connexion à MongoDB Compass avec MongoDB Atlas

La connexion va se faire via la *connection string* qui peut être trouvée dans la configuration du cluster Atlas.

> :warning: N'oubliez pas de remplacer le mot de passe sur l'image ci-dessous par celui que vous avez enregistré plus haut et de remplacer `mon_super_mot_de_passe_genere` dans `mongodb+srv://user_mongo:mon_super_mot_de_passe_genere@cluster-cnam.douiht4.mongodb.net/?appName=cluster-cnam` (sans les <>).
{: .block-warning }

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/compass-add-connection.png" title="Compass add connection" class="img-fluid rounded z-depth-1" %}

## Import des données dans MongoDB Compass

Une fois ceci fait, nous allons créer une base de données appelée `tp` qui contiendra une collection nommée `pathologies`.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/create-database-collection.png" title="Create database collection" class="img-fluid rounded z-depth-1" %}
{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/create-database.png" title="Create database" class="img-fluid rounded z-depth-1" %}

Enfin, il suffit d'importer le fichier `pathologies.json` en cliquant sur le bouton *Import JSON or CSV file* avec les données ci-jointes.

<a class="download-btn"
    href="https://raw.githubusercontent.com/aldevgen/data/main/json/pathologies.json"
    download="pathologies.json"
    rel="noopener noreferrer">
    <button><i class="fa fa-download"></i> Données pathologies</button>
</a>

Cliquer sur le bouton puis enregistrer le fichier : Fichier > Enregistrer Sous ou Ctrl+S sur Windows/Linux ou Cmd+S sur Mac.

{% include figure.liquid loading="eager" path="assets/img/cnam/mongodb/import-data.png" title="Import data" class="img-fluid rounded z-depth-1" %}

Et voilà, vous êtes prêts à requêter les données ! :tada:

# Présentation des données

Les données sont issues de la base de données [Caisse nationale de l'Assurance Maladie (Cnam)](https://www.data.gouv.fr/datasets/pathologies-effectif-de-patients-par-pathologie-sexe-classe-dage-et-territoire-departement-region/informations).

Seules 8 000 lignes ont été importées pour des raisons de temps de traitement, car la base de données d'origine représente 2 Go de données.

Voici un document de la base de données :

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

# Partie 1 : Requêtage avec MongoDB

Les données `JSON` sont similaires à un dictionnaire `Python`. Pour récupérer le premier document, nous utilisons la fonction `find()` de l'objet créé `first_doc`.

```python
first_doc = db.students.find(limit = 1)
```

> Ici `students` est le nom de la collection. Dans notre cas, elle correspond à `pathologies`.
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
db.students.count_documents({})
```
La fonction `estimated_document_count()` permet d'estimer le nombre de documents, cela est particulièrement utile lorsque la base de données
est déployée sur plusieurs servers avec une grande quantité de données et qu'une estimation précise du volume de données n'est pas nécessaire.

```python
db.students.estimated_document_count()
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


> Les requêtes ci-dessous sont des exemples de requêtes sur une base de données fictive `students` à propos des étudiants et des cours qu'ils suivent à l'université.
>
{: .block-example }

___Comptage de documents___

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

On peut aussi voir la liste des valeurs distinctes d'un attribut, avec la fonction `distinct()`.

- Nombre de cours différents enseignés dans toutes les universités

```python
db.students.distinct(key = "course")
```

- Nombre de cours enseignés à l'Université de Paris

```python
db.students.distinct(
  key = "course",
  query = { "university": "Université de Paris" }
)
```

___Restriction et projection___

- Fonction `find()` pour réaliser les *restrictions* et *projections*
- Plusieurs paramètres :
    - Restriction (quels documents prendre) : même format que précédemment
    - Projection (quels champs afficher)
    - `limit` pour n'avoir que les $n$ premiers documents
    - `sort` pour effectuer un tri des documents

Dans la fonction `find()`, pour choisir les champs à afficher, le deuxième paramètre permet de faire une projection avec les critères suivants :

- sans précision, l'identifiant interne est toujours affiché (`_id`)
- `{ "champs": 1 }` : champs à afficher
- `{ "champs": 0 }` : champs à ne pas afficher
- Pas de mélange des 2 sauf pour l'identifiant interne à MongoDB (`_id`)
    - `{ "_id": 0, "champs": 1, ...}`

Toujours dans la fonction `find()`, il est possible de faire le tri des documents, avec le paramètre `sort` qui prend un tuple composé d'un ou plusieurs tuples indiquant les critères de tri.

- `( "champs", 1 )` : tri croissant
- `( "champs", -1 )` : tri décroissant
- plusieurs critères de tri possibles (dans les 2 sens)

Dans ces fonctions, on peut aussi limiter l'exploration à une partie, avec les paramètres suivant :

- `limit` : restreint le nombre de résultats fournis
- `skip` : ne considère pas les *n* premiers documents

Notez le contenu des colonnes `address` et `grades`.

```python
import pandas as pd
pd.DataFrame(list(db.students.find(limit = 5)))
```

- Cours de NoSQL (uniquement les attributs `"name"` et `"surname"`)

```python
nosql_students = db.students.find(
    { "course": "NoSQL" },
    { "student.name": 1, "student.surname": 1 }
)
pd.DataFrame(list(nosql_students))
```

- Idem sans l'identifiant interne

```python
nosql_students = db.students.find(
    { "course": "NoSQL" },
    { "_id": 0, "student.name": 1, "student.surname": 1 }
)
pd.DataFrame(list(nosql_students))
```

- 5 meilleures notes de l'évaluation de NoSQL, supérieures à 15 (on affiche le nom et le prénom de l'étudiant)

```python
first_grades = db.students.find(
    { "course": "NoSQL", "grades.score": { "$gte":  15}},
    { "_id": 0, "student.name": 1, "student.surname": 1 }
    limit = 5
)
pd.DataFrame(list(first_grades))
```

- Étudiants du cours de NoSQL, ayant une note supérieure à 12, trié par ordre décroissant des notes et ordre croissant du nom de famille (on affiche le nom et le prénom de l'étudiant).

```python
sorted = db.students.find(
    { "course": "NoSQL", "grades.score": { "$gte":  12}},
    {"_id": 0, "student.name": 1, "student.surname": 1 },
    sort = (("grades.score", -1), ("student.surname", 1))
)
pd.DataFrame(list(c))
```

## Questions

Pour la suite du TP, nous allons utiliser un Notebook Jupyter. Un notebook est un document qui permet d'écrire du code exécutable, mais aussi d'ajouter du texte, des images, des vidéos, etc.

<div class="container">
  <a class="download-btn"
    href="https://raw.githubusercontent.com/aldevgen/aldevgen.github.io/refs/heads/main/assets/jupyter/cnam/NoSQL_TP_MongoDB.ipynb"
    target="_blank"
    download>
      <button><i class="fa-solid fa-file-code"></i> Notebook Jupyter</button>
  </a>
</div>

Le premier bloc de code du notebook permet d'installer les bibliothèques nécessaires pour manipuler les données et se connecter à la base de données MongoDB et pour manipuler les données avec Pandas.

```shell
!pip install pandas pymongo --quiet
```

Le deuxième bloc permet de se connecter à la base de données MongoDB précédemment créée.
La méthode de connexion dépend du type de base de données que vous avec créée.

**Avec Docker**

```python
import pymongo
import pandas as pd

# Connexion avec Docker
client = pymongo.MongoClient()
db = client.tp

# Afficher le nom des collections de la base de données et la collection pathologies
print("Collections: ", db.list_collection_names())
print("Pathologies: ", db.pathologies)
```

**Avec MongoDB Atlas**

N'oubliez pas de remplacer le nom d'utilisateur, le mot de passe et le nom du cluster par les vôtres dans l'URI de connexion.

```python
import pymongo
import pandas as pd

# Connexion avec MongoDB Atlas
# Remplacer l'URI par celle copiée sur MongoDB Atlas
URI = 'mongodb+srv://<user_name>:<password>@<cluster_name>.mongodb.net/?retryWrites=true&w=majority&appName=<cluster_name>'
client = pymongo.MongoClient(URI)
db = client.tp

# Afficher le nom des collections de la base de données et la collection pathologies
print("Collections: ", db.list_collection_names())
print("Pathologies: ", db.pathologies)
```

Ensuite, utilisez le notebook pour répondre aux questions ci-dessous.

1. Quelles sont les pathologies de niveau 1 présentes dans la base de données ?
2. Lister toutes les catégories de pathologies de niveau 2
3. Combien y a-t-il de personnes avec une pathologie "Maladies cardioneurovasculaires" ?
4. Compter le nombre de documents pour la tranche d'âge "45-49 ans"
5. Compter le nombre de documents où la prévalence (prev) est supérieure à 0.2
6. Lister tous les documents, en n'affichant que l'année, la pathologie de niveau 1, la région et le département
7. Lister toutes les pathologies de niveau 3 pour les femmes (sexe=2), en affichant seulement la pathologie et la classe d'âge
8. Lister les pathologies pour les régions "32" ou "44", en affichant la pathologie de niveau 1, le département et la prévalence
9. Lister les pathologies où le niveau prioritaire contient "2", en affichant la pathologie de niveau 2, la région et le niveau prioritaire
10. Lister les pathologies où la prévalence est nulle (prev=null), en affichant la pathologie de niveau 3, la région et le département

# Partie 2 : Agrégats dans MongoDB

Dans la suite du TP, nous allons utiliser la collection `restaurants` de la base de données `sample_restaurants` qui est une base de données d'exemple fournie par [MongoDB](https://www.mongodb.com/docs/atlas/sample-data/sample-restaurants/), et qui contient des informations sur les restaurants de New-York.

```json
{
 "address": {
   "building": "8825",
   "coord": [-73.8803827, 40.7643124],
   "street": "Astoria Boulevard",
   "zipcode": "11369"
 },
 "borough": "Queens",
 "cuisine": "American",
 "grades": [ {
   "date": {"$date": "2014-11-15T00:00:00.000Z"},
   "grade": "Z",
   "score": 38
 },
 {
   "date": {"$date": "2014-05-02T00:00:00.000Z"},
   "grade": "A",
   "score": 10
 },
 {
   "date": {"$date": "2013-03-02T00:00:00.000Z"},
   "grade": "A",
   "score": 7
 },
 {
   "date": {"$date": "2012-02-10T00:00:00.000Z"},
   "grade": "A",
   "score": 13
 }],
   "name": "Brunos On The Boulevard",
   "restaurant_id": "40356151"
}
```

## Fonctions d'agrégation

Il est possible de réaliser des calculs d'agrégats (somme, moyenne, minimum et maximum) dans MongoDB, avec la fonction `aggregate()`. Cette fonction va prendre en paramètre un tableau nommé `pipeline` qui est un tableau composé d'une suite d'opérations.

> :information_source: L'ordre des opérations est important, car elles sont appliquées les unes après les autres.
>
> Par exemple, si on fait un tri avant une restriction, le tri se fera sur l'ensemble des documents alors que si on fait la restriction avant le tri, ce dernier ne se fera que sur les documents restreints.
>
{: .block-example }

Voici quelques-unes des opérations possibles :

| Fonction       | Opération                                                                       |
|-|---------------------------------------------------------------------------------|
| `$limit`       | restriction à un petit nombre de documents (très utiles pour tester son calcul) |
| `$sort`        | tri sur les documents                                                           |
| `$match`       | restriction sur les documents à utiliser                                        |
| `$unwind`      | séparation d'un document en plusieurs sur la base d'un tableau                  |
| `$addFields`   | ajout d'un champs dans les documents                                            |
| `$project`     | redéfinition des documents                                                      |
| `$group`       | regroupements et calculs d'aggégrats                                            |
| `$sortByCount` | agrégat + tri                                                                   |
| `$lookup`      | jointure avec une autre collection                                              |

## Syntaxe des opérations

`$limit`

---

On indique avec un entier le nombre de documents que l'on veut afficher.

- Afficher les 10 premiers restaurants

```python
first_restaurants = db.restaurants.aggregate([
    { "$limit": 10 }
])
pandas.DataFrame([first_restaurants])
```

`$sort`

---

Trier les documents selon un ou plusieurs critères, avec les mêmes règles que pour la fonction `find()`. À noter que `1` correspond à un tri croissant et `-1` à un tri décroissant.

- Afficher les 10 premiers restaurants triés par le nom du restaurant

```python
first_restaurants_sorted_name = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$sort": { "name": 1 }}
])
pandas.DataFrame([first_restaurants_sorted_name])
```

`$match`

---

Filtrer les documents selon des critères, avec les mêmes règles que pour la fonction `find()`.

- Idem en se restreignant à *Brooklyn* (5 restaurants)

```python
brooklyn = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$sort": { "name": 1 }},
    { "$match": { "borough": "Brooklyn" }}
])
pandas.DataFrame([brooklyn])
```

- Mêmes opérations avec la restriction en amont de la limite (10 restaurants)

```python
brooklyn = db.restaurants.aggregate([
    { "$match": { "borough": "Brooklyn" }},
    { "$limit": 10 },
    { "$sort": { "name": 1 }}
])
pandas.DataFrame([brooklyn])
```

`"$unwind"`

---

Le but de cette opération est d'**exploser** un tableau dans un document.

> Un document avec un tableau à *n* éléments deviendra *n* documents avec chacun un des éléments du tableau en lieu et place de celui-ci.

Nous devons mettre le nom du tableau servant de base pour le découpage (précédé d'un `$`)

- Séparation des 10 premiers restaurants sur la base des évaluations (`grades`)

Chaque ligne correspond maintenant à une évaluation pour un restaurant.

```python
grades = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$unwind": "$grades" }
])
pandas.DataFrame([grades])
```

- Idem précédemment, en se restreignant à celle ayant eu *B*

```python
grades_b = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$unwind": "$grades" },
    { "$match": { "grades.grade": "B" }}
])
pandas.DataFrame([grades_b])
```

- Si on inverse les opérations `$unwind` et `$match`, le résultat est différent

```python
grades_b = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$match": { "grades.grade": "B" }},
    { "$unwind": "$grades" }
])
pandas.DataFrame([grades_b])
```

`"$addFields"` et  `"$project"`

---

On peut redéfinir les documents en ajoutant des éléments (`$addFields`) ou en se restreignant à certains éléments (`$project`).

- `{ "variable" : 1 }` : conservation du champ (0 si suppression, idem que dans `find()`, pas de mélange sauf pour `_id`)
    - valable uniquement dans `$project`
- `{ "variable": { "$opérateur" : expression }}` : permet de définir un nouveau champ
- `{ "nouveau_champs": "$ancien_champs" }` : renommage d'un champ

Quelques opérateurs utiles pour la projection (plus d'info [ici](https://docs.mongodb.com/manual/reference/operator/aggregation/))

- `$arrayElemAt` : élément d'un tableau
- `$first` : premier élément du tableau
- `$last` : dernier élément du tableau
- `$size` : taille d'un tableau
- `$substr` : sous-chaîne de caractères
- `$cond` : permet de faire une condition (équivalent de *if then else*)
- ...

- On peut aussi vouloir ajouter un champ, comme ici le nombre d'évaluations

```python
nb_grades = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$addFields": { "nb_grades": { "$size": "$grades" } } }
])
pandas.DataFrame([nb_grades])
```

- On souhaite ici ne garder que le nom et le quartier des 10 premiers restaurants
    - Notez l'ordre (alphabétique) des variables, et pas celui de la déclaration

```python
name_borough = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": { "name": 1, "borough": 1 } }
])
pandas.DataFrame([name_borough])
```

- Ici, on supprime l'adresse et les évaluations

```python
no_address_grades = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": { "address": 0, "grades": 0 } }
])
pandas.DataFrame([no_address_grades])
```

- En plus du nom et du quartier, on récupère l'adresse dans un nouveau champ

```python
name_borough_street = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": { "": 1, "borough": 1 , "street": "$address.street"} }
])
pandas.DataFrame([name_borough_street])
```

- On ajoute le nombre de visites pour chaque restaurant (donc la taille du tableau `grades`)

```python
nb_visits = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": { "name": 1, "borough": 1, "nb_grades": { "$size": "$grades" } } }
])
pandas.DataFrame([nb_visits])
```

- On trie ce résultat par nombre de visites, et on affiche les 10 premiers

Notez qu'il y a des restaurants sans visite donc (pour lesquels `grades` est présent, mais égal à `NULL`). Dans l'idéal, ces restaurants ne devraient pas avoir de champs `grades`.

```python
nb_visits_sorted = db.restaurants.aggregate([
    { "$project": { "name": 1, "borough": 1, "nb_grades": { "$size": "$grades" } } },
    { "$sort": { "nb_grades": 1 }},
    { "$limit": 10 }
])
pandas.DataFrame([nb_visits_sorted])
```

- On ne garde maintenant que le premier élément du tableau `grades` (à l'indice 0)

```python
first_grade = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": { "name": 1, "borough": 1, "grade": { "$arrayElemAt": [ "$grades", 0 ]} } }
])
pandas.DataFrame([first_grade])
```

- On peut aussi faire des opérations sur les chaînes, telles que la mise en majuscule du nom

```python
upper_name = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": { "nom": { "$toUpper": "$name" }, "borough": 1 } }
])
pandas.DataFrame([upper_name])
```

- On extrait ici les trois premières lettres du quartier

```python
first_letters_borough = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$project": {
        "nom": { "$toUpper": "$name" },
        "quartier": { "$substr": [ "$borough", 0, 3 ] }
    } }
])
pandas.DataFrame([first_letters_borough])
```

- On fait de même, mais on met en majuscule et on note *BRX* pour le *Bronx*
    - on garde le quartier d'origine pour vérification ici

```python
first_letters_bronx = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$addFields": { "quartier": { "$toUpper": { "$substr": [ "$borough", 0, 3 ] } } }},
    { "$project": {
        "nom": { "$toUpper": "$name" },
        "quartier": { "$cond": { "if": { "$eq": ["$borough", "Bronx"] }, "then": "BRX", "else": "$quartier" } },
        "borough": 1
    } }
])
pandas.DataFrame([first_letters_bronx])
```

`"$group"`

---

Cet opérateur permet le calcul d'agrégats tel qu'on le connaît.

- `_id` : déclaration du critère de regroupement
    - chaîne de caractères : pas de regroupement (tous les documents)
    - `$champs` : regroupement selon ce champ
    - `{ "a1": "$champs1", ... }` : regroupement multiple (avec possibilité de modification des valeurs)
- Calculs d'agrégats à faire :
    - `$sum` : somme (soit de valeur fixe - 1 pour faire un décompte donc, soit d'un champ spécifique)
    - `$avg, $min, $max`
    - `$addToSet` : regroupement des valeurs distinctes d'un champ dans un tableau
    - `$push` : aggrégation de champs dans un tableau

- On calcule ici le nombre total de restaurants

```python
nb_restaurants = db.restaurants.aggregate([
    { "$group": { "_id": "Total", "NbRestos": { "$sum": 1 }}}
])
pandas.DataFrame([nb_restaurants])
```

- On fait de même, mais par quartier

```python
nb_borough = db.restaurants.aggregate([
    { "$group": { "_id": "$borough", "NbRestos": { "$sum": 1 }}}
])
pandas.DataFrame([nb_borough])
```

- Moyenne des notes des restaurants du *Queens*

```python
avg_queens = db.restaurants.aggregate([
    { "$match": { "borough": "Queens" }},
    { "$unwind": "$grades" },
    { "$group": { "_id": "null", "score": { "$avg": "$grades.score" }}}
])
pandas.DataFrame([avg_queens])
```

-  Il est bien évidemment possible de faire ce calcul par quartier et de les trier selon les notes obtenues (ici dans l'ordre décroissant)

```python
avg_queens_sorted = db.restaurants.aggregate([
    { "$unwind": "$grades" },
    { "$group": { "_id": "$borough", "score": { "$avg": "$grades.score" }}},
    { "$sort": { "score": -1 }}
])
pandas.DataFrame([avg_queens_sorted])
```

- On peut aussi faire un regroupement par quartier et par rue (en ne prenant que la première évaluation - qui est la dernière en date a priori), pour afficher les 10 rues où on mange le plus sainement.
    - Notez que le premier `$match` permet de supprimer les restaurants sans évaluations (ce qui engendrerait des moyennes = `NA`)

```python
avg_borough_street = db.restaurants.aggregate([
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
pandas.DataFrame([avg_borough_street])
```

- Pour comprendre la différence entre `$addToSet` et `$push`, on les applique sur les grades obtenus pour les 10 premiers restaurants
    - `$addToSet` : valeurs distinctes
    - `$push` : toutes les valeurs présentes

```python
push_to_set = db.restaurants.aggregate([
    { "$limit": 10 },
    { "$unwind": "$grades" },
    { "$group": {
        "_id": "$name",
        "avec_addToSet": { "$addToSet": "$grades.grade" },
        "avec_push": { "$push": "$grades.grade" }
    }}
])
pandas.DataFrame([push_to_set])
```
`$sortBycount`

---

Cet opérateur réalise un regroupement sur le champ spécifié (précédé d'un `$`), compte le nombre de documents pour chaque modalité de ce champ, puis fait un tri décroissant sur le nombre calculé. Il est clairement fait pour réaliser des TOPs donc.

- Nombre décroissant de restaurants de New-York triés par quartiers

```python
nb_restaurants_per_borough = db.restaurants.aggregate([
    { "$sortByCount": "$borough" }
])
pandas.DataFrame([nb_restaurants_per_borough])
```

- C'est l'équivalent de la commande suivante

```python
nb_restaurants_per_borough = db.restaurants.aggregate([
    { "$group": { "_id": "$borough", "count": { "$sum": 1 } } },
    { "$sort": { "count": -1 }}
])
pandas.DataFrame([nb_restaurants_per_borough])
```

## Questions

Nous utilisons la collection [`restaurants`](https://raw.githubusercontent.com/aldevgen/data/main/json/restaurants.json).
Comme dans la partie précédente, créez une nouvelle collection dans votre base de données MongoDB Compass, et importez-y les données du fichier `restaurants.json` (<a href="https://raw.githubusercontent.com/aldevgen/data/main/json/restaurants.json" download="restaurants.json">Fichier > Enregistrer Sous</a>).

<!-- Vous pouvez utiliser le <a href="../../../../assets/jupyter/cnam/NoSQL_TP_MongoDB.ipynb" target="_blank" download>Notebook Jupyter</a> suivant pour répondre aux questions ci-dessous.-->

1. Quelles sont les 10 plus grandes chaînes de restaurants (i.e les restaurants avec un nom identique) ?
1. Donner le Top 5 des types de cuisine, en termes de nombre de restaurants.
1. Donner le Flop 5 des types de cuisine, en termes de nombre de restaurants.
1. Quelles sont les 10 rues avec le plus de restaurants ?
1. Quelles sont les restaurants situés sur strictement plus de 2 quartiers ? Essayez d'ajouter le nom des quartiers de chaque rue (cf `addToSet`).
1. Lister par quartier le nombre de restaurants et le score moyen. Attention à bien découper le tableau `grades`
1. Donner les dates de début et de fin des évaluations
1. Quels sont les 10 restaurants (nom, quartier, adresse et score) avec le plus petit score moyen ?
1. Quels sont les restaurants (nom, quartier et adresse) avec uniquement des grades `A` ?
1. Compter le nombre d'évaluations par jour de la semaine.
