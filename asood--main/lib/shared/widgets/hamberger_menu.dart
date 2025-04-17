import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_router.dart';

class MenuDialog extends StatelessWidget {
  const MenuDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Menu"),
      content: Column(
        children: [
          GestureDetector(
            onTap: () {
              context.router.push(VendorHomeRoute(title: "home"));
              /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VendorHomeScreen(
                    title: 'home',
                  ),
                ),
              ); */
            },
            child: const MenuItem(title: "خانه"),
          ),
          GestureDetector(
            onTap: () {
              context.router.push(const RoutesListRoute());
              /*  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScreensListScreen(),
                ),
              ); */
            },
            child: const MenuItem(title: "لیست صفحات"),
          ),
          GestureDetector(
            onTap: () {
              context.router.push(const VendorDashboardRoute());
              /*    Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VendorDashboardScreen(),
                ),
              ); */
            },
            child: const MenuItem(title: "داشبورد فروشنده"),
          ),
          GestureDetector(
            onTap: () {
              context.router.push(const CustomerDashboardRoute());
              /*  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomerDashboardScreen(),
                ),
              ); */
            },
            child: const MenuItem(title: "داشبورد خریدار"),
          ),
          GestureDetector(
            onTap: () {
              context.router.push(const SettingsPageRoute());
              /*   Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPageScreen(),
                ),
              ); */
            },
            child: const MenuItem(title: "تنظیمات"),
          ),
          const MenuItem(title: "درباره ما"),
          GestureDetector(
              onDoubleTap: () {
                SystemNavigator.pop();
              },
              child: const MenuItem(title: "خروج")),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;

  const MenuItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
    );
  }
}

// You can use these classes as follows:
// To show the menu dialog:
// showDialog(context: context, builder: (context) => MenuDialog());
