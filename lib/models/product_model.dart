// models/product_model.dart
// For demo only// For demo only
import 'package:adna/constants.dart';

class ProductModel {
  final String image, brandName, title;
  final String? date;
  final double price;
  final double? dateAfetDiscount;
  final int? dicountpercent;

  ProductModel({
    required this.image,
    required this.brandName,
    required this.title,
     this.date,
     required this.price,
    this.dateAfetDiscount,
    this.dicountpercent,
  });
}
List exemple=[
  [
    'assets/images/user1.jpeg',
  'Joel Jordan',
  'Avocat au barreau',
  'Douala, Cameroun'
  ],
   [
    'assets/images/user2.jpeg',
  'Jessica wendy',
  'Product Designer',
  'Douala, Cameroun'
  ],
  [
    'assets/images/user1.jpeg',
  'Frank Armel',
  'Futter Developpeur',
  'Douala, Cameroun'
  ],
];
List<ProductModel> demoPopularProducts = [
  ProductModel(
    image: productDemoImg1,
    title: "Besoin d'un plombier qualifie pour ma cuisine. Contactez moi pour en savoir plus !",
    brandName: "Plomberie",
    date: "27m Bordeau, France",
    price: 100
    // dateAfetDiscount: 420,
    // dicountpercent: 20,
  ),
  
  ProductModel(
    image: productDemoImg4,
     title: "Je suis a la recherche d'un agent de netoyage ici a bonamoussadi,contactez moi !",
    brandName: 'Agent de netoyage',
    date:  "57m Paris, France",
    price: 100

  ),
  ProductModel(
    image: productDemoImg1,
    title: "Besoin d'un plombier qualifie pour ma cuisine. Contactez moi pour en savoir plus !",
    brandName: 'Agent de netoyage',
    date: "27m Lille, France",
    price: 100

    // dateAfetDiscount: 420,
    // dicountpercent: 20,
  ),
  
  ProductModel(
    image: productDemoImg4,
     title: "Je suis a la recherche d'un agent de netoyage ici a bonamoussadi,contactez moi !",
    brandName: 'Agent de netoyage',           
    date:  "57m Ile de france, France",
    price: 100

  ),
  ProductModel(
    image: productDemoImg1,
    title: "Besoin d'un plombier qualifie pour ma cuisine. Contactez moi pour en savoir plus !",
    brandName:"Plomberie",
    date: "27m Douala, Cameroun",
    price: 100

    // dateAfetDiscount: 420,
    // dicountpercent: 20,
  ),
  
  ProductModel(
    image: productDemoImg4,
     title: "Je suis a la recherche d'un agent de netoyage ici a bonamoussadi,contactez moi !",
    brandName: "Recherche d'un agent de netoyage",
    date:  "57m Douala, Cameroun",
    price: 100

  ),
];
List<ProductModel> demoFlashSaleProducts = [
  ProductModel(
    
    image: productDemoImg5,
    title: "FS - Nike Air Max 270 Really React",
    brandName: "Lipsy london",
    date: 650.62.toString(),
    dateAfetDiscount: 390.36,
    dicountpercent: 40,
    price: 100

  ),
  ProductModel(
    image: productDemoImg6,
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    date: 1264.toString(),
    dateAfetDiscount: 1200.8,
    dicountpercent: 5,
    price: 100

  ),
  ProductModel(
    image: productDemoImg4,
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    date: 800.toString(),
    dateAfetDiscount: 680,
    dicountpercent: 15,
    price: 100

  ),
];
List<ProductModel> demoBestSellersProducts = [
  ProductModel(
    image: "https://i.imgur.com/tXyOMMG.png",
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    date: 650.62.toString(),
    dateAfetDiscount: 390.36,
    dicountpercent: 40,
    price: 100

  ),
  ProductModel(
    image: "https://i.imgur.com/h2LqppX.png",
    title: "white satin corset top",
    brandName: "Lipsy london",
    date: 1264.toString(),
    dateAfetDiscount: 1200.8,
    dicountpercent: 5,
    price: 100

  ),
  ProductModel(
    image: productDemoImg4,
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    date: 800.toString(),
    dateAfetDiscount: 680,
    dicountpercent: 15,
    price: 100

  ),
];
List<ProductModel> kidsProducts = [
  ProductModel(
    image: "https://i.imgur.com/dbbT6PA.png",
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    date: 650.62.toString(),
    dateAfetDiscount: 590.36,
    dicountpercent: 24,
    price: 100

  ),
  ProductModel(
    image: "https://i.imgur.com/7fSxC7k.png",
    title: "Printed Sleeveless Tiered Swing Dress",
    brandName: "Lipsy london",
    date: 650.62.toString(),
    price: 100

  ),
  ProductModel(
    image: "https://i.imgur.com/pXnYE9Q.png",
    title: "Ruffle-Sleeve Ponte-Knit Sheath ",
    brandName: "Lipsy london",
    date: 400.toString(),
    price: 100

  ),
  ProductModel(
    image: "https://i.imgur.com/V1MXgfa.png",
    title: "Green Mountain Beta Warehouse",
    brandName: "Lipsy london",
    date: 400.toString(),
    dateAfetDiscount: 360,
    dicountpercent: 20,
    price: 100

  ),
  ProductModel(
    image: "https://i.imgur.com/8gvE5Ss.png",
    title: "Printed Sleeveless Tiered Swing Dress",
    brandName: "Lipsy london",
    date: 654.toString(),
    price: 100

  ),
  ProductModel(
    image: "https://i.imgur.com/cBvB5YB.png",
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    date: 250.toString(),
    price: 100

  ),
];
