import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_cart/core/widgets/loading_column.dart';
import 'package:easy_cart/src/account/view_models/account_view_model.dart';
import 'package:easy_cart/src/order/views/order_history_view.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountViewModel>().loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Account")),
      body: Consumer<AccountViewModel>(
        builder: (context, vm, child) {
          if (vm.loading) {
            return LoadingColumn(message: 'Loading account information');
          }

          if (vm.accountError != null) {
            return Center(child: Text('Error: ${vm.accountError!.message}'));
          }

          final userData = vm.user;
          final photoUrl = 'https://avatar.iran.liara.run/public';

          if (userData == null) {
            return const Center(child: Text("User data not found"));
          }

          return ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              // Header
              _buildProfileHeader(
                context,
                userData.username,
                userData.email,
                photoUrl,
              ),
              const SizedBox(height: 10),

              // Account Info
              Column(
                children: [
                  _buildMenuListItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'Profile Information',
                    onTap: () {},
                  ),

                  _buildMenuListItem(
                    context,
                    icon: Icons.history,
                    title: 'Order History',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderHistoryView(),
                      ),
                    ),
                  ),

                  _buildMenuListItem(
                    context,
                    icon: Icons.favorite_border,
                    title: 'Favourites',
                    onTap: () {},
                  ),

                  const Divider(),

                  _buildMenuListItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => vm.logoutUser(),
                  child: Text('Logout'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String userName,
    String userEmail,
    String photoUrl,
  ) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // User Image
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(photoUrl),
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          const SizedBox(width: 20),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(153),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onTap: onTap,
    );
  }
}
