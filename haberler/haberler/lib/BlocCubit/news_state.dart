part of 'news_cubit.dart';

class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News> mynews;

  NewsLoaded(this.mynews);
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}

class News {
  final String imageUrl;
  final String views;

  News({required this.imageUrl, required this.views});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      imageUrl: json['imageUrl'],
      views: json['views'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'views': views,
    };
  }
}
