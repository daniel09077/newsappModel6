import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:news_app/services/auth_service_base.dart';
import 'package:news_app/screens/login_page.dart';
import 'package:news_app/models/user_profile.dart';
import 'package:news_app/models/user_role.dart';
import 'package:news_app/services/auth_service.dart';

class RegistrationPage extends StatefulWidget {
  final AuthServiceBase authService;

  const RegistrationPage({super.key, required this.authService});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _otherNamesController = TextEditingController();

  File? _profileImage;
  bool _isLoading = false;
  String? _errorMessage;

  final ImagePicker _picker = ImagePicker();

  final List<String> _departments = [
    'Computer Science',
    'Electrical Engineering',
    'Civil Engineering',
    'Business Administration',
    'Accountancy',
    'Mass Communication',
    'Architecture',
    'Urban and Regional Planning',
  ];

  final List<String> _genders = ['Male', 'Female']; // Added genders for the dropdown

  final Map<String, String> _collegePrefixes = {
    'CST': 'College of Science and Technology',
    'COE': 'College of Engineering',
    'CES': 'College of Environmental Studies',
    'CBS': 'College of Business and Management Studies',
    'CAS': 'College of Administrative Studies',
  };

  final Map<String, String> _programmePrefixes = {
    'ND': 'National Diploma (ND)',
    'HND': 'Higher National Diploma (HND)',
    'CC': 'Certificate Course',
  };

  String? _selectedDepartment;
  String? _selectedProgramme;
  String? _selectedCollege;
  String? _selectedGender; // Added state variable for selected gender

  @override
  void initState() {
    super.initState();
    _regNoController.addListener(_onRegNoChanged);
  }

  void _onRegNoChanged() {
    final regNo = _regNoController.text.trim().toUpperCase();
    final RegExp regExp = RegExp(r'^[A-Z]{3}\d{2}(HND|ND|CC)\d{4}$');
    final match = regExp.firstMatch(regNo);

    if (match != null) {
      final collegePrefix = regNo.substring(0, 3);
      final programmePrefix = match.group(1);

      setState(() {
        _selectedCollege = _collegePrefixes[collegePrefix];
        _selectedProgramme = _programmePrefixes[programmePrefix];
      });
    } else {
      setState(() {
        _selectedCollege = null;
        _selectedProgramme = null;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final userProfile = await widget.authService.registerUser(
          regNo: _regNoController.text.trim().toUpperCase(),
          email: _emailController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          otherNames: _otherNamesController.text.trim(),
          department: _selectedDepartment!,
          programme: _selectedProgramme!,
          college: _selectedCollege!,
          role: UserRole.student,
          gender: _selectedGender!,
          profilePictureFile: _profileImage,
        );

        if (!mounted) return;

        if (userProfile != null) {
          await _showMessageBox(
            context,
            'Registration Successful!',
            'Your account has been created. You can now log in.',
          );

          if (!mounted) return;

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginPage(onLoginSuccess: (profile) {}, authService: AuthService()),
            ),
          );
        } else {
          setState(() {
            _errorMessage = 'Registration failed. User might already exist or an error occurred.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An unexpected error occurred: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _regNoController.removeListener(_onRegNoChanged);
    _regNoController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _otherNamesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.grey[600],
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _profileImage == null ? 'Tap to add profile picture' : 'Profile picture selected',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _regNoController,
                  decoration: InputDecoration(
                    labelText: 'Registration Number',
                    hintText: 'e.g., CST23HND0050',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Registration Number cannot be empty.';
                    }
                    final String upperCaseValue = value.toUpperCase();
                    final RegExp studentRegExp = RegExp(r'^[A-Z]{3}\d{2}(HND|ND|CC)\d{4}$');
                    if (!studentRegExp.hasMatch(upperCaseValue)) {
                      return 'Invalid format. e.g., CST23HND0050 or CST23ND0050';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name cannot be empty.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name cannot be empty.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _otherNamesController,
                  decoration: InputDecoration(
                    labelText: 'Other Names (Optional)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.person_add),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'e.g., your.email@example.com',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty.';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.people),
                  ),
                  items: _genders.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a gender.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  decoration: InputDecoration(
                    labelText: 'Department',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.apartment),
                  ),
                  items: _departments.map((String department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDepartment = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your department.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedProgramme,
                  decoration: InputDecoration(
                    labelText: 'Programme',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.book),
                  ),
                  items: _programmePrefixes.values.map((String programme) {
                    return DropdownMenuItem<String>(
                      value: programme,
                      child: Text(programme),
                    );
                  }).toList(),
                  onChanged: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Registration Number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedCollege,
                  decoration: InputDecoration(
                    labelText: 'College',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.school),
                  ),
                  items: _collegePrefixes.values.map((String college) {
                    return DropdownMenuItem<String>(
                      value: college,
                      child: Text(college),
                    );
                  }).toList(),
                  onChanged: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Registration Number.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 3,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Register',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMessageBox(BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Text(message, style: const TextStyle(fontSize: 15)),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
