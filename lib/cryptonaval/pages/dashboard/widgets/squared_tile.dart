import 'package:app_movil_dincydet/cryptonaval/config/theme.dart';
import 'package:app_movil_dincydet/main.dart';
import 'package:flutter/cupertino.dart';

class SquaredTile extends StatelessWidget {
  const SquaredTile({
    super.key,
    required this.title,
    required this.icon,
    this.count,
    this.route,
  });

  final String title;
  final IconData icon;
  final int? count;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        onTap: onTapButton,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (count != null)
                  Text(
                    ' ($count)',
                    style: const TextStyle(
                      color: Color(0xFFCA8D32),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Icon(
              icon,
              size: 40,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void onTapButton() {
    if (route != null) {
      Navigator.of(navigatorKey.currentContext!).pushNamed(route!);
    }
  }
}
