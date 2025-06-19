import 'package:flutter/material.dart';
import 'package:mtxo_lab/config/app_colors.dart';
import 'package:mtxo_lab/config/app_typography.dart';
import 'package:mtxo_lab/config/theme/theme_provider.dart';
import 'package:mtxo_lab/core/utils/sizeconfig.dart';
import 'package:mtxo_lab/shared/widgets/custom_button.dart';
import 'package:mtxo_lab/shared/widgets/custom_textfield.dart';
import 'package:mtxo_lab/shared/widgets/gradient_background.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Button IDs for loader management
  static const String SIGNIN_BUTTON_ID = "signin_btn";
  static const String QUICK_LOGIN_BUTTON_ID = "quick_login_btn";
  static const String SKIP_LOGIN_BUTTON_ID = "skip_login_btn";
  static const String FORGOT_PASSWORD_BUTTON_ID = "forgot_password_btn";

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    SizeConfig().init(context);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: SizeConfig.getPaddingSymmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.height(1)),

                    // Logo and title section
                    Container(
                      width: SizeConfig.width(20),
                      height: SizeConfig.height(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF00BFFF).withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.school,
                        size: SizeConfig.height(5),
                        color: Color(0xFF00BFFF),
                      ),
                    ),

                    SizedBox(height: SizeConfig.height(2)),

                    Text(
                      'MIXO Labs',
                      style: AppTypography.h1(context).copyWith(
                        fontSize: 28,
                        color: themeProvider.isDarkMode
                            ? AppColors.white
                            : AppColors.textPrimary,
                      ),
                    ),

                    Text(
                      'Next-Gen Learning Platform',
                      style: AppTypography.h5(context).copyWith(
                        color: themeProvider.isDarkMode
                            ? AppColors.white
                            : AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: SizeConfig.height(3)),

                    // Sign In Form
                    Container(
                      padding: SizeConfig.getPaddingSymmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? AppColors.conPrimary
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.2),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign In',
                            style: AppTypography.h3(context).copyWith(
                              fontWeight: FontWeight.w600,
                              color: themeProvider.isDarkMode
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                            ),
                          ),

                          // Show error message if exists

                          SizedBox(height: SizeConfig.height(1)),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "error",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: SizeConfig.height(2)),

                          // Username Field
                          Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: themeProvider.isDarkMode
                                  ? AppColors.textLogin
                                  : AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: SizeConfig.height(0.2)),
                          CustomTextField(
                            controller: _usernameController,
                            prefixIcon: Icon(Icons.person),
                            hintText: "Enter your username",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: SizeConfig.height(1)),

                          // Password Field
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: themeProvider.isDarkMode
                                  ? AppColors.textLogin
                                  : AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: SizeConfig.height(0.2)),
                          PasswordTextField(
                            controller: _passwordController,
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Enter your password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: SizeConfig.height(1)),

                          // Forgot Password Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF00BFFF),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.width(8)),
                                  Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Color(0xFF00BFFF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: SizeConfig.height(2.5)),

                          // Sign In Button - Using CustomButton
                          CustomButton(
                            buttonId: SIGNIN_BUTTON_ID,
                            text: "Sign In",
                            backgroundColor: AppColors.buttonColor,
                            textColor: Colors.white,
                            width: SizeConfig.width(35),
                            height: SizeConfig.height(6),
                            borderRadius: 15,
                            onPressed: () {},
                            fullWidth: true,
                          ),

                          SizedBox(height: 24),

                          Center(
                            child: Text(
                              'Test Account',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 14,
                              ),
                            ),
                          ),

                          SizedBox(height: SizeConfig.height(1.5)),

                          // Quick Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  buttonId: QUICK_LOGIN_BUTTON_ID,
                                  text: "Quick Login",
                                  // loadingText: "Logging.",
                                  height: SizeConfig.height(5),
                                  borderRadius: 10,
                                  backgroundColor: themeProvider.isDarkMode
                                      ? AppColors.buttonbg
                                      : AppColors.buttonsecondry,
                                  textColor: AppColors.buttonColor,
                                  elevation: 0,
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(width: SizeConfig.width(1)),
                              Expanded(
                                child: CustomButton(
                                  buttonId: SKIP_LOGIN_BUTTON_ID,
                                  text: "Skip Login",
                                  // loadingText: "Skipping.",
                                  height: SizeConfig.height(5),
                                  borderRadius: 10,
                                  backgroundColor: themeProvider.isDarkMode
                                      ? AppColors.buttonnew
                                      : AppColors.yellooff,
                                  textColor: AppColors.yello,
                                  elevation: 0,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: SizeConfig.height(2)),
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
