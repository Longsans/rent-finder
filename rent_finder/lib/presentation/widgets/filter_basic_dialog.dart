import 'package:flutter/material.dart';

import '../../constants.dart';

class FilterBasicDialog extends StatelessWidget {
  const FilterBasicDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(defaultPadding * 0.75),
        height: 500,
        width: 800,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: defaultPadding,
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lọc kết quả',
                  style: Theme.of(context)
                      .textTheme
                      .headline6,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/filter_enhance');
                  },
                  child: Text('Nâng cao'),
                ),
              ],
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              'Giá',
              style:
                  Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              'Loại hình',
              style:
                  Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              'Phòng ngủ tối thiểu',
              style:
                  Theme.of(context).textTheme.subtitle1,
            ),
            
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              'Phòng tắm tối thiểu',
              style:
                  Theme.of(context).textTheme.subtitle1,
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Áp dụng'),
              ),
            )
          ],
        ),
      ),
    );
  }
}