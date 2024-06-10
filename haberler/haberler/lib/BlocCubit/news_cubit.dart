import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  final ImagePicker _picker = ImagePicker();

  Future<void> loadNewss() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/mynews.json');
      if (file.existsSync()) {
        final content = await file.readAsString();
        final List<dynamic> jsonData = json.decode(content);
        final mynews = jsonData.map((data) => News.fromJson(data)).toList();
        emit(NewsLoaded(mynews));
      } else {
        emit(NewsLoaded([]));
      }
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> addNews() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/mynews.json');
      final post = News(
        imageUrl: pickedFile.path,
        views: '0',
      );
      final currentState = state;
      if (currentState is NewsLoaded) {
        final updatedNewss = List<News>.from(currentState.mynews)..insert(0, post);
        await file.writeAsString(json.encode(updatedNewss.map((p) => p.toJson()).toList()));
        emit(NewsLoaded(updatedNewss));
      }
    }
  }
}
