# 📋 Todo Liste - Migration Architecture

## Vue d'ensemble
Migration du projet vers **Clean Architecture + Riverpod + GoRouter**

**Total des tâches : 62**

---

## 🚀 Phase 1 : Setup & Configuration (7 tâches)

### Setup de base
- [ ] **setup-1** : Ajouter les dépendances nécessaires (riverpod, go_router, dio, freezed, etc.) dans pubspec.yaml
- [ ] **setup-2** : Créer la structure de dossiers Clean Architecture (core/, features/, shared/, routes/)
- [ ] **setup-3** : Configurer flutter_dotenv et créer les fichiers .env pour les variables d'environnement

### Core Infrastructure
- [ ] **setup-4** : Créer core/network/api_client.dart avec Dio et gestion des erreurs
- [ ] **setup-5** : Créer core/storage/local_storage.dart pour wrapper SharedPreferences
- [ ] **setup-6** : Créer core/utils/error_handler.dart pour gestion centralisée des erreurs
- [ ] **setup-7** : Créer core/constants/ avec app_constants.dart, api_endpoints.dart, app_colors.dart

---

## 🔐 Phase 2 : Feature Authentication (12 tâches)

### Domain Layer
- [ ] **auth-1** : Créer feature/auth/domain/entities/user.dart
- [ ] **auth-5** : Créer feature/auth/domain/repositories/auth_repository.dart (interface)
- [ ] **auth-6** : Créer feature/auth/domain/usecases/ (login, register, logout, verify_email)

### Data Layer
- [ ] **auth-2** : Créer feature/auth/data/models/user_model.dart avec json_serializable
- [ ] **auth-3** : Créer feature/auth/data/datasources/auth_remote_datasource.dart
- [ ] **auth-4** : Créer feature/auth/data/datasources/auth_local_datasource.dart
- [ ] **auth-7** : Créer feature/auth/data/repositories/auth_repository_impl.dart avec Riverpod

### Presentation Layer
- [ ] **auth-8** : Créer feature/auth/presentation/providers/auth_providers.dart avec Riverpod
- [ ] **auth-9** : Migrer login_screen.dart vers la nouvelle architecture avec Riverpod
- [ ] **auth-10** : Migrer register_screen.dart vers la nouvelle architecture
- [ ] **auth-11** : Migrer email_verify_screen.dart vers la nouvelle architecture
- [ ] **auth-12** : Migrer forget_password et change_password vers la nouvelle architecture

---

## 💇 Phase 3 : Feature Salon (10 tâches)

### Domain Layer
- [ ] **salon-1** : Créer feature/salon/domain/entities/salon.dart
- [ ] **salon-4** : Créer feature/salon/domain/repositories/salon_repository.dart
- [ ] **salon-5** : Créer feature/salon/domain/usecases/ (get_salons, search_salons, get_salon_details)

### Data Layer
- [ ] **salon-2** : Créer feature/salon/data/models/salon_model.dart
- [ ] **salon-3** : Créer feature/salon/data/datasources/salon_remote_datasource.dart
- [ ] **salon-6** : Créer feature/salon/data/repositories/salon_repository_impl.dart

### Presentation Layer
- [ ] **salon-7** : Créer feature/salon/presentation/providers/salon_providers.dart
- [ ] **salon-8** : Migrer HomePage.dart vers home_screen.dart avec Riverpod
- [ ] **salon-9** : Migrer search_location.dart vers la nouvelle architecture
- [ ] **salon-10** : Migrer bookscreen.dart vers salon_detail_screen.dart

---

## 📅 Phase 4 : Feature Booking (10 tâches)

### Domain Layer
- [ ] **booking-1** : Créer feature/booking/domain/entities/booking.dart et time_slot.dart
- [ ] **booking-4** : Créer feature/booking/domain/repositories/booking_repository.dart
- [ ] **booking-5** : Créer feature/booking/domain/usecases/ (get_time_slots, create_booking, get_bookings)

### Data Layer
- [ ] **booking-2** : Créer feature/booking/data/models/booking_model.dart et time_slot_model.dart
- [ ] **booking-3** : Créer feature/booking/data/datasources/booking_remote_datasource.dart
- [ ] **booking-6** : Créer feature/booking/data/repositories/booking_repository_impl.dart

### Presentation Layer
- [ ] **booking-7** : Créer feature/booking/presentation/providers/booking_providers.dart
- [ ] **booking-8** : Migrer available_time_slot.dart vers time_slot_screen.dart
- [ ] **booking-9** : Migrer checkbooking.dart vers bookings_list_screen.dart
- [ ] **booking-10** : Migrer booked.dart vers booking_confirmation_screen.dart

---

## 👤 Phase 5 : Feature Profile (7 tâches)

### Domain & Data Layers
- [ ] **profile-1** : Créer feature/profile/data/datasources/profile_remote_datasource.dart
- [ ] **profile-2** : Créer feature/profile/domain/repositories/profile_repository.dart
- [ ] **profile-3** : Créer feature/profile/domain/usecases/ (get_profile, update_profile, upload_image)
- [ ] **profile-4** : Créer feature/profile/data/repositories/profile_repository_impl.dart

### Presentation Layer
- [ ] **profile-5** : Créer feature/profile/presentation/providers/profile_providers.dart
- [ ] **profile-6** : Migrer profile_screen.dart vers profile_screen.dart avec Riverpod
- [ ] **profile-7** : **Corriger l'upload d'image pour utiliser multipart/form-data correctement** ⚠️

---

## 🏪 Phase 6 : Feature Owner (8 tâches)

### Domain & Data Layers
- [ ] **owner-1** : Créer feature/owner/domain/entities/owner.dart
- [ ] **owner-2** : Créer feature/owner/data/datasources/owner_remote_datasource.dart
- [ ] **owner-3** : Créer feature/owner/domain/repositories/owner_repository.dart
- [ ] **owner-4** : Créer feature/owner/domain/usecases/ (login_owner, get_today_bookings)
- [ ] **owner-5** : Créer feature/owner/data/repositories/owner_repository_impl.dart

### Presentation Layer
- [ ] **owner-6** : Créer feature/owner/presentation/providers/owner_providers.dart
- [ ] **owner-7** : Migrer Shopowner_login.dart vers owner_login_screen.dart
- [ ] **owner-8** : Migrer customerpage.dart vers owner_dashboard_screen.dart

---

## 🧭 Phase 7 : Navigation (4 tâches)

- [ ] **navigation-1** : Créer routes/app_router.dart avec GoRouter
- [ ] **navigation-2** : Créer routes/route_names.dart pour les constantes de routes
- [ ] **navigation-3** : Migrer toutes les navigations vers GoRouter (remplacer Navigator.push)
- [ ] **navigation-4** : Configurer la navigation conditionnelle basée sur l'état d'authentification

---

## 🎨 Phase 8 : Shared Components (3 tâches)

- [ ] **shared-1** : Créer shared/widgets/ avec les widgets réutilisables (custom_button, custom_text_field, etc.)
- [ ] **shared-2** : Créer shared/theme/app_theme.dart pour centraliser le thème
- [ ] **shared-3** : Migrer les composants existants vers shared/widgets/

---

## 🚦 Phase 9 : Screens Initiaux (3 tâches)

- [ ] **splash-1** : Migrer SpalshScreen.dart vers splash_screen.dart avec la nouvelle architecture
- [ ] **splash-2** : Créer un provider pour gérer l'état de connexion au démarrage
- [ ] **intro-1** : Migrer intro.dart vers user_type_selection_screen.dart

---

## 🔧 Phase 10 : Main & Cleanup (5 tâches)

- [ ] **main-1** : Mettre à jour main.dart pour utiliser Riverpod et GoRouter
- [ ] **cleanup-1** : Supprimer les variables globales de constants.dart et les remplacer par des providers
- [ ] **cleanup-2** : Supprimer le code mort et les imports non utilisés
- [ ] **cleanup-3** : Corriger toutes les erreurs de linter identifiées
- [ ] **cleanup-4** : Renommer SpalshScreen.dart en SplashScreen.dart (correction orthographe)

---

## ✅ Phase 11 : Tests (4 tâches)

- [ ] **test-1** : Créer des tests unitaires pour les usecases
- [ ] **test-2** : Créer des tests unitaires pour les repositories
- [ ] **test-3** : Créer des tests d'intégration pour les features principales
- [ ] **test-4** : Créer des tests widget pour les écrans principaux

---

## 📚 Phase 12 : Documentation (2 tâches)

- [ ] **doc-1** : Mettre à jour le README.md avec la nouvelle architecture
- [ ] **doc-2** : Créer une documentation pour les développeurs sur l'architecture

---

## 📊 Ordre de Priorité Recommandé

### Priorité 1 (Fondations)
1. Setup (setup-1 à setup-7)
2. Feature Auth complète (auth-1 à auth-12)
3. Main & Navigation (main-1, navigation-1 à navigation-4)

### Priorité 2 (Features Principales)
4. Feature Salon (salon-1 à salon-10)
5. Feature Booking (booking-1 à booking-10)
6. Feature Profile (profile-1 à profile-7)

### Priorité 3 (Compléments)
7. Feature Owner (owner-1 à owner-8)
8. Shared Components (shared-1 à shared-3)
9. Screens Initiaux (splash-1, splash-2, intro-1)

### Priorité 4 (Finalisation)
10. Cleanup (cleanup-1 à cleanup-4)
11. Tests (test-1 à test-4)
12. Documentation (doc-1, doc-2)

---

## ⚠️ Points d'Attention

1. **Upload d'Image** (profile-7) : Priorité haute - corriger l'implémentation multipart
2. **Variables Globales** (cleanup-1) : Toutes doivent être remplacées par des providers
3. **Navigation** : Tous les `Navigator.push()` doivent être remplacés par GoRouter
4. **Tests** : Commencer les tests dès qu'une feature est complète

---

## 📝 Notes

- Chaque feature suit le pattern Clean Architecture : Domain → Data → Presentation
- Tous les providers utilisent Riverpod avec code generation
- Toutes les routes utilisent GoRouter
- Tous les appels API passent par ApiClient (Dio)
- Tous les états locaux utilisent SharedPreferences via LocalStorage wrapper

