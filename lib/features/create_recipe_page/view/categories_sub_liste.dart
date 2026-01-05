import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/components/text_input.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../widget/base_filtre_item.dart';

class CategoriesSubListe extends StatelessWidget {
  const CategoriesSubListe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: context.symmetricPadding(12, 20),
              child: TextInputWidget(
                onChanged: (value) {
                  // newContext
                  //     .read<SteamListingsViewmodel>()
                  //     .adjustVariationsSearchList(value: value);
                },
                height: context.dynamicHeight(0.05),
                suffixIcon: Padding(
                  padding: EdgeInsets.all(9),
                  child: GestureDetector(
                    onTap: () {
                      // _searchController.clear();
                      // newContext
                      //     .read<SteamListingsViewmodel>()
                      //     .adjustVariationsSearchList(value: '');
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Constant.fillLight(context),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          PhosphorIcons.x(PhosphorIconsStyle.bold),
                          size: 12.0,
                          color: Constant.iconDark(context),
                        ),
                      ),
                    ),
                  ),
                ),
                prefixIcon: PhosphorIcon(
                  PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
                  color: Constant.iconDark(context),
                ),
                controller: TextEditingController(),
                hintText: 'Tür ara, AK47, Bayonet...',
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Expanded(
              child: Padding(
                padding: context.symmetricPadding(0, 20),
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    // var item = state.searchVariationList[index];
                    return BaseFitreItem(
                      isChecked: true,
                      onChanged: () {
                        // newContext
                        //     .read<SteamListingsViewmodel>()
                        //     .marketHashNameBareAdjust(
                        //       subTitle: item.short ?? '',
                        //       title: widget.title,
                        //       context: context,
                        //     );
                      },
                      title: 'test',
                      image:
                          'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?cs=srgb&dl=pexels-ash-craig-122861-376464.jpg&fm=jpg',
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
