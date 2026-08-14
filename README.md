# DeegiNews

Application Flutter full-stack d'actualités avec authentification,
API REST, cache local et mode hors-ligne.

## Fonctionnalités

- Inscription et connexion
- Déconnexion
- Authentification Supabase / JWT
- Actualités depuis une API REST
- Catégories
- Détail d'un article
- Cache local avec Hive
- Mode hors-ligne
- Gestion des erreurs réseau
- Navigation avec Riverpod

## Architecture

Feature-First :

lib/
├── core/
├── features/
│   ├── auth/
│   ├── home/
│   ├── news/
│   └── profile/
└── main.dart

## Technologies

- Flutter
- Dart
- Riverpod
- Dio
- Supabase
- Hive
- connectivity_plus
- Mocktail

## API

Les données d'actualités sont stockées dans PostgreSQL
via Supabase et accessibles avec la Data API REST.

## Cache et mode hors-ligne

Les actualités récupérées depuis l'API sont sauvegardées
localement avec Hive.

Lorsque l'API devient inaccessible, le Repository récupère
automatiquement les dernières données disponibles dans le cache.

## Tests

Les tests couvrent notamment :

- récupération réussie depuis l'API
- fallback vers le cache
- gestion d'une erreur sans données en cache

## Installation

```bash
flutter pub get
flutter run