import 'package:flutter/material.dart';

class AiStatic extends StatelessWidget {
  const AiStatic({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 12,
            child: Transform.rotate(
              angle: -0.09, // sağa doğru hafif eğim
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8), // köşeleri yuvarlak
                child: Image.network(
                  'https://cdn.prod.website-files.com/655741af3f04e006606d26ad/6948068c4acb623675bfffa8_66d6e38ee376471e864473ca_Frame%25201698755911.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Arka kart (Valorant)
          Positioned(
            bottom: 4,
            left: 0,
            child: Transform.rotate(
              angle: -0.24, // sola doğru hafif eğim
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8), // köşeleri yuvarlak
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSflZmFVnYx7hIcHH61oXQjFj2JYzIXWFlDRw&s',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Ön kart (CS:GO skin)
        ],
      ),
    );
  }
}
