import '../../../const/app_exports.dart';
import 'CustomTextField.dart';
import 'Dob.dart';
import 'profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  void _handleProfileAction() {
    if (!controller.validateFields()) return;

    bool hasProfile = controller.userData.value?.data?.userDetailsWithAddress?.userProfiles?.isNotEmpty == true;
    int? userProfileId = hasProfile ? controller.userData.value?.data?.userDetailsWithAddress?.userProfiles?.first.userProfileId : null;

    Get.dialog(
      AlertDialog(
        title: Text(hasProfile ? "Update Profile" : "Create Profile"),
        content: const Text("Please check your details before proceeding."),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("No")),
          TextButton(
            onPressed: () async {
              Get.back();

              bool isSuccess;
              if (hasProfile && userProfileId != null) {
                isSuccess = await controller.updateUserProfile(
                  userProfileId: userProfileId,
                  firstName: controller.nameController.text.trim(),
                  lastName: controller.lastnameController.text.trim(),
                  dateOfBirth: controller.dobController.text.trim(),
                  gender: controller.genderValue.value.trim(),
                  profileImg: controller.profileImage.value,
                );
              } else {
                isSuccess = await controller.createUserProfile(
                  firstName: controller.nameController.text.trim(),
                  lastName: controller.lastnameController.text.trim(),
                  dateOfBirth: controller.dobController.text.trim(),
                  gender: controller.genderValue.value.trim(),
                  profileImg: controller.profileImage.value,
                );
              }

              if (isSuccess) {
                Get.snackbar("Success", hasProfile ? "Profile updated successfully" : "Profile created successfully");
              } else {
                Get.snackbar("Error", "Failed to ${hasProfile ? 'update' : 'create'} profile");
              }
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {

            Get.offNamed('/pickUpPage');
          },
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: AppColors.greenColor,
          ),
        ),
        title: Text(
          "Your Profile",
          style: GoogleFonts.montserrat(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async => await controller.pickImage(),
                child: Stack(
                  children: [
                    Obx(() => CircleAvatar(
                      radius: 60.0,
                      backgroundImage: controller.profileImage.value != null
                          ? FileImage(controller.profileImage.value!) as ImageProvider
                          : (controller.cachedProfilePictureUrl.value.isNotEmpty)
                          ? NetworkImage(controller.cachedProfilePictureUrl.value)
                          : const NetworkImage("https://images.unsplash.com/photo-1499714608240-22fc6ad53fb2?ixlib=rb-4.0.3&auto=format&fit=crop&w=880&q=80"),
                      backgroundColor: Colors.grey.shade200,
                    )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(controller: controller.nameController, hint: "Enter your Name", isTextOnly: true),
              const SizedBox(height: 10),
              CustomTextField(controller: controller.lastnameController, hint: "Enter your Last Name", isTextOnly: true),
              const SizedBox(height: 10),
              DateOfBirthField(controller: controller.dobController),
              const SizedBox(height: 10),
              dropDownInputField(controller.genderValue, "Select Your Gender"),
              const SizedBox(height: 25),
              Obx(() {
                bool hasProfile = controller.userData.value?.data?.userDetailsWithAddress?.userProfiles?.isNotEmpty == true;
                if (hasProfile) {
                  GetStorage().write('hasProfile', true);
                }
                return ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _handleProfileAction();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    hasProfile || GetStorage().read('hasProfile') == true ? "UPDATE PROFILE" : "CREATE PROFILE",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDownInputField(RxString value, String hintText) {
    final List<String> dropdownItems = ['Male', 'Female'];
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Obx(() => DropdownButtonFormField<String>(
        value: dropdownItems.contains(value.value) && value.value.isNotEmpty ? value.value : null,
        onChanged: (String? newValue) => value.value = newValue ?? '',
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF4F4F4),
          hintText: hintText,
          hintStyle: GoogleFonts.robotoFlex(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
        ),
        items: dropdownItems.map((String gender) => DropdownMenuItem<String>(value: gender, child: Text(gender))).toList(),
      )),
    );
  }
}
