import 'package:flutter/material.dart';
import 'package:flutterapppagin/models/country_response.dart';
import '../blocs/country_bloc.dart';

class CountryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CountryListState();
  }
}

class CountryListState extends State<CountryList> {
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc.fetchCountries();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        print('Reached End');
        bloc.fetchMoreCountries();
      }
    });
  }

  Widget _buildSuggestions() {
    return StreamBuilder(
      stream: bloc.allCountries,
      builder: (context, AsyncSnapshot<List<Country>> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BLOC Architechture',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget buildList(AsyncSnapshot<List<Country>> snapshot) {
    return GridView.builder(
        controller: _controller,
        itemCount: snapshot.data.length + 1,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          if (index == bloc.listLength) {
            return Container();
          } else if (index == snapshot.data.length) {
            return CircularProgressIndicator();
          } else {
            print('LENGTH: ${snapshot.data.length}');
            return getStructuredGridCell(snapshot.data[index]);
          }
        });
  }

  Card getStructuredGridCell(Country country) {
    return Card(
        elevation: 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
//            SvgPicture.network(
//              country.flag.replaceAll('https', 'http'),
//              height: 130.0,
//              width: 100.0,
//              placeholderBuilder: (BuildContext context) => Container(
//                child: CircularProgressIndicator(),
//                padding: EdgeInsets.all(70),
//              ),
//            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(country.name),
            )
          ],
        ));
  }
}
