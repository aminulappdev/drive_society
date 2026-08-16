import 'package:flutter/material.dart';

class MarketPlaceWidget extends StatefulWidget {
  final String name;
  final String price;
  final String date;
  final String imageUrl;
  final double? height;
  final double? width;
  final VoidCallback onTap;

  final Widget? taggle;

  const MarketPlaceWidget({
    super.key,
    required this.name,
    required this.price,
    required this.date,
    required this.imageUrl,
    required this.onTap,
    this.width = 180,
    this.height = 250,
    this.taggle,
  });

  @override
  State<MarketPlaceWidget> createState() => _MarketPlaceWidgetState();
}

class _MarketPlaceWidgetState extends State<MarketPlaceWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.imageUrl,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Text content overlay
            // Container(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 8,
            //     vertical: 4,
            //   ),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.only(
            //       topRight: Radius.circular(8),
            //       topLeft: Radius.circular(8),
            //       bottomRight: Radius.circular(8),
            //     ),
            //     color: AppColors.darkRed,
            //   ),
            //   child: Text(
            //     'For Sale',
            //     style: h7.copyWith(
            //       color: AppColors.white,
            //     ),
            //   ),
            // ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.price,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.taggle == null
                            ? Container()
                            : Row(
                                children: [
                                  Text(
                                    'Sale on Market Place',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  widget.taggle ?? Container(),
                                ],
                              ),
                        SizedBox(height: 4),
                        Text(
                          widget.date,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
