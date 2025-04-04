import '../../const/app_exports.dart';
import './notification_controller.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotificationPage'),
      ),
      body: Container(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
