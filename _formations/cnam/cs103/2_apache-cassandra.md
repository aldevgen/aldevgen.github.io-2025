---
layout: page
type: formation
title: TP2
description: Introduction à Apache Cassandra et au langage de requête CQL
category: Cnam CS103 - Introduction au NoSQL
visible: true
img: /assets/img/apache-cassandra.png
tabs: true
mermaid:
  enabled: true
  zoomable: true
---

# Cassandra Query Language

Apache Cassandra dispose d'un langage de requête, nommé CQL pour **Cassandra Query Language**. Bien qu'il ressemble à SQL, il est conçu pour les opérations de base de données distribuées sans prise en charge de certaines fonctionnalités comme les jointures.

## Présentation des données

Pour mieux comprendre les commandes CQL, nous allons utiliser un exemple de données d'une bibliothèque. Les données sont stockées dans un keyspace `biblio` qui contient deux tables : `utilisateurs` et `emprunts`.

### Table `utilisateurs`

La table `utilisateurs` contient les informations des utilisateurs de la bibliothèque :
- `id` : identifiant unique de l'utilisateur
- `nom` : nom de l'utilisateur
- `age` : âge de l'utilisateur

Ci-dessous un exemple de données pour la table `utilisateurs` :

| id                      | nom    | age |
|-------------------------|---------|-----|
| 6a6148d1-4a56-4d6a-a610 | Alice   | 30  |
| 79e9b9b4-8b76-4cb7-8419 | Bob     | 23  |
| cb923190-d658-4471-827d | Charlie | 45  |
| 8eabd71d-c1f0-4496-9415 | Dalia   | 28  |
| 2c524549-09f0-4e8e-9afc | Eve     | 36  |

---

### Table `emprunts`

La table `emprunts` contient les informations des emprunts de livres :
- `livre_id` : identifiant du livre emprunté
- `utilisateur_id` : identifiant de l'utilisateur
- `emprunt_id` : identifiant unique de l'emprunt
- `date_emprunt` : date et heure de l'emprunt

Voici des données pour la table `emprunts` :

| livre_id                  | emprunt_id                 | utilisateur_id                 | date_emprunt             |
|--------------------------| ----------------------- | ----------------------- |--------------------------|
| 549d7790-2aa1-4710-88d4  | 437c10d7-5508-4ecf-b821 | 6a6148d1-4a56-4d6a-a610 | 2026-03-31 10:00:00+0000 |
| 616be2d4-d205-4278-ad6d  | dc880752-f900-4454-8993 | 6a6148d1-4a56-4d6a-a610 | 2022-08-06 15:00:00+0000 |
| 549d7790-2aa1-4710-88d4  | 4c63cb26-f5f1-4ca3-bd62 | 79e9b9b4-8b76-4cb7-8419 | 2023-35-22 11:00:00+0000 |
| b3420ae3-88b8-45f7-adc1  | 4e1e806b-872b-421e-a461 | cb923190-d658-4471-827d | 2025-10-03 12:00:00+0000 |
| 0d7c6069-d250-431a-8573  | 8eabd71d-c1f0-4496-9415 | 8eabd71d-c1f0-4496-9415 | 2021-11-14 13:00:00+0000 |
| 2f228bd5-a517-4214-8303  | f93925d8-79e6-461d-ace8 | 2c524549-09f0-4e8e-9afc | 2012-12-05 14:00:00+0000 |

## Commandes CQL

Voici quelques exemples de commandes CQL pour interagir avec la base de données `biblio` qui contient les données des utilisateurs et des emprunts de livres d'une bibliothèque.

### Keyspaces

Cassandra définit des keyspaces pour regrouper les tables. Un keyspace est l'équivalent d'une base de données dans un système de gestion de base de données relationnelle. Les keyspaces ont des propriétés de réplication qui définissent comment les données sont répliquées sur les nœuds du cluster.

- **Création d'un keyspace** :
```sql
CREATE KEYSPACE biblio
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3};
```

- **Changement de keyspace** :
```sql
USE biblio ;
```
    L'instruction `USE` replace le keyspace courant par celui spécifié dans la requête.
    Ainsi, toutes les requêtes suivantes seront exécutées dans le keyspace `biblio`.
    Il n'est pas nécessaire de spécifier le keyspace dans les requêtes suivantes.
    On peut écrire directement `CREATE TABLE utilisateurs (...)` sans spécifier le keyspace.

- **Liste des keyspaces** :
```sql
DESCRIBE KEYSPACES;
```
    Cette commande permet de lister tous les keyspaces disponibles dans le cluster.

- **Description d'un keyspace** :
```sql
DESCRIBE KEYSPACE biblio;
```
    Cette commande permet de voir les détails du keyspace `biblio`.

- **Suppression d'un keyspace** :
  ```sql
  DROP KEYSPACE IF EXISTS biblio;
  ```

### Création de tables

La création de tables en `CQL` est similaire à `SQL`. Il faut veiller à bien définir la clé primaire pour chaque table qui est essentielle pour la distribution des données dans le cluster.

  - __Clé primaire simple__
```sql
CREATE TABLE biblio.utilisateurs (
    id UUID PRIMARY KEY,
    nom TEXT,
    age INT
);
```
  Pour plus d'informations sur les types de données supportés par Apache Cassandra, vous pouvez consulter [la documentation](https://cassandra.apache.org/doc/4.1/cassandra/cql/types.html).

  - __Clé primaire composite__
```sql
CREATE TABLE biblio.emprunts (
    livre_id UUID,
    emprunt_id UUID,
    utilisateur_id UUID,
    date_emprunt TIMESTAMP,
    PRIMARY KEY (emprunt_id, utilisateur_id)
);
```
  Ici nous avons une table qui possède deux colonnes comme clé primaire. Cela signifie que la combinaison de `emprunt_id` et `utilisateur_id` doit être unique.

  - __Clé de clustering__
```sql
CREATE TABLE biblio.emprunts (
    livre_id UUID,
    emprunt_id UUID,
    utilisateur_id UUID,
    date_emprunt TIMESTAMP,
    PRIMARY KEY ((emprunt_id, utilisateur_id), date_emprunt)
) WITH CLUSTERING ORDER BY (date_emprunt DESC);
```
  Ici la clé primaire est composée de `emprunt_id` et `utilisateur_id`, et la clé de clustering est `date_emprunt`.
  On ajoute `WITH CLUSTERING ORDER BY (date_emprunt DESC)` pour trier les données par ordre décroissant de `date_emprunt`.

### Manipulation de données

Une fois que les données sont insérées dans le cluster, il est possible de les manipuler en utilisant des requêtes CQL via les clauses `SELECT`, `INSERT`, `UPDATE` et `DELETE`.

- **Liste des tables** :
```sql
DESCRIBE TABLES;
```
Cette commande permet de lister toutes les tables du keyspace courant.

- **Description d'une table** :
```sql
DESCRIBE TABLE biblio.utilisateurs;
```
Cette commande permet de voir les détails de la table `utilisateurs` du keyspace `biblio`.

- **Insertion de données** :
  ```sql
  INSERT INTO biblio.utilisateurs (id, nom, age)
  VALUES (6a6148d1-4a56-4d6a-a610-cdf7b7e3b959, 'Alice', 30);

  INSERT INTO biblio.utilisateurs (id, nom, age)
  VALUES (uuid(), 'Bob', 23);
  ```
  Ici, l'identifiant de Bob est généré automatiquement par Cassandra via la fonction `uuid()`.

- **Sélection de données** :
```sql
SELECT nom, age FROM biblio.utilisateurs WHERE age > 35;
```
Cette requête permet de sélectionner le nom et l'âge des utilisateurs de plus de 35 ans.

<!--
    dont le résultat est le suivant :

    | nom    | age |
    |---------|-----|
    | Charlie | 45  |
    | Eve     | 36  |
-->

- **Mise à jour de données** :
```sql
UPDATE biblio.utilisateurs SET age = 31 WHERE id = 6a6148d1-4a56-4d6a-a610-cdf7b7e3b959;
```
Ici, on met à jour l'âge d'Alice (qui possède l'identifiant `6a6148d1-4a56-4d6a-a610-cdf7b7e3b959`) de 30 à 31 ans.

- **Suppression de données** :
```sql
DELETE FROM biblio.utilisateurs WHERE id = 6a6148d1-4a56-4d6a-a610-cdf7b7e3b959;
```
De même, qu'il est possible de supprimer les données d'Alice de la table `utilisateurs`. Dans notre cas, il faudrait également supprimer les emprunts d'Alice dans la table `emprunts`.

- **Suppression d'une table** :
```sql
DROP TABLE IF EXISTS biblio.utilisateurs;
```
Si l'on veut supprimer une table, il suffit d'utiliser la commande `DROP TABLE` comme en SQL.

### Index

Les index peuvent être créés pour améliorer les performances des requêtes. Cela permet de rechercher plus rapidement les colonnes qui ne sont pas définies dans la clé de partitionnement.

- **Création d'un index** :
```sql
CREATE INDEX IF NOT EXISTS nom_index ON biblio.utilisateurs (nom);
```

- **Suppression d'un index** :
```sql
DROP INDEX IF EXISTS nom_index;
```

> :warning: **Clé primaire et partitionnement** <br/>
> <br/>
> Il est important de bien choisir la clé de partition et la clé de clustering pour optimiser les performances de la base de données. Aussi, il peut être nécessaire de dupliquer les données pour répondre à différents types de requêtes.<br/>
> <br/>
> Toutes les colonnes qui sont dans la PRIMARY KEY doivent être utilisées dans la clause `WHERE` de la requête `SELECT`. Par exemple, si la clé primaire est composée de `id` et `nom`, la requête `SELECT` doit contenir ces deux colonnes dans la clause `WHERE`.
> ```sql
> SELECT *
> FROM biblio.utilisateurs
> WHERE id = 6a6148d1-4a56-4d6a-a610-cdf7b7e3b959 AND nom = 'Alice';
> ```
{: .block-warning }

Pour plus d'informations sur les commandes CQL, vous pouvez consulter la documentation officielle d'Apache Cassandra :
- [Manipulation de données](https://cassandra.apache.org/doc/4.1/cassandra/cql/ddl.html) : CREATE, ALTER, DROP (table, keyspace)
- [Requêtes](https://cassandra.apache.org/doc/4.1/cassandra/cql/dml.html) : SELECT, INSERT, UPDATE, DELETE


# Initialisation d'une base de données

Pour ce TP, nous allons créer une base de données Apache Cassandra via **Docker**. Docker est une plateforme de conteneurisation qui permet de créer, déployer et exécuter des applications dans des conteneurs. Un conteneur est une unité légère et autonome qui contient tout ce dont une application a besoin pour fonctionner, y compris le code, les packages, les dépendances et les fichiers de configuration.

Pour créer la base de données, il suffit d'exécuter les commandes suivantes dans votre terminal (PowerShell, Git bash, etc.) :

1. Téléchargement de l'image Apache Cassandra en local.
```bash
docker pull cassandra:latest
```
2. Exécuter le serveur `cassandra` en local.
```bash
docker run -d --rm --name cassandra -p 9042:9042 cassandra
```
3. Ensuite, pour accéder à la base de données Cassandra, il faut exécuter la commande suivante :
```bash
docker exec -it cassandra cqlsh
```
Vous devriez voir une sortie similaire à celle-ci, indiquant que vous êtes connecté à la base de données Cassandra et que vous pouvez commencer à exécuter des commandes CQL (après le `cqlsh>`).
```bash
Connected to Test Cluster at 127.0.0.1:9042
[cqlsh 6.2.0 | Cassandra 5.0.6 | CQL spec 3.4.7 | Native protocol v5]
Use HELP for help.
cqlsh>
```

Ainsi, vous accédez à l'interface de ligne de commande de Cassandra, appelée `cqlsh`, qui vous permet d'exécuter des commandes CQL pour interagir avec la base de données. Vous pouvez écrire les commandes CQL directement dans l'interface après le prompt `cqlsh>`. Vous pouvez maintenant créer un keyspace, des tables et insérer des données dans votre base de données Cassandra en utilisant les commandes CQL présentées précédemment.

> Il est possible que vous ayez une `Connection error` lors de l'exécution de la commande `docker exec -it cassandra cqlsh`. Si c'est le cas, attendez quelques secondes et réessayez la commande. Il faut un peu de temps pour que le conteneur Cassandra soit complètement opérationnel et prêt à accepter les connexions.
{: .block-warning }

> Pour ceux qui sont à l'aise avec les notebooks Jupyter, il est également possible d'exécuter des commandes CQL directement dans un notebook en utilisant la bibliothèque `cassandra-driver` de Python. Vous pouvez installer cette bibliothèque via pip :
> ```bash
> pip install cassandra-driver
> ```
> Ensuite, vous pouvez utiliser le code suivant pour vous connecter à la base de données Cassandra et exécuter des commandes CQL :
> ```python
> from cassandra.cluster import Cluster
>
> # Connexion au cluster
> cluster = Cluster(contact_points=['127.0.0.1'], port=9042)
> session = cluster.connect()
>
> # Sélectionner le keyspace
> session.set_keyspace('votre_keyspace')
> # /!\ Replacer votre_keyspace par le nom du keyspace
>
> print("Connected to Cassandra cluster!")
>
> # Exemple de requête
> rows = session.execute("SELECT * FROM system_schema.keyspaces LIMIT 5;")
> for row in rows:
>     print(row)
> ```
{: .block-example }


# Cas pratique

## Objectif

L'objectif de ce TP est de se familiariser avec la base de données `Apache Cassandra` en réalisant les tâches suivantes :
1. Création d'un keyspace et d'une table
2. Insertion de données
3. Requêtes sur les données
4. Suppression de données
5. Mise à jour de données

## Présentation des données

Dans ce TP, vous allez manipuler une base de données Apache Cassandra destinée à stocker des informations sur les cas médicaux et les patients. Pour cela, nous avons accès à 2 jeux de données : d'une part, les cas médicaux et d'autre part, les patients. Chaque cas médical est associé à un patient et à une pathologie, et est identifié par un identifiant unique.

### Cas médicaux

La table `cas_medicaux` contient les informations des cas médicaux :

| Colonne             | Description                       |
|---------------------|-----------------------------------|
| `id`                | Identifiant unique du cas médical |
| `code_patho`        | Code de la pathologie             |
| `date_diag`         | Date du diagnostic                |
| `dept_code`         | Code du département               |
| `dept_nom`          | Nom du département                |
| `pathologie`        | Pathologie diagnostiquée          |
| `patient_date_naissance` | Date de naissance du patient      |
| `patient_prenom`    | Prénom du patient                 |
| `patient_sexe`      | Sexe du patient                   |

---

### Patients

La table `patients` contient les informations des patients :

| Colonne         | Description                     |
|-----------------|---------------------------------|
| `id`            | Identifiant unique du patient   |
| `prenom`        | Prénom du patient               |
| `sexe`          | Sexe du patient                 |
| `date_naissance`| Date de naissance du patient    |
| `pathologies`   | Liste de pathologies du patient |

---

## Requêtage des données

### 1. Création d'un keyspace

Créez un keyspace `hopital`. Étant donné que votre machine correspond à un serveur (unique), nous allons utiliser un facteur de réplication de 1.

Nous allons maintenant peupler ce keyspace avec les tables des cas médicaux et des patients.

### 2. Création du schéma de données

Créez les tables `cas_medicaux` et `patients` dans le keyspace `hopital` avec les colonnes décrites ci-dessus.

### 3. Insertion des données

Insérer dans la table `cas_medicaux` les données du patient `23257`.

| id     | code_patho | date_diag  | dept_code | dept_nom | pathologie         | patient_date_naissance | patient_prenom | patient_sexe |
|--------|------------|------------|-----------|----------|--------------------|-------------------|----------------|--------------|
| 23257  | addictions | 2021-01-12 |        72 |   Sarthe | Troubles addictifs |        1946-08-27 |        Christelle |            f |


Puis, insérer dans la table `patients` les données suivantes :

| id  | date_naissance | pathologies                                                                                                                                                                                                                                                                       | prenom  | sexe|
|-----|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|-----|
| 403 | 1927-02-11     | [{'date': '2021-08-08', 'dept': '09', 'intitule': 'Maladies inflammatoires chroniques'}, {'date': '2023-04-11', 'dept': '09', 'intitule': 'Accident vasculaire cérébral'}, {'date': '2022-07-02', 'dept': '09', 'intitule': 'Maladies métaboliques, héréditaires ou amylose'}]   | Mireille |    f|


Une fois les deux requêtes d'insertion effectuées, vous pouvez insérer les données contenues dans le fichier `init.cql` qui est téléchargeable <a href="/assets/code/init.cql" download>ici</a>.

### 4. Requêtes sur les données

1) Afficher les 5 premiers cas médicaux.

2) Afficher les patients ayant les identifiants `408` et `500`.

3) Quel est le résultat de la requête suivante ?

```sql
SELECT *
FROM cas_medicaux
WHERE pathologie='Diabète';
```

Est-elle valide ? Si non, que faire pour corriger cette requête ?

4) Mettre à jour la pathologie du patient `66` pour remplacer `Diabète` par `Diabète de type 2` (champ `pathologie`).

5) Supprimer les informations concernant le cas médical `23265` (patient Clément).

6) Comment requêter les patients vivant dans le département de la Sarthe ? Que feriez-vous ?

7) Créer une nouvelle table `patients_pathologie_dept` avec les champs suivants :

| Colonne           | Type |
|-------------------|------|
| `id`              | TEXT |
| `prenom`          | TEXT |
| `sexe`            | TEXT |
| `date_naissance`  | DATE |
| `pathologie_nom`  | TEXT |
| `pathologie_date` | DATE |
| `dept`            | TEXT |

Où `dept` est la clé primaire.

8) Insérer les données des patients ayant des pathologies dans la table `patients_pathologie_dept` qui sont <a href="/assets/code/init_dept.cql" download>ici</a> puis répondre à la question 6.

:tada: Bravo, vous venez de requêter des données de santé stockées dans une base de données Apache Cassandra avec CQL !


<!--

## Requêtage des données

### 1. Création d'un keyspace

Nous allons créér un keyspace `hopital` que nous allons donc utiliser pour stocker nos données.

Question 1 : Créer un keyspace hopital avec une réplication simple.

```sql
CREATE KEYSPACE hopital
WITH REPLICATION = {
  'class' : 'SimpleStrategy',
  'replication_factor' : 1
};
USE hopital;
```

### 2. Création du schéma de données

Question 1.3 : Créer une table patients avec les champs suivants : patient_id (UUID), nom (TEXT), prenom (TEXT), date_naissance (DATE).
Corrigé : CREATE TABLE patients (
  patient_id UUID PRIMARY KEY,
  nom TEXT,
  prenom TEXT,
  date_naissance DATE
);

Partie 2 : Modélisation des données et requêtes de base (1h)
Objectif : Comprendre la modélisation des données et effectuer des requêtes CRUD.
Question 2.1 : Insérer 3 patients dans la table patients.
Corrigé : INSERT INTO patients (patient_id, nom, prenom, date_naissance)
VALUES (uuid(), 'Dupont', 'Jean', '1980-05-15');
INSERT INTO patients (patient_id, nom, prenom, date_naissance)
VALUES (uuid(), 'Martin', 'Marie', '1990-08-22');
INSERT INTO patients (patient_id, nom, prenom, date_naissance)
VALUES (uuid(), 'Bernard', 'Pierre', '1975-11-30');
Question 2.2 : Créer une table consultations avec une clé de partition et une clé de clustering pour stocker les consultations d’un patient, triées par date décroissante.
Corrigé : CREATE TABLE consultations (
  patient_id UUID,
  consultation_id UUID,
  medecin_id UUID,
  date_heure TIMESTAMP,
  diagnostic TEXT,
  traitement TEXT,
  PRIMARY KEY ((patient_id), date_heure, consultation_id)
) WITH CLUSTERING ORDER BY (date_heure DESC);
Question 2.3 : Insérer 2 consultations pour un patient existant.
Corrigé : INSERT INTO consultations (patient_id, consultation_id, medecin_id, date_heure, diagnostic, traitement)
VALUES (uuid(), uuid(), uuid(), toTimestamp(now()), 'Grippe', 'Paracétamol');
INSERT INTO consultations (patient_id, consultation_id, medecin_id, date_heure, diagnostic, traitement)
VALUES (uuid(), uuid(), uuid(), toTimestamp(now() - 10), 'Allergie', 'Antihistaminiques');
Question 2.4 : Écrire une requête pour lister toutes les consultations d’un patient, triées par date décroissante.
Corrigé : SELECT * FROM consultations WHERE patient_id = ?;

Partie 3 : Optimisation et requêtes avancées (1h)
Objectif : Utiliser des index secondaires, des collections, et des requêtes batch.
Question 3.1 : Ajouter un index secondaire sur le champ diagnostic pour permettre des recherches par diagnostic.
Corrigé : CREATE INDEX ON consultations (diagnostic);
Question 3.2 : Écrire une requête pour trouver tous les patients ayant eu un diagnostic de "Grippe".
Corrigé : SELECT * FROM consultations WHERE diagnostic = 'Grippe' ALLOW FILTERING;
Question 3.3 : Modifier la table consultations pour ajouter une collection symptomes (liste de TEXT).
Corrigé : ALTER TABLE consultations ADD symptomes LIST<TEXT>;
Question 3.4 : Mettre à jour une consultation pour ajouter des symptômes.
Corrigé : UPDATE consultations
SET symptomes = ['fièvre', 'toux']
WHERE patient_id = ? AND date_heure = ? AND consultation_id = ?;
-->

<!--

Cas d’usage : Gestion de Dossiers Patients
Scénario
Vous travaillez pour un hôpital qui souhaite stocker les dossiers patients de manière sécurisée, scalable et disponible. Chaque dossier contient :

Identifiant unique du patient
Nom, prénom, date de naissance
Historique des consultations (date, médecin, diagnostic, traitement)
Allergies et antécédents médicaux

Modélisation des données
Dans Cassandra, on pense requêtes avant tables. Voici les requêtes principales :

Trouver un patient par son identifiant.
Lister l’historique des consultations d’un patient.
Trouver tous les patients ayant consulté un médecin donné.
Schéma proposé
```sql

-- Création du keyspace (équivalent d'une base de données)
CREATE KEYSPACE hospital WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

-- Utilisation du keyspace
USE hospital;

-- Table Patients
CREATE TABLE patients (
    patient_id UUID PRIMARY KEY,
    nom TEXT,
    prenom TEXT,
    date_naissance DATE,
    allergies SET<TEXT>,
    antecedents LIST<TEXT>
);

-- Table Consultations (historique par patient)
CREATE TABLE consultations (
    patient_id UUID,
    consultation_date TIMESTAMP,
    medecin TEXT,
    diagnostic TEXT,
    traitement TEXT,
    PRIMARY KEY ((patient_id), consultation_date)
) WITH CLUSTERING ORDER BY (consultation_date DESC);

-- Table Consultations par médecin (pour la requête 3)
CREATE TABLE consultations_par_medecin (
    medecin TEXT,
    patient_id UUID,
    consultation_date TIMESTAMP,
    diagnostic TEXT,
    traitement TEXT,
    PRIMARY KEY ((medecin), consultation_date, patient_id)
) WITH CLUSTERING ORDER BY (consultation_date DESC);
```

4. Manipulation des données avec CQL
Insertion de données

```sql
-- Insertion d'un patient
INSERT INTO patients (patient_id, nom, prenom, date_naissance, allergies, antecedents)
VALUES (uuid(), 'Dupont', 'Jean', '1980-05-15', {'penicilline'}, ['diabète', 'hypertension']);

-- Insertion d'une consultation
INSERT INTO consultations (patient_id, consultation_date, medecin, diagnostic, traitement)
VALUES (uuid(), toTimestamp(now()), 'Dr Martin', 'Grippe', 'Paracétamol');

-- Insertion dans la table consultations_par_medecin
INSERT INTO consultations_par_medecin (medecin, patient_id, consultation_date, diagnostic, traitement)
VALUES ('Dr Martin', uuid(), toTimestamp(now()), 'Grippe', 'Paracétamol');
```

Requêtes

```sql
-- 1. Trouver un patient par son identifiant
SELECT * FROM patients WHERE patient_id = ?

-- 2. Lister l’historique des consultations d’un patient
SELECT * FROM consultations WHERE patient_id = ?

-- 3. Trouver tous les patients ayant consulté un médecin donné
SELECT * FROM consultations_par_medecin WHERE medecin = 'Dr Martin';
```

5. Exercices pratiques avec corrections
Exercice 1 : Modélisation
Question : Proposez un schéma pour stocker les résultats de laboratoire (type d’analyse, date, résultat, patient).

Correction :
```sql
CREATE TABLE resultats_labo (
    patient_id UUID,
    date_analyse TIMESTAMP,
    type_analyse TEXT,
    resultat TEXT,
    PRIMARY KEY ((patient_id), date_analyse)
) WITH CLUSTERING ORDER BY (date_analyse DESC);
```
Exercice 2 : Requêtes
Question : Écrivez les requêtes CQL pour :

Lister tous les patients allergiques à la pénicilline.
Trouver le nombre de consultations par médecin.

Correction :
```sql
-- Patients allergiques à la pénicilline
SELECT * FROM patients WHERE allergies CONTAINS 'penicilline' ALLOW FILTERING;

-- Nombre de consultations par médecin
SELECT medecin, COUNT(*) FROM consultations_par_medecin GROUP BY medecin;
```

Exercice 3 : Optimisation
Question : Comment optimiseriez-vous la table consultations_par_medecin si l’hôpital a 10 000 médecins ?

Correction :

Utiliser une clé de partition plus fine (ex : medecin_specialite).
Limiter le nombre de partitions par nœud.
Éviter les partitions trop grosses en répartissant les données.

-->
