# 🔒 Sécurité - Fichiers Sensibles

## ⚠️ IMPORTANT : Fichiers à ne JAMAIS commiter

### Fichiers critiques ignorés par Git :

1. **`.env`** - Variables d'environnement avec les URLs API réelles
2. **`*.g.dart`** - Fichiers générés automatiquement par build_runner
3. **`*.freezed.dart`** - Fichiers générés par freezed
4. **Secrets & Credentials** - Tous les fichiers contenant des secrets
5. **Fichiers de build** - Tous les fichiers générés lors de la compilation

## 📝 Configuration de l'environnement

### Pour démarrer le projet :

1. **Copier le fichier template** :
   ```bash
   cp .env.example .env
   ```

2. **Éditer le fichier `.env`** avec vos valeurs réelles :
   ```env
   API_BASE_URL=https://salonappmysql.000webhostapp.com
   ENV=development
   ```

3. **Vérifier que `.env` est bien ignoré** :
   ```bash
   git status
   # Le fichier .env ne doit PAS apparaître
   ```

## ✅ Fichiers à commiter

- ✅ `.env.example` - Template pour les autres développeurs
- ✅ Code source (`.dart`)
- ✅ Configuration publique (`pubspec.yaml`, `analysis_options.yaml`)
- ✅ Documentation (`README.md`, `TODO_ARCHITECTURE.md`)

## ❌ Fichiers à NE PAS commiter

- ❌ `.env` - Contient les vraies valeurs
- ❌ `*.g.dart` - Générés automatiquement
- ❌ `build/` - Fichiers de compilation
- ❌ `.dart_tool/` - Cache Dart
- ❌ Secrets, clés API, tokens

## 🔧 Génération des fichiers

Les fichiers `*.g.dart` sont générés automatiquement :

```bash
# Générer tous les fichiers
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (régénère automatiquement lors des changements)
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 📚 Voir aussi

- `.gitignore` - Liste complète des fichiers ignorés
- `.env.example` - Template pour les variables d'environnement

