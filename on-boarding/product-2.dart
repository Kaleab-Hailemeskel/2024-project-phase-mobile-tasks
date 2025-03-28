import 'dart:io';

class Product {
  String _name, _description;
  double _price;
  Product(this._name, this._description, this._price);
  void set_name(String? new_name) {
    _name = new_name ?? _name;
  }

  String get_name() {
    return _name;
  }

  String get_desc() {
    return _description;
  }

  double get_price() {
    return _price;
  }

  void set_description(String? new_desc) {
    _description = new_desc ?? _description;
  }

  void set_price(double? new_price) {
    _price = new_price ?? _price;
  }

  void set_all(String? new_name, String? new_desc, double? new_price) {
    this.set_description(new_desc);
    this.set_name(new_name);
    this.set_price(new_price);
  }
}

class ProductManagment {
  List<Product> _products = [];
  void add_product(Product new_product) {
    _products.add(new_product);
  }

  List<Product> get_all_products() {
    return _products;
  }

  bool edit_single_product(
      int index, String? new_name, String? new_desc, double? new_price) {
    if (index >= _products.length || index < 0) {
      return false;
    }
    _products[index].set_all(new_name, new_desc, new_price);
    return true;
  }

  bool delete_single_product(int index) {
    if (index >= _products.length || index < 0) {
      return false;
    }
    _products.removeAt(index);
    return true;
  }
}

class ConsoleInteraction {
  var suk = ProductManagment();
  ConsoleInteraction() {
    this.main_menu();
  }
  void main_menu() {
    while (true) {
      stdout.writeln('------------------------------------------------');
      stdout.writeln('Press: ');
      stdout.writeln('|1. View products in stock');
      stdout.writeln('|2. Add new product');
      stdout.writeln('|3. Delete a single product');
      stdout.writeln('|4. Edit a single product');
      stdout.writeln('|Other to quit');
      stdout.writeln('------------------------------------------------');
      String? choice = '0';
      choice = stdin.readLineSync();

      switch (choice) {
        case '1': view_all_products();
          break;
        case '2': add_product();
          break;
        case '3': delete_prod();
          break;
        case '4': edit_prod();
          break;
        case '':
          break;
        default:
          stdout.writeln(' Have a Great Day.');
          return;
      }
    }
  }

  void view_all_products() {
    stdout.writeln('------------------------------------------------');
    if (suk.get_all_products().isEmpty) {
      stdout.writeln('|There is no Product currently in the stock');
    } else {
      var all_prod = suk.get_all_products();
      for (var i = 0; i < all_prod.length; i++) {
        var curr_prod = all_prod[i];
        stdout.writeln(
            '|${i + 1}. ${curr_prod.get_name()}\t\t${curr_prod.get_price()}\t${curr_prod.get_desc()}\t|');
      }
    }
    stdout.writeln('------------------------------------------------');
  }

  void add_product() {
    var name, price, desc;

    stdout.writeln('------------------------------------------------');
    try {
      stdout.writeln('Name of the Product: ');
      name = stdin.readLineSync();
      stdout.writeln('Descriptoin of the Product:');
      desc = stdin.readLineSync();
      stdout.writeln('Price of the Product:');
      price = stdin.readLineSync();
      stdout.writeln('------------------------------------------------');
      suk.add_product(Product(name, desc, double.parse(price)));
      stdout.writeln('|Product added SUCCESSFULLY');
    } catch (e) {
      stdout.writeln('------------------------------------------------');
      stdout.writeln('| !!!! Product adding FAILED !!!!');
      stdout.writeln('------------------------------------------------');
    }
  }

  void delete_prod() {
    try {
      view_all_products();
      stdout.writeln('');
      var products = suk.get_all_products();
      if (products.isNotEmpty) {
        stdout.writeln(
            '| which product do you want to remove from stock: (Select Product number form 1 to ${products.length})');

        int index = int.parse(stdin.readLineSync()!);
        index -= 1;
        if (suk.delete_single_product(index)) {
          stdout.writeln('|Product Deletion was Successful');
        } else {
          stdout
              .writeln('|Unable to delete because of incorrect product choice');
        }
      }
    } catch (e) {
      stdout.writeln('------------------------------------------------');
      stdout.writeln('!!!! INCORRECT Product No !!!!');
      stdout.writeln('------------------------------------------------');
    }
  }

  void edit_prod() {
    try {
      view_all_products();
      var products = suk.get_all_products();
      if (products.isNotEmpty) {
        stdout.writeln(
            '| which product do you want to Edit from stock: (Select Product number form 1 to ${products.length})');

        int index = int.parse(stdin.readLineSync()!);
        index -= 1;
        if (index >= 0 && index < suk.get_all_products().length) {
          String? price = 'we', name, desc;
          stdout.writeln(
              "| Insert 'NONE' if you don't want to edit the part of the Product");
          stdout.writeln("Insert New name: ");
          name = stdin.readLineSync();
          stdout.writeln("Insert New Description: ");
          desc = stdin.readLineSync();
          stdout.writeln("Insert New Price: ");
          price = stdin.readLineSync();

          if (double.tryParse(price!) == null && price != 'NONE') {
            stdout.writeln('!!! Incorrect Price !!!!');
            stdout.writeln('ending editing');
          } else {
            name = name == 'NONE' ? null : name;
            desc = desc == 'NONE' ? null : desc;
            price = price == 'NONE' ? null : price;

            if (suk.edit_single_product(
                index, name, desc, double.tryParse(price!))) {
              print('| Product ${index + 1} modified SUCCESSFULLY');
            } else {
              print('!!!! Problem Happen while Modifing a Product');
            }
          }
        }
      }
    } catch (e) {
      stdout.writeln('------------------------------------------------');
      print('| !!!! Product Editing FAILED !!!!');
      stdout.writeln('------------------------------------------------');
    }
  }
}

void main() {
  ConsoleInteraction();
}
