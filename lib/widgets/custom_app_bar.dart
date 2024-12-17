import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRefresh;
  final AnimationController refreshController;

  const CustomAppBar({
    Key? key,
    required this.onRefresh,
    required this.refreshController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade400,
              Colors.teal.shade800,
            ],
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Hero(
          tag: 'app_icon',
          child: Material(
            elevation: 2,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.emoji_emotions,
                color: Colors.teal.shade800,
                size: 24,
              ),
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          const Text(
            'Jokes',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'App',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
      actions: [
        AnimatedBuilder(
          animation: refreshController,
          builder: (context, child) {
            return IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 28,
              ),
              onPressed: onRefresh,
              tooltip: 'Refresh Jokes',
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          height: 4,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4.0);
}
