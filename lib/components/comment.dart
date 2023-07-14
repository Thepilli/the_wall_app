import 'package:flutter/material.dart';
import 'package:the_wall_social_app/components/sized_box.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Comment(
      {super.key, required this.text, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //comment
          Text(text),
          const MySizedBox10(),
          //user, time
          Row(
            children: [
              Text(user,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary)),
              Text(' . ',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary)),
              Text(time,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary)),
            ],
          )
        ],
      ),
    );
  }
}
