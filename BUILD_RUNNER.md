# 🔧 Build Runner - Génération de Code

## 📋 Génération des fichiers .g.dart

Les fichiers `*.g.dart` sont générés automatiquement par `build_runner`. Ils ne doivent **JAMAIS** être modifiés manuellement.

### Commandes

#### Générer tous les fichiers
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Mode watch (régénère automatiquement)
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

#### Nettoyer et régénérer
```bash
flutter pub clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📁 Fichiers générés

Les fichiers suivants seront générés automatiquement :

- `lib/core/providers/core_providers.g.dart`
- `lib/features/auth/data/models/user_model.g.dart`
- `lib/features/auth/data/providers/auth_data_providers.g.dart`
- `lib/features/auth/presentation/providers/auth_providers.g.dart`
- Et tous les autres fichiers `*.g.dart` des features

## ⚠️ Important

1. **Ne pas commiter les fichiers .g.dart** - Ils sont dans `.gitignore`
2. **Toujours utiliser `--delete-conflicting-outputs`** - Évite les conflits
3. **Régénérer après chaque modification** des fichiers avec annotations
4. **Vérifier les erreurs** après la génération

## 🔄 Workflow Recommandé

1. Modifier les fichiers avec annotations (`@riverpod`, `@JsonSerializable`, etc.)
2. Exécuter `build_runner build`
3. Vérifier qu'il n'y a pas d'erreurs
4. Tester l'application

## 📚 Documentation

- [Riverpod Code Generation](https://riverpod.dev/docs/concepts/about_code_generation)
- [JSON Serializable](https://pub.dev/packages/json_serializable)
- [Build Runner](https://pub.dev/packages/build_runner)

