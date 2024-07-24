import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  // FakeProductsRepository._();

  // static FakeProductsRepository instance = FakeProductsRepository._();
  FakeProductsRepository({this.addDelay = true});

  final List<Product> _products = kTestProducts;
  final bool addDelay;

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    // try {
    //   return _fakeProducts.firstWhere((product) => product.id == id);
    // } catch (e) {
    //   return null;
    // }
    return _getProduct(_products, id);
  }
  

  Future <List<Product>> fetchProductsList() async {
    // await Future.delayed(const Duration(seconds: 2));
    delay(addDelay);
    // for testing purpose
    // throw Exception('error');
    return Future.value(_products);
  }

  Stream <List<Product>> watchProductsList() async* {
    // await Future.delayed(const Duration(seconds: 2));
    delay(addDelay);
    yield _products;
    // return Stream.value(_fakeProducts);
  }

  Stream <Product?> watchProduct(String id) {
    // return watchProductsList().map((products) {
    //   return products.firstWhere((product) => product.id == id);
    // });
    return watchProductsList().map((products) {
        return _getProduct(products, id);
    });
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

}

final fakeProductsRepositoryProvider = Provider<FakeProductsRepository>((ref) => FakeProductsRepository());

final productsListStreamProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  debugPrint('created productsListStreamProvider');
  final fakeProductsRepository = ref.watch(fakeProductsRepositoryProvider);
  return fakeProductsRepository.watchProductsList();
});

final productsListFutureProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  final fakeProductsRepository = ref.watch(fakeProductsRepositoryProvider);
  return fakeProductsRepository.fetchProductsList();
});

final productStreamProvider =
    StreamProvider.autoDispose.family<Product?, ProductID>((ref, id) {
  debugPrint('created productStreamProvider for id $id');

  // if remove autoDispose above, then when we navigate back to the same page, ref.onResume will appear
  ref.onResume(() => debugPrint('onResume productStreamProvider for id $id'));
  ref.onCancel(() => debugPrint('onCancel productStreamProvider for id $id'));
  ref.onDispose(() => debugPrint('dispose productStreamProvider for id $id'));

  // final link = ref.keepAlive();
  // final timer = Timer(const Duration(seconds: 2), () => link.close());
  // ref.onDispose(() {
  //   timer.cancel();
  //   debugPrint('onDispose productStreamProvider for id $id');
  // });

  final fakeProductsRepository = ref.watch(fakeProductsRepositoryProvider);

  return fakeProductsRepository.watchProduct(id);
});
