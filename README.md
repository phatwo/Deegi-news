# DeegiNews 📰

DeegiNews est une application Flutter full-stack d'actualités connectée à une API REST réelle avec authentification, cache local et mode hors-ligne.

L'objectif du projet est de mettre en pratique une architecture Flutter moderne, le Repository Pattern, les appels REST avec Dio, l'authentification JWT et la persistance locale.

## Fonctionnalités

* Inscription
* Connexion
* Déconnexion
* Authentification avec Supabase Auth
* Gestion de session et JWT
* Liste des actualités
* Consultation des catégories
* Détail d'un article
* Appels API REST avec Dio
* Injection automatique du token avec un intercepteur
* Cache local avec Hive
* Mode hors-ligne
* Gestion des erreurs réseau
* Actualisation des données
* Navigation avec Riverpod
* Tests unitaires du Repository
* CI avec GitHub Actions

## Architecture

Le projet utilise une architecture **Feature-First** avec séparation des responsabilités entre les couches de données, du domaine et de la présentation.

```text
lib/
├── core/
│   └── network/
│       ├── auth_interceptor.dart
│       ├── connectivity_provider.dart
│       ├── dio_client.dart
│       └── network_providers.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   └── auth_repository.dart
│   │   └── presentation/
│   │       ├── auth_gate.dart
│   │       ├── auth_provider.dart
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   │
│   ├── home/
│   │   └── presentation/
│   │       └── main_shell.dart
│   │
│   ├── news/
│   │   ├── data/
│   │   │   ├── news_local_data_source.dart
│   │   │   ├── news_remote_data_source.dart
│   │   │   └── news_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── news_article.dart
│   │   │   └── news_repository.dart
│   │   └── presentation/
│   │       ├── article_detail_screen.dart
│   │       ├── categories_screen.dart
│   │       ├── news_provider.dart
│   │       └── news_screen.dart
│   │
│   └── profile/
│       └── presentation/
│           └── profile_screen.dart
│
└── main.dart
```

### Flux général

```text
Presentation
     ↓
Riverpod
     ↓
Repository
     ↓
Remote Data Source / Local Data Source
     ↓
Dio / Hive
     ↓
Supabase REST API / stockage local
```

## Technologies

* Flutter
* Dart
* Riverpod
* Dio
* Supabase
* Hive
* connectivity_plus
* Mocktail
* GitHub Actions

## API REST

Les actualités sont stockées dans PostgreSQL avec Supabase et exposées via la Data API REST.

### Écran Actualités

```http
GET /rest/v1/news
```

Récupère la liste des actualités.

### Écran Catégorie

```http
GET /rest/v1/news?category=eq.Technologie
```

Récupère les articles correspondant à une catégorie.

### Écran Détail

```http
GET /rest/v1/news?id=eq.1
```

Récupère un article précis à partir de son identifiant.

Les appels REST passent par Dio et utilisent l'intercepteur d'authentification.

## Authentification

L'authentification est assurée par **Supabase Auth**.

```text
Register
   ↓
Supabase Auth
   ↓
Session utilisateur
   ↓
JWT
   ↓
AuthInterceptor
   ↓
API REST
```

L'application utilise la session Supabase courante pour les requêtes authentifiées.

Le SDK Supabase assure également la gestion de la session et le renouvellement des tokens lorsque cela est applicable.

## Intercepteur JWT

L'intercepteur ajoute automatiquement le token courant aux requêtes HTTP.

```text
Requête Dio
    ↓
AuthInterceptor
    ↓
Authorization: Bearer <access_token>
    ↓
API REST Supabase
```

Cette approche évite de répéter manuellement le token dans chaque appel réseau.

## Cache local

Les actualités récupérées depuis l'API sont sauvegardées localement avec **Hive**.

```text
API
 ↓
NewsRepository
 ↓
Hive
```

Le cache permet de conserver les dernières données téléchargées localement.

## Mode hors-ligne

Lorsque l'API n'est plus accessible :

```text
API
 ↓
Erreur réseau
 ↓
Repository
 ↓
Cache Hive
 ↓
Données disponibles localement
```

L'application affiche alors :

```text
Mode hors-ligne — données enregistrées affichées
```

Le mode hors-ligne a été testé sur Android.

## Gestion des erreurs

L'application prend en charge notamment :

* erreurs de connexion ;
* erreurs Dio ;
* absence de données ;
* article introuvable ;
* erreurs d'authentification.

Lorsqu'une requête échoue, l'utilisateur reçoit un message et peut relancer la requête lorsque cela est possible.

## Tests

Les tests unitaires couvrent la couche Repository.

Les scénarios testés comprennent :

1. récupération réussie depuis l'API ;
2. utilisation du cache lorsque l'API échoue ;
3. remontée d'une erreur lorsque l'API et le cache sont indisponibles ;
4. sauvegarde des données après une récupération réussie ;
5. absence de sauvegarde lorsque la requête API échoue.

### Lancer les tests

```bash
flutter test
```

### Vérifier le code

```bash
flutter analyze
```

## Configuration

Le projet utilise des variables d'environnement pour les informations Supabase.

Créer un fichier `.env` à la racine :

```text
SUPABASE_URL=https://YOUR_PROJECT.supabase.co
SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
```

Le fichier `.env` ne doit pas être versionné.

Un fichier `.env.example` est fourni :

```text
SUPABASE_URL=https://YOUR_PROJECT.supabase.co
SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
```

## Installation

Cloner le projet :

```bash
git clone https://github.com/USERNAME/deegi_news.git
cd deegi_news
```

Installer les dépendances :

```bash
flutter pub get
```

Configurer le fichier `.env`, puis lancer :

```bash
flutter run
```

## Configuration Supabase

Créer un projet sur Supabase puis récupérer :

* la Project URL ;
* la Publishable Key.

Créer une table `news` avec les champs suivants :

```text
id
title
description
image_url
category
source
published_at
created_at
```

La table doit être protégée par les règles RLS appropriées.

## CI/CD

Le projet utilise **GitHub Actions** pour automatiser les contrôles du code.

À chaque `push` ou `pull request` vers `main`, le workflow :

1. installe Flutter ;
2. installe les dépendances ;
3. exécute `flutter analyze` ;
4. exécute `flutter test`.

```text
Push / Pull Request
        ↓
GitHub Actions
        ↓
Flutter setup
        ↓
flutter pub get
        ↓
flutter analyze
        ↓
flutter test
```

Le build APK release est effectué localement.

## Générer l'APK

```bash
flutter build apk --release
```

L'APK générée se trouve dans :

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Vérification finale

Avant la livraison :

```bash
flutter analyze
flutter test
flutter build apk --release
```

## Navigation

```text
AuthGate
   │
   ├── Login
   │     └── Register
   │
   └── MainShell
         ├── Actualités
         ├── Catégories
         └── Profil
                └── Déconnexion
```

## Auteur

Projet réalisé dans le cadre d'un projet Full-Stack Flutter.

## Licence

Projet réalisé à des fins pédagogiques.
