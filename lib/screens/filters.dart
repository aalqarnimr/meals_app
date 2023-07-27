import 'package:flutter/material.dart';
import 'package:meals_app/screens/tabs.dart';
import 'package:meals_app/widgets/filter_item.dart';
import 'package:meals_app/widgets/main_drawer.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key, required this.choosenFilters});
  final Map<Filter, bool> choosenFilters;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFreeFilterSet = false;
  var _lactoseFreeFilterSet = false;
  var _vegetarianFilterSet = false;
  var _veganFilterSet = false;
  @override
  void initState() {
    _glutenFreeFilterSet = widget.choosenFilters[Filter.glutenFree]!;
    _lactoseFreeFilterSet = widget.choosenFilters[Filter.lactoseFree]!;
    _vegetarianFilterSet = widget.choosenFilters[Filter.vegetarian]!;
    _veganFilterSet = widget.choosenFilters[Filter.vegan]!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MainDrawer(
      //   onSelectScreen: ((identifier) {
      //     Navigator.pop(context);
      //     if (identifier == 'meals') {
      //       //Navigator.pop(context);
      //       Navigator.pushReplacement(context,
      //           MaterialPageRoute(builder: (ctx) => const TabsScreen()));
      //     }
      //   }),
      // ),
      appBar: AppBar(
        title: const Text('Your filters'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop({
            Filter.glutenFree: _glutenFreeFilterSet,
            Filter.lactoseFree: _lactoseFreeFilterSet,
            Filter.vegetarian: _vegetarianFilterSet,
            Filter.vegan: _veganFilterSet,
          });
          return false;
        },
        child: Column(
          children: [
            FilterItem(
                title: 'Gluten-free',
                subtitle: 'Only include Gluten-free meals.',
                filterSet: _glutenFreeFilterSet,
                onChecked: (isChecked) {
                  setState(() {
                    _glutenFreeFilterSet = isChecked;
                  });
                }),
            FilterItem(
                title: 'Lactose-free',
                subtitle: 'Only include Lactose-free meals.',
                filterSet: _lactoseFreeFilterSet,
                onChecked: (isChecked) {
                  setState(() {
                    _lactoseFreeFilterSet = isChecked;
                  });
                }),
            FilterItem(
                title: 'Vegetarian',
                subtitle: 'Only include Vegetarian meals.',
                filterSet: _vegetarianFilterSet,
                onChecked: (isChecked) {
                  setState(() {
                    _vegetarianFilterSet = isChecked;
                  });
                }),
            FilterItem(
                title: 'Vegan',
                subtitle: 'Only include Vegan meals.',
                filterSet: _veganFilterSet,
                onChecked: (isChecked) {
                  setState(() {
                    _veganFilterSet = isChecked;
                  });
                })
          ],
        ),
      ),
    );
  }
}
