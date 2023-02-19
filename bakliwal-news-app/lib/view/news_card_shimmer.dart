import 'package:flutter/material.dart';

import 'package:bakliwal_news_app/style/shimmers_effect.dart';

class NewsCardShimmer extends StatelessWidget {
  const NewsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Card(
        key: UniqueKey(),
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
        ),
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CustomShimmerEffect.circular(height: 30, width: 30),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 15.0),
                child: CustomShimmerEffect.rectangular(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 15.0),
                child: CustomShimmerEffect.rectangular(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 15.0),
                child: CustomShimmerEffect.rectangular(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomShimmerEffect.rectangular(
                  height: 150,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomShimmerEffect.rectangular(
                height: 15,
                width: MediaQuery.of(context).size.width * 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
