import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselAds extends StatefulWidget {
  const CarouselAds({super.key});

  @override
  State<CarouselAds> createState() => _CarouselAdsState();
}

class _CarouselAdsState extends State<CarouselAds> {
  int activeIndex = 0;

  final List<Map<String, String>> items = [
    {'text': 'Now you can request time-off directly from the app!'},
    {'text': 'New: Performance reviews available on mobile.'},
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: items.map((item) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.red.shade800,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Text(
                            item['text']!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          margin: const EdgeInsets.only(left: 12, bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.amber.shade900,
                          ),
                          child: const Text(
                            'Learn more',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/attendance_2.png',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ],
              ),

              // 🔹 DOT DI TENGAH BAWAH
              Positioned(
                bottom: 6,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: items.asMap().entries.map((entry) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeIndex == entry.key
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 120,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          setState(() {
            activeIndex = index;
          });
        },
      ),
    );
  }
}
