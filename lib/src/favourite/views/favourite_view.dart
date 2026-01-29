import 'package:easy_cart/core/themes/app_color.dart';
import 'package:easy_cart/src/favourite/view_models/favourite_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteView extends StatefulWidget {
  const FavouriteView({super.key});

  @override
  State<FavouriteView> createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FavouriteViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Favourites")),
      body: ListView.builder(
        itemCount: vm.favItems.length,
        itemBuilder: (context, index) {
          return _buildCartItemCard(context, index, vm);
        },
      ),
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    int index,
    FavouriteViewModel vm,
  ) {
    final favItem = vm.favItems[index];
    final isFav = vm.isFavourite(productId: favItem.productId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                favItem.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favItem.productName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "RM ${favItem.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: IconButton(
                          onPressed: () => vm.removeFavouriteById(
                            productId: favItem.productId,
                          ),
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : AppColor.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
