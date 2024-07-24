import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeProductsRepository makeProductsRepository() => FakeProductsRepository(addDelay:false);

  // unit test for FakeProductsRepository().getProductsList()
  test('FakeProductsRepository.getProductsList returns a list of products', () {
    final repository = makeProductsRepository();
    final products = repository.getProductsList();
    expect(products, isNotNull);
    expect(products, isA<List>());
    expect(products, isNotEmpty);
    expect(products.first, isA<Product>());
    expect(products, kTestProducts);
  });

// unit test for FakeProductsRepository().getProduct();
  group('FakeProductsRepository.getProduct', () {
    final repository = makeProductsRepository();

    test('returns correct product for existing id', () {
      final product = repository.getProduct('1');
      expect(product, isNotNull);
      expect(product, isA<Product>());
      expect(product!.id, '1');
      expect(product, kTestProducts[0]);
    });

    test('returns null for non-existing id', () {
      final product = repository.getProduct('999');
      expect(product, isNull);
    });

    test('returns null for empty id', () {
      final product = repository.getProduct('');
      expect(product, isNull);
    });

    test('returns correct products for all test product ids', () {
      for (final testProduct in kTestProducts) {
        final product = repository.getProduct(testProduct.id);
        expect(product, isNotNull);
        expect(product!.id, testProduct.id);
        expect(product, testProduct);
      }
    });
  });

// unit test for FakeProductsRepository().fetchProductsList()
  group('test fetchProductList', (){
    final repository = makeProductsRepository();
    test('FakeProductsRepository.fetchProductsList returns a list of products', () async {
      final products = await repository.fetchProductsList();
      expect(products, isNotNull);
      expect(products, isA<List>());
      expect(products, isNotEmpty);
      expect(products.first, isA<Product>());
      expect(products, kTestProducts);
    });

    test('FakeProductsRepository.fetchProductsList returns products asynchronously', () async {
      final futureProducts = repository.fetchProductsList();
      expect(futureProducts, isA<Future<List<Product>>>());
      final products = await futureProducts;
      expect(products, isNotNull);
      expect(products, isA<List<Product>>());
      expect(products, isNotEmpty);
      expect(products.first, isA<Product>());
      expect(products, kTestProducts);
    });

    test('FakeProductsRepository.fetchProductsList completes in less than 3 seconds', () async {
      final stopwatch = Stopwatch()..start();
      await repository.fetchProductsList();
      stopwatch.stop();
      expect(stopwatch.elapsed, lessThan(const Duration(seconds: 3)));
    });
  });

  group('test watchProductsList', (){
    final repository = makeProductsRepository();
    test('FakeProductsRepository.watchProductsList() emits list of products', () {
      expect(
        repository.watchProductsList(),
        emits(isA<List<Product>>()),
      );
    });

    test('FakeProductsRepository.watchProductsList() emits global list', () {
      expect(
        repository.watchProductsList(),
        emits(equals(kTestProducts)),
      );
    });  

    test('FakeProductsRepository.watchProductsList() emits one value', () {
      expect(
        repository.watchProductsList(),
        emitsInOrder([
          isA<List<Product>>(),
          emitsDone,
        ]),
      );
    });
  });

  group('test watchProduct', (){
    final repository = makeProductsRepository();
    test('FakeProductsRepository.watchProduct() emits null for non-existent product', () {
      const nonExistentId = 'non-existent-id';
      expect(
        repository.watchProduct(nonExistentId),
        emits(isNull),
      );
    });

    test('FakeProductsRepository.watchProduct() emits one value and completes', () {
      const testId = '1';
      expect(
        repository.watchProduct(testId),
        emitsInOrder([
          isA<Product>(),
          emitsDone,
        ]),
      );
    });

    test('FakeProductsRepository.watchProduct(1) emits 1st item in list', () {
      const testId = '1';
      expect(
        repository.watchProduct(testId),
        emits(equals(kTestProducts[0])),
      );
    });

    test('FakeProductsRepository.watchProduct(100) emits null on 100th item in list', () {
      const testId = '100';
      expect(
        repository.watchProduct(testId),
        emits (null),
      );
    });
  });

}