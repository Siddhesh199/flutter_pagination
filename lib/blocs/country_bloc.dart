import 'package:flutterapppagin/models/country_response.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';

class CountryBloc {
  final _repository = Repository();

  final _countriesFetcher = PublishSubject<List<Country>>();

  Observable<List<Country>> get allCountries => _countriesFetcher.stream;

  int firstIndex = 0;

  List<Country> initialList = [];

  int listLength;

  fetchCountries() async {
    CountryResponse itemModel = await _repository.fetchCountries();
    listLength = itemModel.countries.length;
    initialList = itemModel.countries.sublist(0, 10);
    _countriesFetcher.sink.add(initialList);
    firstIndex = itemModel.countries.sublist(firstIndex, 10).length;
  }

  fetchMoreCountries() async {
    int lastIndex = firstIndex + 80;
    CountryResponse itemModel = await _repository.fetchCountries();
    await Future.delayed(Duration(seconds: 2));
    if (lastIndex <= itemModel.countries.length) {
      initialList =
          initialList + itemModel.countries.sublist(firstIndex, lastIndex);
      _countriesFetcher.sink.add(initialList);
      firstIndex = lastIndex;
    }
  }

  dispose() {
    _countriesFetcher.close();
  }
}

final bloc = CountryBloc();
