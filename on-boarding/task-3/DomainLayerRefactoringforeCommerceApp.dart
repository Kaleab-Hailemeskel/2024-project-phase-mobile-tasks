import 'dart:convert';
import 'dart:io';

class Product {
  String _id, _name, _description, _imageUrl;
  double _price;
  Product(this._id, this._name, this._description, this._price, this._imageUrl);
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'description': _description,
      'price': _price,
      'imageUrl': _imageUrl,
    };
  }

  static Product? toProduct(Map<String, dynamic> val) {
    if (val.isNotEmpty) {
      return new Product(
        val['id'],
        val['name'],
        val['description'],
        val['price'],
        val['imageUrl'],
      );
    } else {
      return null;
    }
  }

  String toString() {
    return '$_id \t$_name \t$_price \t$_description \t$_imageUrl';
  }
}

class ViewAllProductsUsecase {
  Future<List<Product?>> call() async {
    String from_json = '';
    try {
      from_json = await File('products.json').readAsString();
    } catch (e) {
      print('reading from products.json has error');
      return [];
    }
    List<dynamic> products_from_json = [];

    try {
      products_from_json = jsonDecode(from_json);
    } on FormatException {
      return [];
    }
    print('passed');
    print(products_from_json);

    return products_from_json.isNotEmpty
        ? products_from_json.map((product) {
          return Product.toProduct(product);
        }).toList()
        : [];
  }
}

class ViewProductUsecase {
  Future<Product?> call(String search_id) async {
    ViewAllProductsUsecase all_products = ViewAllProductsUsecase();
    List<Product?> products = await all_products();
    for (Product? single_product in products) {
      if (single_product != null && single_product._id == search_id) {
        return single_product;
      }
    }
    return null;
  }
}

class CreateProductUsecase {
  Future<bool> call(Product new_prod) async {
    ViewAllProductsUsecase all_products = ViewAllProductsUsecase();
    List<Product?> product_list = await all_products();
    product_list.add(new_prod);

    List<Map<String, dynamic>> json_obj =
        product_list
            .where((ele) => ele != null)
            .map((ele) => ele!.toJson())
            .toList();
    String json_string = jsonEncode(json_obj);
    try {
      await File('products.json').writeAsString(json_string);
    } catch (e) {
      print('!! File Writing go Wrong !!');
      return false;
    }

    return true;
  }
}

class UpdateProductUsecase {
  Future<bool> call(Product new_prod) async {
    ViewAllProductsUsecase all_products = ViewAllProductsUsecase();
    List<Product?> product_list = await all_products();
    product_list =
        product_list
            .where((ele) => ele != null && ele._id != new_prod._id)
            .toList();
    product_list.add(new_prod);
    List<Map<String, dynamic>> json_obj =
        product_list
            .where((ele) => ele != null)
            .map((ele) => ele!.toJson())
            .toList();
    String json_string = jsonEncode(json_obj);
    try {
      await File('products.json').writeAsString(json_string);
    } catch (e) {
      print('!! File Writing go Wrong !!');
      return false;
    }

    return true;
  }
}

class DeleteProductUsecase {
  Future<bool> call(String delete_id) async {
    ViewAllProductsUsecase all_products = ViewAllProductsUsecase();
    List<Product?> product_list = await all_products();
    product_list.removeWhere((ele) => ele != null && ele._id == delete_id);
    List<Map<String, dynamic>> json_obj =
        product_list
            .where((ele) => ele != null)
            .map((ele) => ele!.toJson())
            .toList();
    String json_string = jsonEncode(json_obj);
    try {
      await File('products.json').writeAsString(json_string);
    } catch (e) {
      print('!! File Writing go Wrong !!');
      return false;
    }

    return true;
  }
}
