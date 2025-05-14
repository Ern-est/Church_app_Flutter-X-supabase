import 'dart:io';
import 'package:bethsaida_app/screens/auth_screen.dart';
import 'package:bethsaida_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String userId;
  final String phoneNumber;

  const CompleteProfileScreen({
    required this.userId,
    required this.phoneNumber,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  File? _profileImage;
  bool _isSubmitting = false;

  final _picker = ImagePicker();
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _protectScreen();
  }

  Future<void> _protectScreen() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      // Not logged in, redirect to the phone number screen (AuthScreen)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => AuthScreen(),
        ), // Ensure you have AuthScreen for phone number entry
        (_) => false,
      );
      return;
    }

    try {
      final response =
          await supabase.from('users').select().eq('id', user.id).single();

      // If profile is already completed, redirect to HomeScreen
      if (response['username'] != null && response['profile_image'] != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ), // Ensure you have HomeScreen
          (_) => false,
        );
      }
    } catch (e) {
      // If no user profile is found, continue the profile completion process
      print("No existing profile found, continuing...");
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_profileImage == null) return null;

    final bytes = await _profileImage!.readAsBytes();
    final fileName = 'profile_${widget.userId}.jpg';
    final path = 'public/$fileName';

    try {
      await supabase.storage
          .from('profilephotos')
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final url = supabase.storage.from('profilephotos').getPublicUrl(path);
      return url;
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _profileImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("All fields are required.")));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final imageUrl = await _uploadImage();

      if (imageUrl != null) {
        await supabase.from('users').upsert({
          'id': widget.userId,
          'username': _usernameController.text.trim(),
          'phone': widget.phoneNumber,
          'profile_image': imageUrl,
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Profile completed!")));

        // Redirect to HomeScreen after profile completion
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ), // Ensure you have HomeScreen
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Image upload failed")));
      }
    } catch (e) {
      print("Profile error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong")));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child:
                      _profileImage == null
                          ? Icon(Icons.add_a_photo, size: 30)
                          : null,
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (val) =>
                        val == null || val.trim().isEmpty
                            ? 'Enter username'
                            : null,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child:
                    _isSubmitting
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Finish"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
