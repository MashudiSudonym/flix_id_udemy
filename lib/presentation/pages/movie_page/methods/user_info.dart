import 'package:flix_id/presentation/extensions/int_extension.dart';
import 'package:flix_id/presentation/misc/methods.dart';
import 'package:flix_id/presentation/providers/user_data/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget userInfo(WidgetRef ref) => Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        24,
        24,
        0,
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image:
                      ref.watch(userDataProvider).valueOrNull?.photoUrl != null
                          ? NetworkImage(ref
                              .watch(userDataProvider)
                              .valueOrNull!
                              .photoUrl!) as ImageProvider
                          : const AssetImage(
                              'assets/pp-placeholder.webp',
                            ),
                  fit: BoxFit.cover,
                )),
          ),
          horizontalSpace(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${getGreeting()}, ${ref.watch(userDataProvider).when(
                      data: (user) => user?.name.split(' ').first ?? '',
                      error: (error, stackTrace) => '',
                      loading: () => 'Loading...',
                    )}!',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Let's book your favorite movie!",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              verticalSpace(5),
              GestureDetector(
                onTap: () {
                  // go to wallet page
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Image.asset(
                        'assets/wallet.webp',
                      ),
                    ),
                    horizontalSpace(10),
                    Text(
                      ref.watch(userDataProvider).when(
                            data: (user) =>
                                (user?.balance ?? 0).toIDRCurrencyFormat(),
                            error: (error, stackTrace) =>
                                0.toIDRCurrencyFormat(),
                            loading: () => 'Loading...',
                          ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

String getGreeting() {
  var hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 18) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}