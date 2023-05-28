import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '/components/custom_button.dart';
import '/components/list_card.dart';
import '/components/loader.dart';
import '/models/cart.dart';
import '/utils/application_state.dart';
import '/utils/common.dart';
import '/utils/custom_theme.dart';
import '/utils/firestore.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // final carts = ["1", "2"];
  Future<List<Cart>>? carts;
  bool _checkoutButtonLoading = false;
  bool _orderPlaced = false;

  @override
  void initState() {
    super.initState();
    carts = FirestoreUtil.getCart(Provider.of<ApplicationState>(context, listen: false).user);
  }

  void checkout() async {
    setState(() {
      _checkoutButtonLoading = true;
    });
    String error = await CommonUtil.checkoutFlow(Provider.of<ApplicationState>(context, listen: false).user!);

    if (error.isEmpty) {
      CommonUtil.showAlert(context, "Success", "Your order is placed");
    } else {
      CommonUtil.showAlert(context, "Alert", error);
    }

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _checkoutButtonLoading = false;
      carts = FirestoreUtil.getCart(Provider.of<ApplicationState>(context, listen: false).user);
    });
  }

  void submitOrder(){
    //CommonUtil.showAlert(context, "Success", "Your order is placed");
    setState(() {
      _orderPlaced = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Cart>>(
      future: carts,
      builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
        if(_orderPlaced == true){
          return SingleChildScrollView(
            child: Column(
              children: [
			              Text('', style: Theme.of(context).textTheme.headlineLarge),
                    Text('thankorder'.tr, style: Theme.of(context).textTheme.headlineLarge),
                    Text('', style: Theme.of(context).textTheme.headlineLarge),
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/checkmark2.gif',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text('', style: Theme.of(context).textTheme.headlineLarge),
                    Text('orderdetail'.tr, style: Theme.of(context).textTheme.headlineMedium),
                    Text('', style: Theme.of(context).textTheme.headlineMedium),
                    Text('orderno'.tr, style: Theme.of(context).textTheme.headlineMedium),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListCard(cart: snapshot.data![index]);
                      },
                    ),
                    priceFooter(snapshot.data!),
                    Text('', style: Theme.of(context).textTheme.headlineLarge),
              ],
            ),
          );
        }
        if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListCard(cart: snapshot.data![index]);
                  },
                ),
                priceFooter(snapshot.data!),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: CustomButton(
                    text: 'submitorder'.tr,
                    onPress: submitOrder,
                    loading: _checkoutButtonLoading,
                  ),
                )
              ],
            ),
          );
        } else if (snapshot.data != null && snapshot.data!.isEmpty) {
          return const Center(
            child: Icon(
              Icons.add_shopping_cart_sharp,
              color: CustomTheme.yellow,
              size: 150,
            ),
          );
        }
        return Center(child: Loader());
      },
    );
  }

  priceFooter(List<Cart> carts) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            height: 2,
            color: CustomTheme.grey,
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Text('total'.tr, style: Theme.of(context).textTheme.headlineSmall),
                const Spacer(),
                Text("\$ " + FirestoreUtil.getCartTotal(carts).toString(),
                    style: Theme.of(context).textTheme.headlineSmall)
              ],
            ),
          )
        ],
      ),
    );
  }

  orderConfirmationScreen(){
    return const Text('Thanks for your Order');
  }
}
