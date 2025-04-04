import 'package:shimmer/shimmer.dart';
import 'package:zeroq/const/app_exports.dart';
import 'package:zeroq/models/user_data_model.dart';
import 'package:zeroq/precentation/auth/auth_controller.dart';
import 'package:zeroq/precentation/settings/address/address_controller.dart';
import 'package:zeroq/uttility/custom_widget/custom_dialog.dart';
import '../../pick_up/pick_up_controller.dart';
import 'add_address_page.dart';

class AddressPage extends GetView<AddressController> {
  AddressPage({super.key});

  final AuthController authController = Get.find<AuthController>();
  final AddressController addressController = Get.find<AddressController>();
  final PickUpController pickupController = Get.find<PickUpController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addressController.fetchUserDetails1(); // ✅ Always fetch fresh data
    });

    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(AmdRoutesClass.pickUpPage);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.offNamed(AmdRoutesClass.pickUpPage),
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
              color: AppColors.greenColor,
            ),
          ),
          title: AmdText(
            text: 'Your Address',
            color: AppColors.blackColor,
            size: 20.0.sp,
            weight: FontWeight.w600,
          ),
          elevation: 0.0,
        ),
        body: Obx(() {
          final userAddressDetails = authController.userAddressDetails.value;

          if (userAddressDetails == null) {
            return const Center(child: CircularProgressIndicator());
          }

          List<UserRegularAddress> regularAddresses =
              userAddressDetails.userRegularAddresses ?? [];

          return Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              children: [
                addAddressBtn(context),
                SizedBox(height: 12.0.h),
                Expanded(
                  child:
                      regularAddresses.isNotEmpty
                          ? ListView.builder(
                            itemCount: regularAddresses.length,
                            itemBuilder: (BuildContext context, int index) {
                              UserRegularAddress address =
                                  regularAddresses[index];
                              IconData iconData =
                                  address.addressType == "home"
                                      ? FontAwesomeIcons.house
                                      : FontAwesomeIcons.briefcase;
                              return addressTile(iconData, address, context);
                            },
                          )
                          : const Center(
                            child: Text(
                              "No addresses found.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget addressTile(
    IconData icon,
    UserRegularAddress address,
    BuildContext context,
  ) {
    List<Widget> details = [];

    if (address.houseName.isNotEmpty) {
      details.add(_detailRow('House Name', address.houseName));
    }
    if (address.locality.isNotEmpty) {
      details.add(_detailRow('Landmark', address.locality));
    }
    if (address.city.isNotEmpty) {
      details.add(_detailRow('City', address.city));
    }
    if (address.state.isNotEmpty) {
      details.add(_detailRow('State', address.state));
    }
    if (address.postalCode.isNotEmpty) {
      details.add(_detailRow('Postal Code', address.postalCode));
    }
    if (address.address.isNotEmpty) {
      details.add(_detailRow('Address', address.address));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 12.0.h),
      decoration: ShapeDecoration(
        color: AppColors.whitetextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.w),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [SizedBox(width: 30.0.w, child: Icon(icon, size: 20))],
          ),
          SizedBox(width: 12.0.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (address.addressType.isNotEmpty)
                  Text(
                    address.addressType,
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF555555),
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (address.addressType.isNotEmpty) SizedBox(height: 3.h),
                ...details,
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              FontAwesomeIcons.ellipsisVertical,
              color: AppColors.greenColor,
            ),
            onSelected: (value) {
              if (value == 'delete') {
                confirmDelete(context, address.addressId);
              } else if (value == 'select') {
                addressController.userDetails();
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem(
                    value: 'select',
                    child: Center(
                      child: Text(
                        'Select',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Center(
                      child: Text(
                        'Delete',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.0.h),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.montserrat(
            color: const Color(0xFF555555),
            fontSize: 12.0.sp,
          ),
          children: [
            TextSpan(
              text: '$label - ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void confirmDelete(BuildContext context, int addressId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: "Confirmation",
          content: "Are you sure you want to delete address?",
          onConfirm: () async {
            Navigator.of(context).pop();
            await controller.deleteUserAddress(addressId);
            addressController.userAddressDetails();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Widget addAddressBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddAddressScreen()),
        );
      },
      borderRadius: BorderRadius.circular(12.0.w),
      child: Container(
        height: 65.0.h,
        padding: const EdgeInsets.all(20),
        decoration: ShapeDecoration(
          color: AppColors.whitetextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.w),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(FontAwesomeIcons.plus),
                SizedBox(width: 12.0.w),
                Text(
                  "Add Address",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Icon(FontAwesomeIcons.chevronRight),
          ],
        ),
      ),
    );
  }
}
