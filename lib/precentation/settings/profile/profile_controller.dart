import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:http/http.dart' as http;
import '../../../Model/UserModel.dart' as user_model;
import '../../../Model/UserModel.dart';
import '../../../models/user_data_model.dart' as usermodel;
import '../../../server/app_storage.dart';
import 'package:path/path.dart' as path;

class ProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  var genderValue = ''.obs;
  var profileImage = Rx<File?>(null);
  var cachedProfilePictureUrl = ''.obs;
  Rx<user_model.UserData?> userData = Rx<user_model.UserData?>(null);
  Rx<usermodel.UserData?> userDetails = Rx<usermodel.UserData?>(null);

  int? userProfileId;
  RxInt userId = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isProfileCreated = false.obs;

  var cachedFirstName = ''.obs;
  var cachedLastName = ''.obs;
  var cachedPhoneNumber = ''.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    refreshProfilePicture();
    loadCachedProfilePicture();
    loadCachedUserData();
    loadUserDataFromLocal();

    if (userData.value != null) {
      updateProfileFields(userData.value!);
    } else {
      Future.delayed(Duration.zero, () {
        if (userId.value != 0) {
          fetchUserDetails();
        }
      });
    }

    loadUserDataFromLocal().then((_) {
      if (userId.value != 0) {
        fetchUserDetails();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    update();
  }

  void clearFields() {
    nameController.clear();
    lastnameController.clear();
    dobController.clear();
    genderValue.value = '';
    profileImage.value = null;
  }

  void clearUserData() {
    print("Clearing profile data...");

    userId.value = 0;
    userData.value = null;
    userDetails.value = null;
    nameController.clear();
    lastnameController.clear();
    dobController.clear();
    phoneController.clear();
    emailController.clear();
    genderValue.value = '';
    profileImage.value = null;
    cachedProfilePictureUrl.value = '';

    update();
  }

  void setUserId(int id) async {
    print("🔒 Setting new userId: $id");

    if (userId.value != id) {
      clearUserData();
    }

    userId.value = id;

    // Update the cache immediately after setting the userId
    await AmdStorage().createCache('userId', id.toString());

    // Verify that the cache is updated
    var userIdCache = await AmdStorage().readCache('userId');
    print("✅ userId stored in cache: $userIdCache");

    await loadUserDataFromLocal();

    if (userId.value != 0) {
      fetchUserDetails();
    }
  }


  void refreshProfilePicture() async {
    final storage = GetStorage();

    // First check if the image is stored locally
    String? storedProfilePath = await AmdStorage().readCache(
      'profilePicturePath',
    );

    if (storedProfilePath != null && File(storedProfilePath).existsSync()) {
      cachedProfilePictureUrl.value = storedProfilePath;
      profileImage.value = File(storedProfilePath);
      return;
    }

    // If not found, check the server URL (if any)
    String? profilePictureUrl = storage.read('profilePictureUrl');
    if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
      cachedProfilePictureUrl.value = profilePictureUrl;
    }
  }

  Future<void> loadCachedUserData() async {
    final storage = GetStorage();
    cachedProfilePictureUrl.value =
        await AmdStorage().readCache('profilePictureUrl') ??
        storage.read('profilePictureUrl') ??
        '';
    cachedFirstName.value = await AmdStorage().readCache('firstName') ?? 'User';
    cachedLastName.value = await AmdStorage().readCache('lastName') ?? '';
    cachedPhoneNumber.value = storage.read('phoneNumber') ?? '9876543210';
  }

  Future<void> loadCachedProfilePicture() async {
    String? storedProfilePictureUrl = await AmdStorage().readCache(
      'profilePictureUrl',
    );
    if (storedProfilePictureUrl != null && storedProfilePictureUrl.isNotEmpty) {
      cachedProfilePictureUrl.value = storedProfilePictureUrl;
    } else {
      cachedProfilePictureUrl.value =
          GetStorage().read('profilePictureUrl') ?? '';
    }
  }

  Future<void> loadCachedPhoneNumber() async {
    String? storedPhoneNumber =
        GetStorage().read('phoneNumber') ?? '9876543210';
    if (storedPhoneNumber.isNotEmpty) {
      cachedPhoneNumber.value = storedPhoneNumber;
    }
  }

  // Load data from local storage
  Future<void> loadUserDataFromLocal() async {
    try {
      userId.value =
          int.tryParse(await AmdStorage().readCache('userId') ?? '0') ?? 0;
      nameController.text = await AmdStorage().readCache('firstName') ?? '';
      lastnameController.text = await AmdStorage().readCache('lastName') ?? '';
      phoneController.text = GetStorage().read('phoneNumber') ?? '';
      dobController.text = await AmdStorage().readCache('dateOfBirth') ?? '';
      genderValue.value = await AmdStorage().readCache('gender') ?? '';

      // Retrieve stored profile image path
      String? profileImgPath = await AmdStorage().readCache(
        'profilePicturePath',
      );

      if (profileImgPath != null && profileImgPath.isNotEmpty) {
        profileImage.value = File(profileImgPath);
        cachedProfilePictureUrl.value = profileImgPath;
      }

      isProfileCreated.value = userId.value != 0;
      debugPrint('User profile loaded from local storage');
    } catch (e) {
      debugPrint('Error loading user profile from local storage: $e');
    }
  }

  DateTime? formatDateOfBirth(String? dob) {
    if (dob == null || dob.isEmpty) return null;
    try {
      return DateFormat('dd/MM/yyyy').parse(dob);
    } catch (e) {
      debugPrint('Error parsing dateOfBirth: $e');
      return null;
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      if (userId.value == 0) {
        print("Skipping fetchUserDetails() because userId is 0");
        return;
      }

      isLoading.value = true;
      print("Fetching user details for userId: ${userId.value}");

      final response = await GraphQLClientService.fetchData(
        query: GraphQuery.userDetails(userId.value),
      );

      print("API Response: ${response.data}");

      if (response.data == null) {
        print("Error: API response is null");
        return;
      }

      final userDetails = response.data?['userDetailsWithAddress'];
      print("Extracted userDetails: $userDetails");

      if (userDetails == null) {
        print("Error: userDetailsWithAddress is null");
        return;
      }

      // â Extract `userId`
      int? fetchedUserId = userDetails['userId'];
      if (fetchedUserId == null || fetchedUserId == 0) {
        print(
          "Error: Fetched userId is invalid (Received: $fetchedUserId)",
        );
        return;
      }
      print("Successfully fetched userId: $fetchedUserId");

      // Ensure userId is updated
      userId.value = fetchedUserId;

      // Update `userData`
      userData.value = user_model.UserData.fromJson(response.data!);
      userData.refresh(); // Refresh GetX state

      print("Updated userData: ${userData.value}");

      // Save locally and update UI
      await saveUserProfileToLocal(userData.value!);
      updateProfileFields(userData.value!);

      isProfileCreated.value = true;
    } catch (e) {
      print("Error in fetchUserDetails: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateProfileFields(user_model.UserData userData) {
    final userDetails = userData.data?.userDetailsWithAddress;
    if (userDetails != null) {
      nameController.text = userDetails.userProfiles?.first.firstName ?? '';
      lastnameController.text = userDetails.userProfiles?.first.lastName ?? '';
      dobController.text = userDetails.userProfiles?.first.dateOfBirth ?? '';
      genderValue.value = userDetails.userProfiles?.first.gender ?? '';
    }

    nameController.text = GetStorage().read('firstName') ?? nameController.text;
    lastnameController.text =
        GetStorage().read('lastName') ?? lastnameController.text;
    dobController.text = GetStorage().read('dob') ?? dobController.text;
    genderValue.value = GetStorage().read('gender') ?? genderValue.value;
  }

  Future<void> saveUserProfileToLocal(user_model.UserData userData) async {
    final userDetails = userData.data?.userDetailsWithAddress;
    if (userDetails == null) {
      print('userDetailsWithAddress is null, cannot save to local storage');
      return;
    }

    final profile =
        userDetails.userProfiles?.isNotEmpty == true
            ? userDetails.userProfiles!.first
            : null;
    try {
      await AmdStorage().createCache('firstName', profile?.firstName ?? '');
      await AmdStorage().createCache('lastName', profile?.lastName ?? '');
      await AmdStorage().createCache('dateOfBirth', profile?.dateOfBirth ?? '');
      await AmdStorage().createCache('gender', profile?.gender ?? '');
      if (profile?.profilePictureUrl != null) {
        await AmdStorage().createCache(
          'profilePicturePath',
          profile!.profilePictureUrl!,
        );
        cachedProfilePictureUrl.value = profile.profilePictureUrl!;
      }
      print('User profile saved to local storage');
    } catch (e) {
      print('Error saving user profile to local storage: $e');
    }
  }

  Future<bool> createUserProfile({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    File? profileImg,
  }) async {
    try {

      // Read the updated userId from cache
      var userIdCache = await AmdStorage().readCache('userId');
      if (userIdCache == null || userIdCache == '0') {
        print('❌ Error: userId is null or missing in cache');
        return false;
      }

      int userId = int.tryParse(userIdCache) ?? 0;
      if (userId == 0) {
        print('❌ Error: Invalid userId');
        return false;
      }


      // Format dateOfBirth
      String? formattedDateOfBirth;
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        try {
          List<String> parts = dateOfBirth.split('-');
          if (parts.length == 3) {
            String formattedInput =
                "${parts[2]}-${parts[1]}-${parts[0]}"; // YYYY-MM-DD
            DateTime parsedDate = DateFormat(
              'yyyy-MM-dd',
            ).parseStrict(formattedInput);
            formattedDateOfBirth = DateFormat('yyyy-MM-dd').format(parsedDate);
          } else {
            throw FormatException('Invalid date format');
          }
        } catch (e) {
          print('Invalid date format: $dateOfBirth');
          return false;
        }
      }

      // Prepare GraphQL mutation
      const String mutation = '''
      mutation CreateUserProfile(\$userId: Int!, \$firstName: String, \$lastName: String, \$dateOfBirth: Date, \$gender: String, \$profileImg: Upload) {
        createUserProfile(
          userId: \$userId
          firstName: \$firstName
          lastName: \$lastName
          dateOfBirth: \$dateOfBirth
          gender: \$gender
          profileImg: \$profileImg
        ) {
          success
          message
          data {
            userId
            userProfileId
            firstName
            lastName
            dateOfBirth
            gender
            profilePictureUrl
          }
        }
      }
    ''';

      // Prepare variables
      Map<String, dynamic> variables = {
        'userId': userId,
        'firstName': firstName ?? "",
        'lastName': lastName ?? "",
        'dateOfBirth': formattedDateOfBirth ?? "",
        'gender': gender ?? "",
      };

      // Handle file upload
      Map<String, http.MultipartFile>? file;
      if (profileImg != null) {
        final multipartFile = await http.MultipartFile.fromPath(
          'profileImg',
          profileImg.path,
          filename: path.basename(profileImg.path),
        );
        file = {'profileImg': multipartFile};

        print('Sending Image with Mutation:');
        print('Path: ${profileImg.path}');
        print('Name: ${path.basename(profileImg.path)}');
      }

      print(' Sending GraphQL mutation...');

      final result = await GraphQLClientService.fetchData(
        query: mutation,
        variables: variables,
        file: file,
      );

      final responseData = result.data?['createUserProfile'];

      if (responseData != null && responseData['success'] == true) {
        final data = responseData['data'];


        user_model.UserData updatedUser = user_model.UserData(
          data: user_model.Data(
            userDetailsWithAddress: user_model.UserDetailsWithAddress(
              userId: userId,
              userProfiles: [
                user_model.UserProfiles(
                  firstName: firstName ?? '',
                  lastName: lastName ?? '',
                  dateOfBirth: dateOfBirth ?? '',
                  gender: gender ?? '',
                  profilePictureUrl: '',
                ),
              ],
            ),
          ),
        );




        // Save to local storage
        await saveUserProfileToLocal(updatedUser);
        if (data["profilePictureUrl"] != null) {
          await AmdStorage().createCache(
            'profilePictureUrl',
            data["profilePictureUrl"],
          );
        }

        userData.value = updatedUser;
        userData.refresh();

        print('User profile created successfully: $updatedUser');
        return true;
      } else {
        String? message = responseData?['message'];
        print(
          'Failed to create user profile: ${message ?? "Unknown error"}',
        );
        return false;
      }
    } catch (error) {
      print('Error creating user profile: $error');
      return false;
    }
  }


  Future<bool> updateUserProfile({
    required int userProfileId,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    File? profileImg,
  }) async {
    try {
      int? userProfileId =
          userData
                      .value
                      ?.data
                      ?.userDetailsWithAddress
                      ?.userProfiles
                      ?.isNotEmpty ==
                  true
              ? userData
                  .value
                  ?.data
                  ?.userDetailsWithAddress
                  ?.userProfiles
                  ?.first
                  .userProfileId
              : null;

      // Format dateOfBirth
      String? formattedDateOfBirth;
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        try {
          // Convert from "YYYY-MM-DD"
          List<String> parts = dateOfBirth.split('/');
          if (parts.length == 3) {
            String formattedInput =
                "${parts[2]}-${parts[1]}-${parts[0]}"; // YYYY-MM-DD
            DateTime parsedDate = DateFormat(
              'yyyy-MM-dd',
            ).parseStrict(formattedInput);
            formattedDateOfBirth = DateFormat('yyyy-MM-dd').format(parsedDate);
          } else {
            throw FormatException('Invalid date format');
          }
        } catch (e) {
          print('Invalid date format: $dateOfBirth');
          return false;
        }
      }

      // â Prepare GraphQL mutation
      const String mutation = '''
    mutation UpdateUserProfile(\$userProfileId: Int!, \$firstName: String, \$lastName: String, \$dateOfBirth: Date, \$gender: String, \$profileImg: Upload) {
      updateUserProfile(
        userProfileId: \$userProfileId
        firstName: \$firstName
        lastName: \$lastName
        dateOfBirth: \$dateOfBirth
        gender: \$gender
        profileImg: \$profileImg
      ) {
        success
        message
        data {
          userProfileId
          firstName
          lastName
          dateOfBirth
          gender
          profilePictureUrl
        }
      }
    }
    ''';

      // â Prepare variables
      Map<String, dynamic> variables = {
        'userProfileId': userProfileId,
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': formattedDateOfBirth,
        'gender': gender,
      };

      // â Handle file upload
      Map<String, http.MultipartFile>? file;
      if (profileImg != null) {
        final multipartFile = await http.MultipartFile.fromPath(
          'profileImg',
          profileImg.path,
          filename: path.basename(profileImg.path),
        );
        file = {'profileImg': multipartFile};

        print('ð¸ Sending Image with Mutation:');
        print('â¡ï¸ Path: ${profileImg.path}');
        print('â¡ï¸ Name: ${path.basename(profileImg.path)}');
      }

      print('ð Sending GraphQL mutation for updating profile...');

      // â Send request
      final result = await GraphQLClientService.fetchData(
        query: mutation,
        variables: variables,
        file: file,
      );

      // â Access result.data
      final responseData = result.data?['updateUserProfile'];

      if (responseData != null && responseData['success'] == true) {
        final data = responseData['data'];

        print('â Profile updated successfully: $data');
        return true;
      } else {
        String? message = responseData?['message'];
        print('â Failed to update profile: ${message ?? "Unknown error"}');
        return false;
      }
    } catch (error) {
      print('â Error updating user profile: $error');
      return false;
    }
  }

  bool validateFields() {
    if (nameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        dobController.text.isEmpty ||
        genderValue.value.isEmpty) {
      Get.snackbar(
        "Warning",
        "Please fill all fields correctly",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  /// â Pick Image from Gallery
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);

      // Save image path in local storage
      await AmdStorage().createCache('profilePicturePath', imageFile.path);

      // Update observable variable
      profileImage.value = imageFile;
      cachedProfilePictureUrl.value = imageFile.path;
    }
  }
}
