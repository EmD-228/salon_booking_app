import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/profile_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../routes/route_names.dart';

/// Écran de profil utilisateur avec Riverpod
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    // Charger le profil au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    final authState = ref.read(authNotifierProvider);
    final user = authState.value;
    if (user != null) {
      await ref.read(profileNotifierProvider.notifier).loadProfile(user.email);
    }
  }

  Future<void> _showImageSourceBottomSheet() async {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 150.0, right: 150.0),
                child: Divider(
                  color: AppColors.primary,
                  thickness: 5.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    elevation: 30.0,
                    onPressed: () async {
                      Navigator.pop(context);
                      await _pickImage(ImageSource.camera);
                    },
                    child: const Icon(
                      Icons.camera_alt,
                      color: AppColors.primary,
                      size: 40.0,
                    ),
                  ),
                  MaterialButton(
                    elevation: 30.0,
                    onPressed: () async {
                      Navigator.pop(context);
                      await _pickImage(ImageSource.gallery);
                    },
                    child: const Icon(
                      Icons.image_sharp,
                      color: AppColors.primary,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final photo = await _imagePicker.pickImage(source: source);
      if (photo != null) {
        setState(() {
          _selectedImage = File(photo.path);
        });
        await _uploadImage(_selectedImage!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    final authState = ref.read(authNotifierProvider);
    final user = authState.value;
    if (user == null) return;

    final imageUrl = await ref.read(profileNotifierProvider.notifier).uploadImage(
          email: user.email,
          imageFile: imageFile,
        );

    if (imageUrl != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image uploaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to upload image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleLogout() async {
    await ref.read(authNotifierProvider.notifier).logout();
    if (mounted) {
      context.go(RouteNames.login);
    }
  }

  Future<void> _handleCheckBookings() async {
    context.push(RouteNames.bookingsList);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: const Color(0xFF255BC1),
          title: Text(
            'PROFILE',
            style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/p.gif"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: profileAsync.when(
              data: (user) {
                final displayUser = user ?? authState.value;
                if (displayUser == null) {
                  return Center(
                    child: Text(
                      'No user data available',
                      style: GoogleFonts.ubuntu(fontSize: 18),
                    ),
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar avec bouton de modification
                    Material(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 70.0,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!) as ImageProvider
                                : (displayUser.profilePicture != null &&
                                        displayUser.profilePicture!.isNotEmpty
                                    ? NetworkImage(displayUser.profilePicture!)
                                    : null),
                            child: _selectedImage == null &&
                                    (displayUser.profilePicture == null ||
                                        displayUser.profilePicture!.isEmpty)
                                ? const Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: -15,
                            child: TextButton(
                              onPressed: _showImageSourceBottomSheet,
                              child: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 5.0,
                                shadowColor: Colors.black,
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Color(0xFF255BC1),
                                  size: 35.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    // Nom
                    Text(
                      'Name',
                      style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 40.0,
                      ),
                    ),
                    Text(
                      displayUser.name,
                      style: GoogleFonts.ubuntu(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    // Email
                    Text(
                      'Email Id',
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 40.0,
                      ),
                    ),
                    Text(
                      displayUser.email,
                      style: GoogleFonts.ubuntu(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    // Bouton Check Bookings
                    MaterialButton(
                      height: 65.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5.0,
                      onPressed: _handleCheckBookings,
                      color: const Color(0xFF4E97EB),
                      child: Text(
                        'Check Bookings',
                        style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 40.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Bouton Logout
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                      child: MaterialButton(
                        height: 65.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5.0,
                        onPressed: _handleLogout,
                        color: const Color(0xFF4E97EB),
                        child: Center(
                          child: Text(
                            'Log Out',
                            style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 40.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error loading profile',
                      style: GoogleFonts.ubuntu(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _loadProfile,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

