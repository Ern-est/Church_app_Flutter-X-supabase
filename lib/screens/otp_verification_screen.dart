import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'complete_profile_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({required this.phoneNumber});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isVerifying = false;

  final supabase = Supabase.instance.client;

  Future<void> _verifyOtp() async {
    setState(() => _isVerifying = true);
    try {
      final response = await supabase.auth.verifyOTP(
        type: OtpType.sms,
        phone: widget.phoneNumber,
        token: _otpController.text.trim(),
      );

      if (response.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => CompleteProfileScreen(
                  userId: response.user!.id,
                  phoneNumber: widget.phoneNumber,
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Invalid OTP")));
      }
    } catch (e) {
      print("OTP Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("OTP verification failed")));
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("Enter OTP sent to ${widget.phoneNumber}"),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "OTP Code"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isVerifying ? null : _verifyOtp,
              child:
                  _isVerifying
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
