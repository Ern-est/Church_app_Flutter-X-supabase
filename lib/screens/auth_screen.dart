import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'otp_verification_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _phoneNumber;
  bool _isLoading = false;

  final supabase = Supabase.instance.client;

  Future<void> _sendOtp() async {
    if (_formKey.currentState!.validate() && _phoneNumber != null) {
      setState(() => _isLoading = true);

      try {
        await supabase.auth.signInWithOtp(phone: _phoneNumber!);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("OTP sent to $_phoneNumber")));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPVerificationScreen(phoneNumber: _phoneNumber!),
          ),
        );
      } catch (e) {
        print('Error sending OTP: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send OTP. Try again.")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter Your Phone Number",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),

                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  initialCountryCode: 'KE',
                  onChanged: (phone) => _phoneNumber = phone.completeNumber,
                  validator:
                      (value) =>
                          value == null || value.completeNumber.isEmpty
                              ? 'Enter valid phone number'
                              : null,
                ),

                SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _isLoading ? null : _sendOtp,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Continue"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
