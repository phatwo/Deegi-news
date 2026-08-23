# DeegiNews 📰

DeegiNews est une application Flutter full-stack d'actualités connectée à une API REST Supabase.

L'application propose une authentification utilisateur, la consultation d'actualités, des catégories, le détail d'un article, un cache local avec Hive et un fonctionnement hors ligne.

## ✨ Fonctionnalités

- Inscription
- Connexion
- Déconnexion
- Authentification avec Supabase Auth et JWT
- Renouvellement de session géré par Supabase
- Liste des actualités
- Consultation des catégories
- Détail d'un article
- Recherche des données via API REST
- Cache local avec Hive
- Mode hors-ligne
- Gestion des erreurs réseau
- Actualisation des données
- Navigation avec Riverpod
- Tests unitaires du Repository

## 🏗️ Architecture

Le projet utilise une architecture **Feature-First** avec séparation des responsabilités.

```text
lib/
├── core/
│   └── network/
│       ├── dio_client.dart
│       ├── auth_interceptor.dart
│       ├── network_providers.dart
│       └── connectivity_provider.dart
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
│   │       ├── news_screen.dart
│   │       ├── categories_screen.dart
│   │       ├── article_detail_screen.dart
│   │       └── news_provider.dart
│   │
│   └── profile/
│       └── presentation/
│           └── profile_screen.dart
│
└── main.dart