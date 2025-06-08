import 'package:flutter/material.dart';
import 'package:sweet_delights/core/color.dart';
import 'package:sweet_delights/data/category.dart';
import 'package:sweet_delights/page/details_page.dart';
import 'package:sweet_delights/page/favorites_page.dart';
import 'package:sweet_delights/page/cart_page.dart';
import 'package:sweet_delights/page/profile_page.dart';
import 'package:sweet_delights/widget/Category_btn.dart';
import 'package:sweet_delights/widget/item_card.dart';
import 'package:sweet_delights/widget/item_list_card.dart';
import 'package:provider/provider.dart';
import 'package:sweet_delights/providers/favorites_provider.dart';
import 'package:sweet_delights/providers/cart_provider.dart';
import 'package:sweet_delights/providers/cake_provider.dart';
import 'package:sweet_delights/models/cake_model.dart';
import 'manage_cakes_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  bool isGridView = true;
  int selectCategory = 0;
  List<CakeModel> filteredCakes = [];

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CakeProvider>(context, listen: false);
      provider.fetchCakes().then((_) {
        setState(() {
          filteredCakes = provider.cakes;
        });
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      FavoritesPage(),
      CartPage(),
      ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(child: pages[_selectedTabIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) => setState(() => _selectedTabIndex = index),
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Consumer<FavoritesProvider>(
              builder: (_, provider, __) => Stack(
                children: [
                  Icon(Icons.favorite),
                  if (provider.favorites.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: mainColor,
                        child: Text(
                          provider.favorites.length.toString(),
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (_, provider, __) => Stack(
                children: [
                  Icon(Icons.shopping_cart),
                  if (provider.items.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: mainColor,
                        child: Text(
                          provider.itemCount.toString(),
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: mainColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ManageCakesPage()),
          );
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    return Consumer<CakeProvider>(
      builder: (context, cakeProvider, child) {
        final cakes = isSearching
            ? filteredCakes
            : getFilteredCakes(categories[selectCategory].tag, cakeProvider.cakes);

        return Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isSearching) ...[
                            Text('Find your',
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.black54)),
                            Text('Sweet Delights',
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: mainColor)),
                          ],
                          SizedBox(height: 20),
                          _buildSearchBar(),
                          SizedBox(height: 20),
                          _buildCategories(cakeProvider),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: isGridView ? _buildGridView(cakes) : _buildListView(cakes),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = 3),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: accent2,
              child: ClipOval(
                child: Image.asset('assets/10.jpg', fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          final provider = Provider.of<CakeProvider>(context, listen: false);
          setState(() {
            isSearching = value.isNotEmpty;
            filteredCakes = provider.cakes.where((cake) {
              return cake.name.toLowerCase().contains(value.toLowerCase()) ||
                     cake.flavour.toLowerCase().contains(value.toLowerCase());
            }).toList();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search cakes...',
          prefixIcon: Icon(Icons.search, color: mainColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCategories(CakeProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: CategoryButton(
                      category: categories[index],
                      selectedIndex: selectCategory,
                      index: index,
                      onTap: () {
                        setState(() {
                          selectCategory = index;
                          if (!isSearching) {
                            filteredCakes = getFilteredCakes(
                              categories[index].tag,
                              provider.cakes,
                            ).cast<CakeModel>();
                          }
                          _animationController.reset();
                          _animationController.forward();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: IconButton(
              icon: Icon(
                isGridView ? Icons.view_list : Icons.grid_view,
                color: mainColor,
              ),
              tooltip: isGridView ? 'Switch to List View' : 'Switch to Grid View',
              onPressed: () {
                setState(() {
                  isGridView = !isGridView;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<CakeModel> cakes) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cakes.length,
      itemBuilder: (context, index) {
        return Hero(
          tag: 'cake_${cakes[index].id}',
          child: ItemCard(
            cake: cakes[index],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPage(cake: cakes[index]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(List<CakeModel> cakes) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: cakes.length,
      itemBuilder: (context, index) {
        return Hero(
          tag: 'cake_list_${cakes[index].id}',
          child: ItemListCard(
            cake: cakes[index],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPage(cake: cakes[index]),
              ),
            ),
          ),
        );
      },
    );
  }
}

