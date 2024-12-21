import 'package:flutter/material.dart';
import '../constans.dart';
import 'depanpage.dart';
import 'kategoripage.dart';


class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _activeTabIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_setActiveTabIndex);
  }

  void _setActiveTabIndex() {
    _activeTabIndex = _tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            onTap: () {},
            readOnly: true,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Palette.orange),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                fillColor: const Color(0xfff3f3f4),
                filled: true),
          ),
          backgroundColor: Palette.bg1,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Palette.orange,
            labelColor: Palette.orange,
            unselectedLabelColor: Colors.grey,
            labelPadding: const EdgeInsets.all(0),
            tabs: const [
              Tab(text: 'Beranda'),
              Tab(text: 'Kategori'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            DepanPage(),
            KategoriPage(),
          ],
        ));
  }
}
