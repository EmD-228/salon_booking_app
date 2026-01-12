import 'package:flutter/material.dart';

// ⚠️ FICHIER DÉPRÉCIÉ - Les variables globales ont été migrées vers des providers
// Ce fichier est conservé temporairement pour la compatibilité avec les anciens fichiers
// qui n'ont pas encore été migrés vers la nouvelle architecture.

// Les URLs ont été migrées vers lib/core/constants/api_endpoints.dart
// Les couleurs ont été migrées vers lib/core/constants/app_colors.dart
// Les variables d'état ont été migrées vers lib/core/providers/app_state_providers.dart

// ⚠️ NE PAS UTILISER CES VARIABLES DANS LES NOUVEAUX FICHIERS
// Utiliser plutôt :
// - ApiEndpoints pour les URLs
// - AppColors pour les couleurs
// - Les providers dans app_state_providers.dart pour l'état

// Couleurs (dépréciées - utiliser AppColors)
const kPrimaryColor = Color(0XFF005B96);
const kBackgroundColor = Color(0XFFE5E5E5);
const kCardColor = Color.fromARGB(255, 243, 242, 242);

// Variables d'état globales (dépréciées - utiliser les providers)
// Ces variables sont encore utilisées dans les anciens fichiers non migrés
late int card_position;
late int salon_id;
String? choice;
List TodayBooking = [];
String tdata = ''; // Sera initialisé dynamiquement
List Salon_image = [];
List TimeSlot = [];
List OwnerDetail = [];
String? customer_name;
bool loading_ts = true;
List checkbooking = [];

// URLs (dépréciées - utiliser ApiEndpoints)
// Ces URLs sont encore utilisées dans les anciens fichiers non migrés
var url_register = 'https://salonappmysql.000webhostapp.com/register.php';
var url_login = 'https://salonappmysql.000webhostapp.com/login.php';
var url_logout = 'https://salonappmysql.000webhostapp.com/logout.php';
var url_userdetail = 'https://salonappmysql.000webhostapp.com/user_data.php';
var url_UploadImage = 'https://salonappmysql.000webhostapp.com/uploadimage.php';
var url_getdata = 'https://salonappmysql.000webhostapp.com/nearby.php';
var url_search = 'https://salonappmysql.000webhostapp.com/searched_location.php';
var url_timeslot = 'https://salonappmysql.000webhostapp.com/Timeslot.php';
var url_forgetpassword = 'https://salonappmysql.000webhostapp.com/forgetpassword.php';
var url_checkbooking = 'https://salonappmysql.000webhostapp.com/checkbooking.php';
var url_change_password = 'https://salonappmysql.000webhostapp.com/changepassword.php';
var url_booking = 'https://salonappmysql.000webhostapp.com/booking.php';
var url_ownerdetail = 'https://salonappmysql.000webhostapp.com/ownerdetail.php';
var url_todaysbooking = 'https://salonappmysql.000webhostapp.com/owner_booking_data.php';
var uploaded_images = 'https://salonappmysql.000webhostapp.com/salon_image/';
