import 'package:fit_eat/core/components/appbar.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/constants/text_constants.dart';
import 'package:fit_eat/features/auth_page/model/app_user.dart';
import 'package:fit_eat/features/recipe_feed/viewmodel/recipe_feed_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/components/text_input.dart';
import '../../../core/entities/category/category_list.dart';
import '../../auth_page/state/auth_state.dart';
import '../../auth_page/viewmodel/auth_viewmodel.dart';
import '../../recipe_feed/state/recipe_feed_state.dart';
import '../widget/anonim_container_for_signup.dart';
import '../widget/last_visited_widget.dart';
import '../../recipe_feed/view/recipe_widget.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AuthViewmodel viewmodel;
  late RecipeFeedViewmodel recipeFeedViewmodel;
  @override
  void initState() {
    viewmodel = context.read<AuthViewmodel>();
    recipeFeedViewmodel = context.read<RecipeFeedViewmodel>();
    recipeFeedViewmodel.getAllRecipes();
    super.initState();
  }

  // List categoryList = ['Dinner', 'Breakfast', 'Salads', 'Lunch', 'Snacks'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Constant.fillWhite(context),
      appBar: CustomAppBar(
        // bottomBorder: Constant.fillPrimaryDark(context),
        // backgroundColor: Constant.fillPrimaryDark(context),
        isVisibleWidth: false,
        centerWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: TextInputWidget(
            prefixIcon: PhosphorIcon(
              PhosphorIconsBold.magnifyingGlass,
              size: 24,
              color: Constant.iconDark(context),
            ),
            hintText: "Find the reciepes",
            height: context.dynamicHeight(0.047),
            controller: TextEditingController(),
            keyboardType: TextInputType.text,
          ),
        ),
        isVisibleLeading: false,
        actions: [SizedBox()],
      ),
      body: BlocBuilder<AuthViewmodel, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status == AuthStatus.authenticated)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Constant.fillBase(context),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DefaultUserImage(radius: 28),

                        // CircleAvatar(
                        //   radius: 28,
                        //   backgroundColor: Constant.fillBase(context),
                        //   backgroundImage: NetworkImage(
                        //     'https://cdn.bynogame.com/shop/shop-default-square-1642511991533.jpeg',
                        //   ),
                        // ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            // color: Colors.blue,
                            height: context.dynamicHeight(0.07),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Seni yeniden görmek güzel,',
                                  style: Theme.of(context).textTheme.labelSmall,
                                  // ?.copyWith(
                                  //   color: Constant.textFixWhite(context),
                                  // ),
                                ),
                                SizedBox(height: 4),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Rojin TEMEL 👋',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                    // ?.copyWith(
                                    //   color: Constant.textFixWhite(context),
                                    // ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (state.status == AuthStatus.anonymous)
                  AnonimContainerForSignUp(),
                Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    left: 20,
                    right: 20,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Tümünü Gör',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(categoryList.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              categoryList[index].imageUrl,
                              height: context.dynamicHeight(0.12),
                              width: context.dynamicWidth(0.28),
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    left: 20,
                    right: 20,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Son Gezdiğin Ürünler',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Tümünü Gör',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(categoryList.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: LastVisitedWidget(),
                        );
                      }),
                    ),
                  ),
                ),
                BlocBuilder<RecipeFeedViewmodel, RecipeFeedState>(
                  builder: (context, state) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: state.recipes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.493,
                          ),
                      itemBuilder: (context, index) {
                        final model = state.recipes[index];
                        return RecipeWidget(model: model);
                      },
                    );
                  },
                ),
                SizedBox(height: 100),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 20),
                //   child: Column(
                //     children: List.generate(8, (index) {
                //       return ProductWidget();
                //     }),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
