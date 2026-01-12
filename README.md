# Salon App - Application de Réservation de Salons de Coiffure

Application Flutter pour la réservation de salons de coiffure avec deux interfaces : **Client** et **Propriétaire de Salon**.

## 🏗️ Architecture

Ce projet utilise **Clean Architecture** avec les technologies suivantes :

- **Flutter** : Framework de développement
- **Riverpod** : Gestion d'état réactive
- **GoRouter** : Navigation déclarative
- **Dio** : Client HTTP
- **Clean Architecture** : Séparation en couches (Domain, Data, Presentation)

Pour plus de détails sur l'architecture, consultez [ARCHITECTURE.md](ARCHITECTURE.md).

## 📁 Structure du Projet

```
lib/
├── core/                    # Infrastructure partagée
│   ├── constants/          # Constantes (couleurs, endpoints)
│   ├── network/            # Client HTTP (Dio)
│   ├── storage/            # Gestion du stockage local
│   ├── providers/          # Providers Riverpod core
│   ├── screens/            # Écrans core (splash, user type selection)
│   └── utils/              # Utilitaires
│
├── features/               # Features métier
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
└── routes/                 # Configuration de navigation
```

## 🚀 Démarrage Rapide

### Prérequis

- Flutter SDK (version 3.10.4 ou supérieure)
- Dart SDK
- Un éditeur de code (VS Code, Android Studio, etc.)

### Installation

1. **Cloner le projet**
   ```bash
   git clone <repository-url>
   cd salon_app
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Générer le code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configurer l'environnement**
   
   Créer un fichier `.env` à la racine du projet :
   ```env
   API_BASE_URL=https://salonappmysql.000webhostapp.com
   ```

5. **Lancer l'application**
   ```bash
   flutter run
   ```

## 📱 Fonctionnalités

### Interface Client
- ✅ Authentification (inscription, connexion, vérification email)
- ✅ Recherche de salons par localisation
- ✅ Affichage des détails d'un salon
- ✅ Réservation de créneaux horaires
- ✅ Consultation des réservations
- ✅ Gestion du profil utilisateur
- ✅ Upload de photo de profil

### Interface Propriétaire
- ✅ Connexion propriétaire
- ✅ Consultation des réservations du jour
- ✅ Appel direct aux clients

## 🛠️ Technologies

- **Flutter** : Framework de développement mobile
- **Riverpod** : Gestion d'état
- **GoRouter** : Navigation
- **Dio** : Client HTTP
- **SharedPreferences** : Stockage local
- **flutter_dotenv** : Variables d'environnement
- **google_fonts** : Polices Google
- **image_picker** : Sélection d'images

## 📝 Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) : Documentation détaillée de l'architecture
- [TODO_ARCHITECTURE.md](TODO_ARCHITECTURE.md) : Liste des tâches de migration

## 🔐 Sécurité

- Les URLs API sont chargées depuis `.env` (non commitées dans Git)
- Les tokens sont stockés de manière sécurisée
- Validation des entrées utilisateur
- Gestion d'erreurs centralisée

## 📄 Licence

Ce projet est privé.

## 👥 Contribution

Pour contribuer au projet, veuillez suivre les conventions de code définies dans [ARCHITECTURE.md](ARCHITECTURE.md).
