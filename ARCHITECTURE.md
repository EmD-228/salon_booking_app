# Architecture du Projet Salon App

## 📐 Vue d'ensemble

Ce projet utilise **Clean Architecture** avec **Flutter** et suit les principes de séparation des responsabilités en couches distinctes.

## 🏗️ Structure du Projet

```
lib/
├── core/                    # Infrastructure partagée
│   ├── constants/          # Constantes (couleurs, endpoints, etc.)
│   ├── network/            # Client HTTP (Dio)
│   ├── storage/            # Gestion du stockage local
│   ├── providers/          # Providers Riverpod core
│   ├── screens/            # Écrans core (splash, user type selection)
│   └── utils/              # Utilitaires (error handler, env helper)
│
├── features/               # Features métier (Clean Architecture)
│   ├── auth/               # Authentification
│   ├── salon/              # Gestion des salons
│   ├── booking/            # Réservations
│   ├── profile/            # Profil utilisateur
│   └── owner/              # Interface propriétaire
│
├── shared/                 # Composants partagés
│   ├── widgets/            # Widgets réutilisables
│   └── theme/              # Thème de l'application
│
└── routes/                 # Configuration de navigation (GoRouter)
```

## 🎯 Clean Architecture

Chaque feature suit le pattern Clean Architecture avec 3 couches :

### 1. Domain Layer (Couche Métier)
- **Entities** : Entités métier pures (sans dépendances)
- **Repositories** : Interfaces définissant les contrats
- **Usecases** : Logique métier réutilisable

### 2. Data Layer (Couche Données)
- **Models** : Modèles de données avec sérialisation JSON
- **DataSources** : Sources de données (Remote, Local)
- **Repository Implementations** : Implémentations concrètes des repositories

### 3. Presentation Layer (Couche Présentation)
- **Screens** : Écrans de l'application
- **Providers** : Gestion d'état avec Riverpod
- **Widgets** : Widgets spécifiques à la feature

## 🔧 Technologies Utilisées

### Gestion d'État
- **Riverpod** : Gestion d'état réactive et type-safe
- **Notifier API** : API moderne de Riverpod pour la gestion d'état

### Navigation
- **GoRouter** : Navigation déclarative et type-safe

### Réseau
- **Dio** : Client HTTP avec interceptors
- **Retrofit** : (Optionnel) Génération de code pour les API

### Stockage Local
- **SharedPreferences** : Wrappé dans `LocalStorage` pour une interface type-safe

### Code Generation
- **json_serializable** : Sérialisation/désérialisation JSON
- **build_runner** : Génération de code

### Autres
- **flutter_dotenv** : Gestion des variables d'environnement
- **google_fonts** : Polices Google
- **equatable** : Comparaison d'objets

## 📦 Structure d'une Feature

Exemple avec la feature `auth` :

```
features/auth/
├── domain/
│   ├── entities/
│   │   └── user.dart              # Entité User
│   ├── repositories/
│   │   └── auth_repository.dart   # Interface du repository
│   └── usecases/
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       └── ...
│
├── data/
│   ├── models/
│   │   └── user_model.dart        # Modèle avec sérialisation JSON
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   └── auth_local_datasource.dart
│   ├── repositories/
│   │   └── auth_repository_impl.dart
│   └── providers/
│       └── auth_data_providers.dart
│
└── presentation/
    ├── screens/
    │   ├── login_screen.dart
    │   └── ...
    ├── providers/
    │   └── auth_providers.dart     # Providers Riverpod
    └── widgets/
```

## 🔄 Flux de Données

```
UI (Screen)
    ↓
Provider (Riverpod Notifier)
    ↓
Usecase
    ↓
Repository (Interface)
    ↓
Repository Implementation
    ↓
DataSource (Remote/Local)
    ↓
API / Local Storage
```

## 🎨 Conventions de Nommage

### Fichiers
- **Screens** : `*_screen.dart` (ex: `login_screen.dart`)
- **Widgets** : `*_widget.dart` (ex: `custom_button_widget.dart`)
- **Providers** : `*_providers.dart` (ex: `auth_providers.dart`)
- **Models** : `*_model.dart` (ex: `user_model.dart`)
- **Entities** : Nom simple (ex: `user.dart`)
- **Repositories** : `*_repository.dart` ou `*_repository_impl.dart`
- **Usecases** : `*_usecase.dart` (ex: `login_usecase.dart`)

### Classes
- **Screens** : `*Screen` (ex: `LoginScreen`)
- **Widgets** : `*Widget` (ex: `CustomButtonWidget`)
- **Providers** : `*Notifier` ou `*Provider` (ex: `AuthNotifier`)
- **Models** : `*Model` (ex: `UserModel`)
- **Entities** : Nom simple (ex: `User`)
- **Repositories** : `*Repository` ou `*RepositoryImpl`
- **Usecases** : `*Usecase` (ex: `LoginUsecase`)

## 🚀 Démarrage Rapide

### 1. Installation des dépendances
```bash
flutter pub get
```

### 2. Génération du code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Configuration de l'environnement
Créer un fichier `.env` à la racine du projet :
```
API_BASE_URL=https://salonappmysql.000webhostapp.com
```

### 4. Lancer l'application
```bash
flutter run
```

## 📝 Bonnes Pratiques

1. **Séparation des responsabilités** : Chaque couche a une responsabilité unique
2. **Dépendances unidirectionnelles** : Domain ne dépend de rien, Data dépend de Domain, Presentation dépend de Domain et Data
3. **Testabilité** : Chaque couche peut être testée indépendamment
4. **Réutilisabilité** : Les usecases peuvent être réutilisés dans différents contextes
5. **Type Safety** : Utilisation de types stricts et null-safety

## 🔐 Sécurité

- Les URLs API sont chargées depuis `.env` (non commitées)
- Les tokens sont stockés de manière sécurisée via `LocalStorage`
- Validation des entrées utilisateur dans les usecases
- Gestion d'erreurs centralisée

## 📚 Ressources

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

