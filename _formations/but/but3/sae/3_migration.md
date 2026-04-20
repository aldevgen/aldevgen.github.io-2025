---
layout: page
type: formation
title: TP migration
description: Migration de la base de données
category: BUT 3 - SAÉ migration vers NoSQL
visible: true
img:
tabs: true
mermaid:
  enabled: true
  zoomable: true
---

# Séance 3

La première séance a permis de se familiariser avec la base de données *ClassicModel*. Durant la deuxième séance nous avons sélectionné la base de données NoSQL ainsi que son architecture cible.

1. Création de requêtes SQL sur la BD initiale ;
2. Réflexion sur le format des données à obtenir et l’algorithme à réaliser ;
3. Écriture du script Python permettant le passage de SQLite à NoSQL ;
4. Création des requêtes initiales au nouveau format NoSQL pour s’assurer que la migration s’est bien passée.

L'objectif de cette séance est d'écrire le script de migration d'une base de données vers un modèle MongoDB (points 3 et 4).

## Données

Pour la suite du TP nous utiliserons les données `Gymnase2000` disponibles dans le fichier `Gymnase2000.sqlite` dont le schéma est ci-dessous.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/sae/Gymnase2000.png" title="Gymnase ER graph" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

À partir de ce schéma, nous allons créer deux collections :
- **Gymnases** : chaque document concerne un *gymnase*, dans lequel on ajoute les informations de toutes les *séances* prévues (sous la forme d'une liste)
- **Sportifs** : chaque document concerne un *sportif.ve*, pour chaque sportif.ve on stockera les informations concernant les sports pour lesquels il/elle joue, les sports pour lesquel il/elle s'entraîne ainsi que ceux pour lesquels il/elle est arbitre.

## Cluster MongoDB

Avant de commencer le TP, connectez-vous à [MongoDB Atlas](https://account.mongodb.com/account/login?signedOut=true) et créez un cluster comme vu lors des TPs. Si vous avez besoin d'un rappel vous pouvez consulter la page [installation MongoDB](../nosql/1_introduction-mongodb.md).

- Database name : `sae`
- Collection name : `gymnases`

### Création de la collection Gymnases

On commence par se connecter à la base de données en local.

```python
import sqlite3
import pandas
import pymongo

URI = "CONNEXION STRING TO REPLACE"
client = pymongo.MongoClient(URI)
db = client.sae

# Création de la connexion
conn = sqlite3.connect("Gymnase2000.sqlite")
```

Une fois ceci fait, nous pouvons récupérer les données en faisant des requêtes SQL, comme suit.

```python
gymnases = pandas.read_sql_query(
    """
    SELECT *
    FROM Gymnases;
    """,
    conn
)
```

| IdGymnase | NomGymnase    | Adresse                    | Ville        | Surface |
|-----------|---------------|----------------------------|--------------|---------|
| 1         | PAUL ELUARD   | 2 rue des pépines          | STAINS       | 200     |
| 2         | ARAGON        | Place du Chartres          | MONTMORENCY  | 450     |
| 3         | SAINT EXUPERY | 47 bvd des brumes          | PIERREFITTE  | 400     |
| 4         | PAUL ELUARD   | Allée J.B. Lulli           | SARCELLES    | 500     |
| 5         | BRASSENS      | 153 square Loliot          | SARCELLES    | 620     |
| 6         | VERLAINE      | 14 bvd Serrault            | STAINS       | 400     |
| 7         | JULES FERRY   | 45 rue de la gare          | PIERREFITTE  | 360     |
| 8         | PREVERT       | 12 rue des collines        | MONTMORENCY  | 420     |
| 9         | CAMUS         | 3 esplanade des quatrans   | SARCELLES    | 620     |
| 10        | RIMBAUD       | 140 bvd Diderot            | STAINS       | 400     |
| 11        | LAMARTINE     | 7 rue de la souris verte   | PIERREFITTE  | 300     |
| 12        | MOZART        | 6 Allée Rosana             | MONTMORENCY  | 480     |
| 13        | RAVEL         | Place aux pommes           | STAINS       | 200     |
| 14        | CHOPIN        | 23 rue Carafelli           | MONTMORENCY  | 500     |
| 15        | BREL          | 4 rue de la miséricorde    | PIERREFITTE  | 400     |
| 16        | SAMOURAI      | 4 Allée des pendules       | SARCELLES    | 600     |
| 17        | GARCIA LORCA  | 45 bvd des Comes           | STAINS       | 400     |
| 18        | PABLO NERUDA  | 6 rue saint Jean           | PIERREFITTE  | 450     |
| 19        | COCTEAU       | 45 bis rue du moulin rouge | MONTMORENCY  | 500     |
| 20        | LUMIERES      | 78 rue Vendôme             | SARCELLES    | 400     |
| 21        | SIMON         | 8 bvd général de Gaulle    | STAINS       | 400     |
| 22        | BARBARA       | 45  rue du bossu           | SAINT DENIS  | 500     |
| 23        | ARAGON        | 10 Bvd Lenoir              | SAINT DENIS  | 520     |
| 24        | BELFEGOR      | Place de Gaulle            | SAINT DENIS  | 450     |
| 25        | DOLTO         | 3 square Plaisir           | VILLETANEUSE | 620     |
| 26        | MERMOZ        | 41 rue des ponts           | VILLETANEUSE | 600     |
| 27        | PASCAL        | 20 rue de la pirogue       | VILLETANEUSE | 350     |
| 28        | BLAISE PASCAL | 2bis rue de la moulerie    | GARGES       | 400     |

Après avoir récupéré les gymnases, nous allons récupérer les séances de sport.
```python
seances = pandas.read_sql_query(
    """
    SELECT *
    FROM Seances
    INNER JOIN Sports
    USING (IdSport);
    """,
    conn
)
```
Voici les informations du gymnase `1` :

| IdGymnase | IdSport | IdSportifEntraineur | Jour     | Horaire | Duree | Libelle     |
|-----------|---------|---------------------|----------|---------|-------|-------------|
| 1         | 1       | 149                 | Samedi   | 9.0     | 60    | Basket ball |
| 1         | 3       | 1                   | Lundi    | 9.0     | 60    | Hand ball   |
| 1         | 3       | 1                   | Lundi    | 10.0    | 60    | Hand ball   |
| 1         | 3       | 1                   | Lundi    | 11.3    | 60    | Hand ball   |
| 1         | 3       | 1                   | Lundi    | 14.0    | 90    | Hand ball   |
| 1         | 3       | 1                   | lundi    | 17.3    | 120   | Hand ball   |
| 1         | 3       | 1                   | Lundi    | 19.3    | 120   | Hand ball   |
| 1         | 3       | 2                   | Dimanche | 17.3    | 120   | Hand ball   |
| 1         | 3       | 2                   | Dimanche | 19.3    | 120   | Hand ball   |
| 1         | 3       | 2                   | mardi    | 17.3    | 120   | Hand ball   |
| 1         | 3       | 2                   | mercredi | 17.3    | 120   | Hand ball   |
| 1         | 3       | 2                   | Samedi   | 15.3    | 60    | Hand ball   |
| 1         | 3       | 2                   | Samedi   | 16.3    | 60    | Hand ball   |
| 1         | 3       | 2                   | Samedi   | 17.3    | 120   | Hand ball   |
| 1         | 3       | 3                   | jeudi    | 20.0    | 30    | Hand ball   |
| 1         | 3       | 3                   | lundi    | 14.0    | 60    | Hand ball   |
| 1         | 3       | 3                   | lundi    | 18.0    | 30    | Hand ball   |
| 1         | 3       | 3                   | lundi    | 19.0    | 30    | Hand ball   |
| 1         | 3       | 3                   | lundi    | 20.0    | 30    | Hand ball   |
| 1         | 5       | 7                   | mercredi | 17.0    | 90    | Hockey      |

Maintenant, il faut ajouter une colonne `seances` dans `gymnases`. Pour cela, regardons le résultat attendu pour le gymnase ayant l'identifiant `6`.

```python
id = 6
gym6 = seances.query('IdGymnase == @id')
print(gym6)
```

Le résultat est le suivant :

| IdGymnase | IdSport | IdSportifEntraineur | Jour     | Horaire | Durée | Libelle |
|-----------|---------|---------------------|----------|---------|-------|---------|
| 6         | 5       | 6                   | vendredi | 19.0    | 60    | Hockey  |
| 6         | 5       | 7                   | jeudi    | 17.0    | 90    | Hockey  |

On voit ici qu'il y a les identifiants du gymnase et du sport qui sont des informations redondantes car déjà présentes dans l'objet `gymnases`. Pour ce faire, nous allons les supprimer et les convertir en liste afin de les ajouter dans `gymnases` (grâce aux fonctions `drop` et `to_dict`).

```python
seances.query('IdGymnase == @id')\
    .drop(columns = ["IdGymnase", "IdSport"])\
    .to_dict(orient = "records")
```

Et on obtient

```json
[
    {
        'IdSportifEntraineur': 6,
        'Jour': 'vendredi',
        'Horaire': 19.0,
        'Duree': 60,
        'Libelle': 'Hockey'
    },
    {
        'IdSportifEntraineur': 7,
        'Jour': 'jeudi',
        'Horaire': 17.0,
        'Duree': 90,
        'Libelle': 'Hockey'
    }
]
```

On peut faire cette opération au travers d'une liste compréhension pour toutes les séances :

```python
sessions = [
    seances.query('IdGymnase == @id')
        .drop(columns=["IdGymnase", "IdSport"])
        .to_dict(orient = "records")
        for id in gymnases.IdGymnase
]
print(sessions)
```

Il ne reste plus qu'à ajouter ce résultat dans `gymnases`.

```python
gymnases = gymnases.assign(Sessions = sessions)
gymnases.head()
```

Voici le résultat obtenu pour les gymnases `2` et `3` :

| IdGymnase | NomGymnase    | Adresse           | Ville       | Surface | Sessions                                                                                                                                                                                                                                                                                                                 |
|-----------|---------------|-------------------|-------------|---------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 2         | ARAGON        | Place du Chartres | MONTMORENCY | 450     | \[{'IdSportifEntraineur': 57, 'Jour': 'dimanche', 'Horaire': 17.0, 'Duree': 60, 'Libelle': 'Volley ball'}\]                                                                                                                                                                                                              |
| 3         | SAINT EXUPERY | 47 bvd des brumes | PIERREFITTE | 400     | \[{'IdSportifEntraineur': 149, 'Jour': 'Mercredi', 'Horaire': 11.0, 'Duree': 30, 'Libelle': 'Basket ball'}, {'IdSportifEntraineur': 57, 'Jour': 'lundi', 'Horaire': 16.3, 'Duree': 90, 'Libelle': 'Volley ball'}, {'IdSportifEntraineur': 60, 'Jour': 'jeudi', 'Horaire': 19.0, 'Duree': 60, 'Libelle': 'Volley ball'}\] |

Nous avons une nouvelle colonne `Sessions` contenant la liste `sessions` pour chaque gymnase. Ainsi, les données des séances sont bien intégrées dans les gymnases. Nous pouvons maintenant insérer les données dans MongoDB.

### Insertion dans la base de données MongoDB

Maintenant que les données sont préparées, nous pouvons insérer les données dans MongoDB.

```python
db.gymnases.insert_many(
    gymnases.to_dict(orient = "records")
)
```

Vous pouvez aller voir le résultat dans MongoDB Compass. Vous pouvez aussi tester directement en interrogeant MongoDB pour le nombre de documents de la collection :

```python
db.gymnases.count_documents({})
```

Ainsi que le contenu de la collection :

```python
list(db.gymnases.find())
```

### TO-DO

Maintenant, que nous avons créé la collection `gymnases`, créez la collection `sportifs`.
1. Récupérer les données des tables `Sportifs`, `Joue`, `Entrainer` et `Arbitrer`.
2. Créer une collection `sportifs` avec les informations des sportifs, des sports qu'ils pratiquent, des sports pour lesquels ils s'entraînent et des sports pour lesquels ils arbitrent.

L'objectif est de créer une collection `sportifs` avec les informations suivantes (exemple fictif) :

```json
{
    "IdSportif": 256,
    "Nom": "BOUTAHAR",
    "Prenom": "Abderahim",
    "Sexe": "m",
    "Age": 30,
    "joue": ["Basket ball", "Volley ball"],
    "entraine": ["Basket ball"],
    "arbitre": ["Basket ball", "Tennis"]
}
```

### Jointure entre deux collections

Supposons que l'on ait deux collections `gymnases` et `sportifs` qui ont chacune l'identifiant de l'entraîneur. Si nous souhaitons récupérer les informations de l'entraîneur pour chaque séance, pour chaque gymnase, nous pouvons exécuter le code suivant :

```python
pandas.DataFrame(list(db.gymnases.aggregate([
    { "$limit": 1 },
    { "$unwind": "$Sessions" },
    { "$lookup": {
       "from": "sportifs",
       "localField": "Sessions.IdSportifEntraineur",
       "foreignField": "IdSportif",
       "as": "Entraineur"
     }}
])))
```

**A noter** : le résultat d'un `lookup` est forcément un tableau, même s'il n'y a qu'une seule valeur. A vous de faire le travail pour l'extraire dans un littéral simple si vous le souhaitez (par exemple avec `$first`).

# Retour sur ClassicModel

Une fois que vous avez fini les questions sur la base de données `Gymnase2000` vous pouvez faire la migration sur votre base de données `ClassicModel` en suivant l'architecture cible définie lors de la séance 2.
