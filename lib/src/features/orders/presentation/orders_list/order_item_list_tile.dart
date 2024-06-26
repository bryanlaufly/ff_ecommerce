import 'package:ecommerce_app/src/common_widgets/async_value.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/custom_image.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows an individual order item, including price and quantity.
class OrderItemListTile extends ConsumerWidget {
  const OrderItemListTile({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Read from data source
    // final product = ref.watch(fakeProductsRepositoryProvider).getProduct(item.productId)!;
        // FakeProductsRepository.instance.getProduct(item.productId)!;
    final product = ref.watch(productStreamProvider(item.productId));

    return AsyncValueWidget<Product?>(
      value: product, 
      data: (orderProduct){
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: CustomImage(imageUrl: orderProduct!.imageUrl),
              ),
              gapW8,
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(orderProduct.title),
                    gapH12,
                    Text(
                      'Quantity: ${item.quantity}'.hardcoded,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
  //     child: Row(
  //       children: [
  //         Flexible(
  //           flex: 1,
  //           child: CustomImage(imageUrl: product.imageUrl),
  //         ),
  //         gapW8,
  //         Flexible(
  //           flex: 3,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(product.title),
  //               gapH12,
  //               Text(
  //                 'Quantity: ${item.quantity}'.hardcoded,
  //                 style: Theme.of(context).textTheme.bodySmall,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  }
}
