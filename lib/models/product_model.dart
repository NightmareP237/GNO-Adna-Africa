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

List exemple = [
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
      title:
          "Besoin d'un plombier qualifie pour ma cuisine. Contactez moi pour en savoir plus !",
      brandName: "Plomberie",
      date: "27m Bordeau, France",
      price: 100
      // dateAfetDiscount: 420,
      // dicountpercent: 20,
      ),
  ProductModel(
      image: productDemoImg4,
      title:
          "Je suis a la recherche d'un agent de netoyage ici a bonamoussadi,contactez moi !",
      brandName: 'Agent de netoyage',
      date: "57m Paris, France",
      price: 100),
  ProductModel(
      image: productDemoImg1,
      title:
          "Besoin d'un plombier qualifie pour ma cuisine. Contactez moi pour en savoir plus !",
      brandName: 'Agent de netoyage',
      date: "27m Lille, France",
      price: 100

      // dateAfetDiscount: 420,
      // dicountpercent: 20,
      ),
  ProductModel(
      image: productDemoImg4,
      title:
          "Je suis a la recherche d'un agent de netoyage ici a bonamoussadi,contactez moi !",
      brandName: 'Agent de netoyage',
      date: "57m Ile de france, France",
      price: 100),
  ProductModel(
      image: productDemoImg1,
      title:
          "Besoin d'un plombier qualifie pour ma cuisine. Contactez moi pour en savoir plus !",
      brandName: "Plomberie",
      date: "27m Douala, Cameroun",
      price: 100

      // dateAfetDiscount: 420,
      // dicountpercent: 20,
      ),
  ProductModel(
      image: productDemoImg4,
      title:
          "Je suis a la recherche d'un agent de netoyage ici a bonamoussadi,contactez moi !",
      brandName: "Recherche d'un agent de netoyage",
      date: "57m Douala, Cameroun",
      price: 100),
];
List<ProductModel> demoFlashSaleProducts = [
  ProductModel(
      image: productDemoImg5,
      title: "FS - Nike Air Max 270 Really React",
      brandName: "Lipsy london",
      date: 650.62.toString(),
      dateAfetDiscount: 390.36,
      dicountpercent: 40,
      price: 100),
  ProductModel(
      image: productDemoImg6,
      title: "Green Poplin Ruched Front",
      brandName: "Lipsy london",
      date: 1264.toString(),
      dateAfetDiscount: 1200.8,
      dicountpercent: 5,
      price: 100),
  ProductModel(
      image: productDemoImg4,
      title: "Mountain Beta Warehouse",
      brandName: "Lipsy london",
      date: 800.toString(),
      dateAfetDiscount: 680,
      dicountpercent: 15,
      price: 100),
];
List<ProductModel> demoBestSellersProducts = [
  ProductModel(
      image: "https://i.imgur.com/tXyOMMG.png",
      title: "Green Poplin Ruched Front",
      brandName: "Lipsy london",
      date: 650.62.toString(),
      dateAfetDiscount: 390.36,
      dicountpercent: 40,
      price: 100),
  ProductModel(
      image: "https://i.imgur.com/h2LqppX.png",
      title: "white satin corset top",
      brandName: "Lipsy london",
      date: 1264.toString(),
      dateAfetDiscount: 1200.8,
      dicountpercent: 5,
      price: 100),
  ProductModel(
      image: productDemoImg4,
      title: "Mountain Beta Warehouse",
      brandName: "Lipsy london",
      date: 800.toString(),
      dateAfetDiscount: 680,
      dicountpercent: 15,
      price: 100),
];
List<ProductModel> kidsProducts = [
  ProductModel(
      image:
          "https://mode-africaine.fr/cdn/shop/collections/vetement-africain-homme.jpg?v=1626290784",
      title: "Boubou d'Afrique de l'ouest",
      brandName: "Disponible 🇸🇳 🇧🇯",
      date: 650.62.toString(),
      dateAfetDiscount: 590.36,
      dicountpercent: 24,
      price: 100),
  ProductModel(
      image:
          "https://www.semaest.fr/fileadmin/webmaster-medias/actualites/Epicerie-livreur-du-bled-semaest-paris-18-jus.jpg",
      title: "Epice Africain ecrase",
      brandName: "Disponible  🇬🇦 🇨🇲",
      date: 650.62.toString(),
      price: 40),
  ProductModel(
      image:
          "https://i.pinimg.com/564x/af/1b/71/af1b71af95e64c3bf1e31fb9badf22ed.jpg",
      title: "Boucle d'oreille royal africain",
      brandName: "Disponible 🇫🇷 🇨🇲",
      date: 400.toString(),
      price: 150),
  ProductModel(
      image:
          "https://boutique-africaine.com/cdn/shop/collections/bijoux-africains.jpg?v=1616315324",
      title: "Collier tisse de pierre precieuse",
      brandName: "Disponible  🇬🇦 🇨🇲 🇫🇷",
      date: 400.toString(),
      dateAfetDiscount: 360,
      dicountpercent: 20,
      price: 200),
  ProductModel(
      image: "https://m.media-amazon.com/images/I/A1AZ0KR5G9L._AC_UY350_.jpg",
      title: "Collier, bracellet et boucle d'oreille africain",
      brandName: "Disponible  🇨🇲 🇿🇦 🇫🇷",
      date: 654.toString(),
      price: 300),
  ProductModel(
      image:
          "https://kaolack-creations.com/cdn/shop/products/braceletafricainlamoundiaxassargentbykaolackcreations_4_500x.jpg?v=1704015503",
      title: "Collier et bague de vie de Ank",
      brandName: "Disponible 🇨🇲 🇿🇦 🇫🇷",
      date: 250.toString(),
      price: 100),
  ProductModel(
      image:
          "https://www.modeafricaine.com/wp-content/uploads/2021/04/584D333C-A94C-4CB1-BA7E-532B8E8B2905.jpeg",
      title: "Robe en wax africain tres jolie",
      brandName: "Disponible 🇫🇷 🇨🇲 🇿🇦",
      date: 250.toString(),
      price: 100),
  ProductModel(
      image:
          "https://media.istockphoto.com/id/1479976652/fr/vectoriel/portrait-tribal-africain-dune-femme-noire-v%C3%AAtue-de-v%C3%AAtements-et-de-bijoux-anciens-dessin.jpg?s=612x612&w=0&k=20&c=1KoPDNW9N4EU89cxmApytOM_LLI1lSEwbI0Q5Akwjyc=",
      title: "Oeuvre d'art africain",
      brandName: "Disponible 🇧🇯 🇫🇷 🇨🇲",
      date: 250.toString(),
      price: 230),
];
