import 'package:flutter/material.dart';

/// Hält die State der Kinder beim Tabwechsel am Leben
class NavKeepAlive extends StatefulWidget {
  final Widget child;
  
  const NavKeepAlive({super.key, required this.child});

  @override
  State<NavKeepAlive> createState() => _NavKeepAliveState();
}

class _NavKeepAliveState extends State<NavKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}