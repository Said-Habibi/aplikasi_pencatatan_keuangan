import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_theme.dart';
import '../utils/notification_helper.dart';
import '../utils/weather_helper.dart';
import '../utils/currency_formatter.dart';
import '../widgets/filter_chip_row.dart';
import '../widgets/summary_header.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/income_expense_chart.dart';
import 'notification_screen.dart';
import 'all_transactions_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: CylinderHeaderDelegate(
                  provider: provider,
                  topPadding: MediaQuery.of(context).padding.top,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EntranceAnimation(delay: 100, child: FilterChipRow(provider: provider)),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SizeTransition(sizeFactor: animation, child: child),
                          );
                        },
                        child: (provider.weatherEnabled && provider.weatherData != null)
                            ? Column(
                                key: const ValueKey('weather_card'),
                                children: [
                                  _buildWeatherCard(provider.weatherData!, provider.weatherLocation),
                                  const SizedBox(height: 16),
                                ],
                              )
                            : const SizedBox.shrink(key: ValueKey('no_weather')),
                      ),
                      EntranceAnimation(delay: 200, child: IncomeExpenseChart(provider: provider)),
                      const SizedBox(height: 20),
                      EntranceAnimation(delay: 300, child: _buildRecentTransactions(context, provider)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context, TransactionProvider provider) {
    final txs = provider.recentTransactions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Transaksi Terakhir',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AllTransactionsScreen()),
              ),
              child: Text('Lihat Semua', style: TextStyle(color: AppTheme.primaryLight, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (txs.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text('Belum ada transaksi',
                  style: TextStyle(color: Colors.white.withOpacity(0.4))),
            ),
          )
        else
          ...txs.map((tx) => TransactionTile(
                transaction: tx,
                onDelete: () => provider.deleteTransaction(tx.id),
              )),
      ],
    );
  }

  Widget _buildNotificationBell(BuildContext context, TransactionProvider provider) {
    final notifications = NotificationHelper.generate(provider);
    final count = notifications.length;
    return IconButton(
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count', style: const TextStyle(fontSize: 10)),
        backgroundColor: AppTheme.expense,
        child: const Icon(Icons.notifications_outlined, color: Colors.white),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotificationScreen()),
      ),
    );
  }

  Widget _buildWeatherCard(WeatherData weather, String location) {
    return EntranceAnimation(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primary.withOpacity(0.8), AppTheme.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(weather.iconData, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cuaca di $location',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '${weather.tempC.toStringAsFixed(0)}°C - ${weather.condition}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (weather.precipMM > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.umbrella_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('Hujan', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CylinderHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TransactionProvider provider;
  final double topPadding;

  CylinderHeaderDelegate({required this.provider, required this.topPadding});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double maxHeaderHeight = 280;
    final double minHeaderHeight = topPadding + 60;
    final double progress = (shrinkOffset / (maxHeaderHeight - minHeaderHeight)).clamp(0.0, 1.0);
    final double expandedOpacity = (1.0 - progress * 2).clamp(0.0, 1.0);
    
    final Color backgroundColor = Color.lerp(AppTheme.primary, AppTheme.background, progress)!;
    final double pillProgress = (progress - 0.6).clamp(0.0, 0.4) * (1 / 0.4);
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40 * progress),
          bottomRight: Radius.circular(40 * progress),
        ),
        boxShadow: progress > 0.9 ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ] : [],
      ),
      child: Stack(
        children: [
          // Background content (SummaryHeader)
          Opacity(
            opacity: expandedOpacity,
            child: SummaryHeader(provider: provider),
          ),

          // The "Dynamic Island" Camera Wrapper (Half-circle/Pill)
          Align(
            alignment: Alignment.topCenter,
            child: Opacity(
              opacity: pillProgress, 
              child: Transform.translate(
                offset: Offset(0, -10 * (1 - pillProgress)),
                child: Container(
                  width: 140 - (40 * (1 - pillProgress)), // Shrinks to wrap camera
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      CurrencyFormatter.format(provider.balance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Notification Bell
          Positioned(
            top: topPadding + 6,
            right: 15,
            child: IconButton(
              icon: Icon(
                Icons.notifications_none_rounded, 
                color: progress > 0.8 ? AppTheme.primary : Colors.white, 
                size: 22
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 280;

  @override
  double get minExtent => topPadding + 60;

  @override
  bool shouldRebuild(covariant CylinderHeaderDelegate oldDelegate) {
    return oldDelegate.provider != provider || oldDelegate.topPadding != topPadding;
  }
}

class EntranceAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const EntranceAnimation({super.key, required this.child, this.delay = 0});

  @override
  State<EntranceAnimation> createState() => _EntranceAnimationState();
}

class _EntranceAnimationState extends State<EntranceAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offset = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}
