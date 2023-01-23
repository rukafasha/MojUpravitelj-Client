import 'package:flutter/material.dart';
import 'package:praksa_frontend/Helper/DemoValues.dart';
import 'package:praksa_frontend/ui/background/backgroundTop.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var body;
    return Scaffold(
        appBar: AppBar(
        title: Text("ZEV Centar"),
        ),
           body: Container(
              child :ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                return const PostCard();
              //BackgroundTop(),
                }
              ) 
            )

      );

  }
}
class PostCard extends StatelessWidget {
  const PostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6 / 3,
      child: Card(
        elevation: 2,
        child: Container(
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: const <Widget>[
              _Post(),
              Divider(color: Colors.grey),
              _PostDetails(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Post extends StatelessWidget {
  const _Post({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(children: const <Widget>[ _PostTitleAndSummary()]),
    );
  }
}



class _PostTitleAndSummary extends StatelessWidget {
  const _PostTitleAndSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleTheme = Theme.of(context).textTheme.headline6;
    final TextStyle? summaryTheme = Theme.of(context).textTheme.bodyText2;
    final String title = DemoValues.title;
    final String summary = DemoValues.Description;

    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(title, style: titleTheme),
            const SizedBox(height: 2.0),
            Text(summary, style: summaryTheme),
          ],
        ),
      ),
    );
  }
}

class _PostDetails extends StatelessWidget {
  const _PostDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _UserNameAndEmail(),
        _PostTimeStamp(),
      ],
    );
  }
}

class _UserNameAndEmail extends StatelessWidget {
  const _UserNameAndEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? nameTheme = Theme.of(context).textTheme.subtitle1;

    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(DemoValues.userName, style: nameTheme),
            const SizedBox(height: 2.0),
          ],
        ),
      ),
    );
  }
}

class _PostTimeStamp extends StatelessWidget {
  const _PostTimeStamp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? timeTheme = Theme.of(context).textTheme.caption;
    return Expanded(
      flex: 2,
      child: Text(DemoValues.timeCreated, style: timeTheme),
    );
  }
}