import 'package:flutter/material.dart';

class MyListTyle extends StatelessWidget {
  final String leading;
  final String  title;
  final Function() action;

  MyListTyle({
    this.leading,
    @required this.title,
    this.action
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: Colors.black.withOpacity(0.4),
              height: 1,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlign,
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 30,
                  child: CircleAvatar(
                    radius: 20,
                    child: Text(leading),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    child: Text(title),
                  ),
                ),
                Container(
                  width: 30,
                  child: Icon(Icons.chevron_right),
                )
              ],
            ),
            // Divider(
            //   color: Colors.black.withOpacity(0.4), 
            //   height: 1,
            // ),
          ],
        ),
        // title: Text('Liste categories'),
        // onTap: () => Navigator.of(context).pushNamed(Routes.LISTE_CATEGORIE),
      ),
    );
  }
}