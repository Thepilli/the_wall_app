import 'package:flutter/material.dart';
import 'package:the_wall_social_app/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOutTap;
  const MyDrawer({super.key, this.onProfileTap, this.onSignOutTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          //header
          const DrawerHeader(
              child: Icon(
            Icons.person,
            size: 72,
            color: Colors.white,
          )),

          //home list tile
          MyListTile(
            icon: Icons.home,
            text: 'H O M E',
            onTap: () => Navigator.pop(context),
          ),
          //profile list tile
          MyListTile(
              icon: Icons.person, text: 'P R O F I L E', onTap: onProfileTap),
          const Spacer(),
          //sign out list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
                icon: Icons.logout, text: 'L O G O U T', onTap: onSignOutTap),
          ),
        ],
      ),
    );
  }
}
