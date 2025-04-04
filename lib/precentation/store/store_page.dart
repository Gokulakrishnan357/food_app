import '../../const/app_exports.dart';
import './store_controller.dart';

class StorePage extends GetView<StoreController> {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StorePage'),
      ),
      body: Container(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
