import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../BlocCubit/news_cubit.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../language_provider.dart';

class MyNewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit()..loadNewss(),
      child: MyNewsView(),
    );
  }
}

class MyNewsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return Text(languageProvider.isEnglish ? 'My News' : 'Paylaşımlarım');
          },
        ),
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            if (state.mynews.isEmpty) {
              return Center(child: Text(Provider.of<LanguageProvider>(context).isEnglish ? 'No news shared yet.\nYour shared news will be saved here.' : 'Şu ana kadar hiç haber paylaşılmadı.\nPaylaştığınız haberler burada kaydedilir.'));
            }
            return ListView.builder(
              itemCount: state.mynews.length,
              itemBuilder: (context, index) {
                final post = state.mynews[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                      ),
                      Image.file(File(post.imageUrl)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${post.views} views'),
                            IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is NewsError) {
            return Center(child: Text(Provider.of<LanguageProvider>(context).isEnglish ? 'Error: ${state.message}' : 'Hata: ${state.message}'));
          } else {
            return Center(child: Text('Unknown state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<NewsCubit>().addNews(),
        child: Text(Provider.of<LanguageProvider>(context).isEnglish ? 'Share' : 'Paylaş'),
      ),
    );
  }
}
