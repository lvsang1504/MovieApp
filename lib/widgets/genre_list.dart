import 'package:flutter/material.dart';
import 'package:flutter_movie_app/bloc/get_movies_by_genre_bloc.dart';
import 'package:flutter_movie_app/model/genre.dart';
import 'package:flutter_movie_app/style/theme.dart' as Style;
import 'package:flutter_movie_app/widgets/genre_movies.dart';

class GenreList extends StatefulWidget {
  final List<Genre> genres;

  const GenreList({Key key, this.genres}) : super(key: key);
  @override
  _GenreListState createState() => _GenreListState(genres);
}

class _GenreListState extends State<GenreList>
    with SingleTickerProviderStateMixin {
  final List<Genre> genres;
  TabController _tabController;

  _GenreListState(this.genres);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: genres.length);
    _tabController.addListener(() { 
      if(_tabController.indexIsChanging) {
        moviesByGenreBloc..drainStream();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 307.0,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          backgroundColor: Style.Colors.mainColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              backgroundColor: Style.Colors.mainColor,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Style.Colors.secondColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3.0,
                unselectedLabelColor: Style.Colors.titleColor,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: genres.map((Genre genre) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: Text(
                      genre.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: genres.map((Genre genre) {
              return GenreMovies(genreId: genre.id,);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
