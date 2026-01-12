# Guide de Migration des Variables Globales

Ce guide explique comment migrer les variables globales de `constants.dart` vers les providers Riverpod.

## 📋 Variables Migrées

### 1. URLs API → `ApiEndpoints`

**Ancien code :**
```dart
import 'package:salon_app/constants.dart';
var response = await http.post(Uri.parse(url_login), body: {...});
```

**Nouveau code :**
```dart
import '../../core/constants/api_endpoints.dart';
var response = await apiClient.post(ApiEndpoints.login, data: {...});
```

**Mapping des URLs :**
- `url_register` → `ApiEndpoints.register`
- `url_login` → `ApiEndpoints.login`
- `url_logout` → `ApiEndpoints.logout`
- `url_userdetail` → `ApiEndpoints.userDetail`
- `url_UploadImage` → `ApiEndpoints.uploadImage`
- `url_getdata` → `ApiEndpoints.nearbySalons`
- `url_search` → `ApiEndpoints.searchLocation`
- `url_timeslot` → `ApiEndpoints.timeSlots`
- `url_forgetpassword` → `ApiEndpoints.forgetPassword`
- `url_checkbooking` → `ApiEndpoints.checkBooking`
- `url_change_password` → `ApiEndpoints.changePassword`
- `url_booking` → `ApiEndpoints.booking`
- `url_ownerdetail` → `ApiEndpoints.ownerDetail`
- `url_todaysbooking` → `ApiEndpoints.todayBookings`
- `uploaded_images` → `ApiEndpoints.imagesBaseUrl`

### 2. Couleurs → `AppColors`

**Ancien code :**
```dart
import 'package:salon_app/constants.dart';
color: kPrimaryColor
```

**Nouveau code :**
```dart
import '../../core/constants/app_colors.dart';
color: AppColors.primary
```

**Mapping des couleurs :**
- `kPrimaryColor` → `AppColors.primary`
- `kBackgroundColor` → `AppColors.background`
- `kCardColor` → `AppColors.cardColor`

### 3. Variables d'État → Providers

**Ancien code :**
```dart
import 'package:salon_app/constants.dart';
salon_id = 123;
card_position = 0;
choice = 'Haircut';
```

**Nouveau code :**
```dart
import '../../core/providers/app_state_providers.dart';
ref.read(selectedSalonIdProvider.notifier).state = 123;
ref.read(cardPositionProvider.notifier).state = 0;
ref.read(selectedServiceTypeProvider.notifier).state = 'Haircut';
```

**Mapping des variables d'état :**
- `salon_id` → `selectedSalonIdProvider`
- `card_position` → `cardPositionProvider`
- `choice` → `selectedServiceTypeProvider`
- `customer_name` → `customerNameProvider`
- `loading_ts` → `loadingTimeSlotsProvider`
- `tdata` → `currentTimeProvider` (calculé dynamiquement)

### 4. Listes Globales → Providers/Notifiers

Les listes globales (`Salon_image`, `TimeSlot`, `OwnerDetail`, `TodayBooking`, `checkbooking`) doivent être remplacées par les providers correspondants :

**Salon_image :**
- Utiliser `salonsNotifierProvider` dans `features/salon/presentation/providers/salon_providers.dart`

**TimeSlot :**
- Utiliser `timeSlotsNotifierProvider` dans `features/booking/presentation/providers/booking_providers.dart`

**OwnerDetail :**
- Utiliser `ownerNotifierProvider` dans `features/owner/presentation/providers/owner_providers.dart`

**TodayBooking :**
- Utiliser `todayBookingsNotifierProvider` dans `features/owner/presentation/providers/owner_providers.dart`

**checkbooking :**
- Utiliser `bookingsNotifierProvider` dans `features/booking/presentation/providers/booking_providers.dart`

## 🔄 Exemples de Migration

### Exemple 1 : Utilisation de salon_id

**Ancien code :**
```dart
import 'package:salon_app/constants.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    salon_id = 5;
    // ...
  }
}
```

**Nouveau code :**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_state_providers.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(selectedSalonIdProvider.notifier).state = 5;
    final salonId = ref.watch(selectedSalonIdProvider);
    // ...
  }
}
```

### Exemple 2 : Utilisation de tdata (heure actuelle)

**Ancien code :**
```dart
import 'package:salon_app/constants.dart';
String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
if (hr < int.parse(tdata[0]) * 10 + int.parse(tdata[1])) {
  // ...
}
```

**Nouveau code :**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_state_providers.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTime = ref.watch(currentTimeProvider);
    final hr = int.parse(currentTime.substring(0, 2));
    if (hr < someValue) {
      // ...
    }
  }
}
```

### Exemple 3 : Utilisation des listes de salons

**Ancien code :**
```dart
import 'package:salon_app/constants.dart';
ListView.builder(
  itemCount: Salon_image.length,
  itemBuilder: (context, index) {
    return Text(Salon_image[index]['Name']);
  },
)
```

**Nouveau code :**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/salon/presentation/providers/salon_providers.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salonsAsync = ref.watch(salonsNotifierProvider);
    
    return salonsAsync.when(
      data: (salons) => ListView.builder(
        itemCount: salons.length,
        itemBuilder: (context, index) {
          return Text(salons[index].name);
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## ⚠️ Notes Importantes

1. **Compatibilité** : Le fichier `constants.dart` est conservé temporairement pour la compatibilité avec les anciens fichiers non migrés.

2. **Migration Progressive** : Les fichiers doivent être migrés progressivement vers la nouvelle architecture.

3. **Tests** : Après migration, tester que les fonctionnalités fonctionnent correctement.

4. **Suppression** : Une fois tous les fichiers migrés, `constants.dart` pourra être supprimé.

## 📝 Checklist de Migration

Pour migrer un fichier :

- [ ] Remplacer les imports `constants.dart` par les imports appropriés
- [ ] Remplacer les URLs par `ApiEndpoints`
- [ ] Remplacer les couleurs par `AppColors`
- [ ] Remplacer les variables d'état par les providers
- [ ] Remplacer les listes globales par les providers/notifiers
- [ ] Convertir `StatefulWidget` en `ConsumerStatefulWidget` si nécessaire
- [ ] Convertir `StatelessWidget` en `ConsumerWidget` si nécessaire
- [ ] Tester que tout fonctionne correctement
- [ ] Supprimer les références à `constants.dart`

