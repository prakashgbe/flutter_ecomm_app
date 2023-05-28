import 'package:flutter/material.dart';
import '../components/video.dart';
import '/components/grid_card.dart';
import '/components/loader.dart';
import '/models/product.dart';
import '/screens/login.dart';
import '/screens/product.dart';
import '/utils/firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final data = ["1", "2"];
  Future<List<Product>>? products;

  @override
  void initState() {
    super.initState();
    products = FirestoreUtil.getProducts([]);
  }

  @override
  Widget build(BuildContext context) {
    onCardPress(Product product) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductScreen(
                    product: product,
                  )));
    }
    

    return FutureBuilder<List<Product>>(
        future: products,
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return SingleChildScrollView(
              child: Column(
                    children: [
                        //const SizedBox(height: 200,child: VideoComponent(),),
                        const SizedBox(child: Carousel()),
                        SizedBox(
                          height: 450,
                          child: GridView.builder(
                            itemCount: snapshot.data?.length,
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, mainAxisSpacing: 30, crossAxisSpacing: 30),
                            itemBuilder: (BuildContext context, int index) {
                              return GridCard(
                                  product: snapshot.data![index],
                                  index: index,
                                  onPress: () {
                                    onCardPress(snapshot.data![index]);
                                  });
                                          }),
                        )
                    ],
              ),
            );
          } else {
            return const Center(child: Loader());
          }
        });
  }
}

class Carousel extends StatefulWidget {
  const Carousel({
    Key? key,
  }) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late PageController _pageController;

  List<String> images = [
    "https://www.linkpicture.com/q/w1_2.jpg",
    "https://www.linkpicture.com/q/w2_4.jpg",
    "https://www.linkpicture.com/q/w3_4.jpg"
  ];

  int activePage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: PageView.builder(
              itemCount: images.length,
              pageSnapping: true,
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              itemBuilder: (context, pagePosition) {
                bool active = pagePosition == activePage;
                return slider(images, pagePosition, active);
              }),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators(images.length, activePage))
      ],
    );
  }
}

AnimatedContainer slider(images, pagePosition, active) {
  double margin = active ? 10 : 20;

  return AnimatedContainer(
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOutCubic,
    margin: EdgeInsets.all(margin),
    decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(images[pagePosition]))),
  );
}

imageAnimation(PageController animation, images, pagePosition) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, widget) {
      print(pagePosition);

      return SizedBox(
        width: 200,
        height: 400,
        child: widget,
      );
    },
    child: Container(
      margin: EdgeInsets.all(10),
      child: Image.network(images[pagePosition]),
    ),
  );
}

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: EdgeInsets.all(3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black : Color.fromARGB(255, 149, 144, 144),
          shape: BoxShape.circle),
    );
  });
}
