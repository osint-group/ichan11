import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iChan/blocs/blocs.dart';
import 'package:iChan/models/thread_storage.dart';
import 'package:iChan/services/exports.dart';
import 'package:iChan/services/my.dart' as my;

import 'favorites.dart';

class FavoritesGrid extends StatelessWidget {
  const FavoritesGrid({Key key}) : super(key: key);

  Future<void> showMenu(BuildContext context, ThreadStorage fav) async {
    final sheet = [
      ActionSheet(
          text: "Delete",
          color: my.theme.alertColor,
          onPressed: () {
            my.favoriteBloc.add(FavoriteDeleted(fav: fav));
            my.favoriteBloc.add(FavoriteUpdated());
          }),
      ActionSheet(
          text: fav.refresh == false ? 'Turn on refresh' : 'Turn off refresh',
          onPressed: () {
            fav.refresh = !fav.refresh;
            fav.save();
            my.favoriteBloc.add(FavoriteUpdated());
          }),
    ];

    return await Interactive(context).modal(sheet);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        final favsList = my.favoriteBloc.favoritesList;

        int gridItemsCount;

        return OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            gridItemsCount = my.contextTools.isPhone ? 3 : 6;
          } else {
            gridItemsCount = my.contextTools.isPhone ? 2 : 4;
          }
          return GridView.builder(
            padding: const EdgeInsets.only(left: 5, right: 5, top: Consts.topPadding),
            physics: my.prefs.scrollPhysics,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridItemsCount, childAspectRatio: 14 / 9),
            itemCount: favsList.length,
            itemBuilder: (_, index) {
              return GestureDetector(
                onLongPress: () {
                  showMenu(context, favsList[index]);
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(7.5, 0.0, 7.5, 15.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: my.theme.secondaryBackgroundColor.withOpacity(0.5)),
                  child: FavGridItem(key: ValueKey(favsList[index].id), fav: favsList[index]),
                ),
              );
            },
          );
        });
      },
    );
  }
}
