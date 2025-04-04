import 'package:zeroq/const/app_exports.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(content, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AmdButton(
                  press: onCancel,
                  buttoncolor: AppColors.whitetextColor,
                  radius: 28.0.w,
                  size: Size(
                    100.0.w,
                    8.0.w,
                  ),
                  child: AmdText(
                    text: "cancel",
                    size: 14.0.w,
                    weight: FontWeight.w600,
                    color: AppColors.greenColor,
                  ),
                ),
                AmdButton(
                  press: onConfirm,
                  buttoncolor: AppColors.greenColor,
                  radius: 28.0.w,
                  size: Size(
                    100.0.w,
                    8.0.w,
                  ),
                  child: AmdText(
                    text: "Confirm",
                    size: 14.0.w,
                    weight: FontWeight.w600,
                    color: AppColors.whitetextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
