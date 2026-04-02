---
layout: formation
title: Introduction
description: Qu'est-ce que git ?
importance: 1
category: Git
permalink: /git/introduction/
type: formation
visible: true
#toc:
#  sidebar: left
mermaid:
  enabled: true
  zoomable: true
---

https://github.com/adrienjoly/cours-git
https://www.pierre-giraud.com/git-github-apprendre-cours/
https://perso.liris.cnrs.fr/pierre-antoine.champin/enseignement/intro-git/#
https://grafikart.fr/tutoriels/git
https://learngitbranching.js.org/

# Objectifs

Les objectifs de ce parcours sont multiples :
- Comprendre l'intérêt de git et des systèmes de gestion de versions (SGV)
- Maitriser les commandes de base de git
- Savoir résoudre les conflits
- Pouvoir collaborer sur des projets Open Source

# Qu'est-ce que git ?

# Installation de git

## Linux/MacOS
Pour Linux et MacOS, git est généralement pré-installé. Pour vérifier si git est installé, vous pouvez exécuter la commande suivante dans votre terminal :

```bash
git --version
```
Si git n'est pas installé, vous pouvez l'installer en utilisant le gestionnaire de paquets de votre système. Par exemple, sur Ubuntu, vous pouvez utiliser :

```bash
sudo apt install git
```

## Windows

Pour Windows, vous pouvez télécharger l'installateur depuis le site officiel de [git](https://git-scm.com/download/win).

# Configuration de git

Après l'installation, vous devez configurer votre nom d'utilisateur et votre adresse e-mail. Ces informations seront utilisées pour identifier les auteurs des commits. Vous pouvez le faire en exécutant les commandes suivantes dans votre terminal :

```bash
git config --global user.name "Jane Doe"
git config --global user.email "janedoe@mail.com"
```
