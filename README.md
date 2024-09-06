# Projet "Mots Magiques" en Prolog

## Description

Le projet "Mots Magiques" est une implémentation en Prolog d'un système pour manipuler des suites d'entiers représentées comme des mots. Ce projet inclut un résolveur et un générateur pour un casse-tête combinatoire basé sur des mots magiques, utilisant des règles de réécriture pour transformer ou générer des mots magiques.

## Fonctionnalités

- **Résolveur de casse-tête** : Calcule toutes les solutions possibles d'une longueur donnée pour une instance spécifique de casse-tête.
- **Générateur de casse-tête** : Produit des mots magiques, avec des solutions de longueur spécifiée, utilisant un ensemble de règles de réécriture.

## Composants

- `MagicWords.pl` : Cœur de l'application, contenant la logique principale pour le traitement des mots magiques.
- `Tests.pl` : Ensemble de tests pour valider les fonctionnalités du programme.

## Concepts Clés

- **Mots magiques** : Suites finies d'entiers strictement positifs, manipulées selon des règles de réécriture.
- **Règles de réécriture** : Mécanismes permettant de transformer un mot en un autre, essentiels pour résoudre et générer des casse-têtes.

## Utilisation

- **Résolution de casse-tête** : Fournir une instance de casse-tête pour obtenir toutes les solutions possibles.
- **Génération de casse-tête** : Définir un ensemble de règles de réécriture et une longueur de solution pour générer de nouveaux mots magiques.

## Prédicats Principaux

- `all_puzzle_solutions(_puzzle, _len, _solutions)` : Relie une instance de casse-tête à ses solutions possibles.
- `all_magic_words_of_rule_set(_rule_set, _len, _magic_words)` : Génère des mots magiques pour un ensemble de règles donné.

## Prédicats Intermédiaires

- Prédicats d'impression pour visualiser les mots, règles, et solutions.
- Prédicats de manipulation pour appliquer les règles de réécriture.

## Exemple d'Application
Une instance du casse-tête est définie par un couple (R, w), où R est un ensemble de règles de réécriture et w est un mot R-magique. Le système peut alors déterminer si w est R-magique et, si c'est le cas, trouver la suite de réécritures qui le prouve.
