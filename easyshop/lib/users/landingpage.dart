import 'package:flutter/material.dart';
import '../constans.dart';
import 'akunpage.dart';
import 'beranda.dart';
import 'favoritepage.dart';
import 'keranjangpage.dart';
import 'transaksipage.dart';

class LandingPage extends StatefulWidget {
  final String nav;
  const LandingPage({super.key, this.nav = '0'});


  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _bottomNavCurrentIndex = 0;
  final List<Widget> _container = [
    const BerandaPage(),
    const FavoritePage(),
    const KeranjangPage(),
    const TransaksiPage(),
    const AkunPage()
  ];

  @override
  void initState() {
    super.initState();
    if (widget.nav == "2"){
      _bottomNavCurrentIndex = 2;
    }
  }
  @override
  void dispose(){
    _bottomNavCurrentIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _container[_bottomNavCurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Palette.bg1,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _bottomNavCurrentIndex = index;
          });
        },
        currentIndex: _bottomNavCurrentIndex,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home,
              color: Palette.bg1,
            ),
            icon: const Icon(
              Icons.home,
              color: Colors.grey,
          ), //Icon
          label: 'Beranda',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.favorite,
              color: Palette.bg1,
            ),
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.grey,
          ), //Icon
          label: 'Favorite',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.shopping_cart,
              color: Palette.bg1,
            ),
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.grey,
          ), //Icon
          label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.swap_horiz_sharp,
              color: Palette.bg1,
            ),
            icon: const Icon(
              Icons.swap_horiz_sharp,
              color: Colors.grey,
          ), //Icon
          label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.person,
              color: Palette.bg1,
            ),
            icon: const Icon(
              Icons.person_outline,
              color: Colors.grey,
          ), //Icon
          label: 'Profile',
          ),
        ],
      ),
    );
  }
}
