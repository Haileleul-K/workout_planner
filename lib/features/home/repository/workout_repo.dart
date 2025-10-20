import 'dart:convert';
import '../models/workout_model.dart';

//A repo for workout data
class WorkoutRepository {


  Future<WorkoutModel> getWorkout() async {

    final jsonData = _getWorkoutJsonData();
    return WorkoutModel.fromJson(jsonData);
  }

  /// Mock JSON data
  Map<String, dynamic> _getWorkoutJsonData() {
    const jsonString = '''
    {
       "workout_name":"Chris' Full Body 1",
       "exercises":[
          {
             "name":"Squat",
             "asset_url":"https://jyfpzydnxyelsxofxcnz.supabase.co/storage/v1/object/public/exercise_gifs/1080/143513.png",
             "gif_asset_url":"https://jyfpzydnxyelsxofxcnz.supabase.co/storage/v1/object/public/exercise_gifs/1080/143513.gif",
             "equipment":"barbell"
          },
          {
             "name":"Inclined Bench Press",
             "asset_url":"https://jyfpzydnxyelsxofxcnz.supabase.co/storage/v1/object/public/exercise_gifs/1080/031413.png",
             "gif_asset_url":"https://jyfpzydnxyelsxofxcnz.supabase.co/storage/v1/object/public/exercise_gifs/1080/031413.gif",
             "equipment":"barbell"
          },
          {
             "name":"Pull Ups",
             "asset_url":"https://jyfpzydnxyelsxofxcnz.supabase.co/storage/v1/object/public/exercise_gifs/1080/142913.png",
             "gif_asset_url":"https://jyfpzydnxyelsxofxcnz.supabase.co/storage/v1/object/public/exercise_gifs/1080/142913.gif",
             "equipment":"bodyweight"
          },
          {
             "name":"Shoulder Press",
             "asset_url":"https://jyfpzydnxyelsxofxcnz.supabase.co/storage/v1/object/public/exercise_gifs/1080/040513.png",
             "gif_asset_url":"https://jyfpzydnxyelsxofxcnz.supabase.co/storage/v1/object/public/exercise_gifs/1080/040513.gif",
             "equipment":"dumbbell"
          },
          {
             "name":"Curl Biceps",
             "asset_url":"https://jyfpzydnxyelsxofxcnz.supabase.co/storage/v1/object/public/exercise_gifs/1080/016513.png",
             "gif_asset_url":"https://jyfpzydnxyelsxofxcnz.supabase.co/storage/v1/object/public/exercise_gifs/1080/016513.gif",
             "equipment":"cable"
          },
          {
             "name":"Extension Triceps",
             "asset_url":"https://jyfpzydnxyelsxofxcnz.supabase.co/storage/v1/object/public/exercise_gifs/1080/020013.png",
             "gif_asset_url":"https://jyfpzydnxyelsxofxcnz.supabase.co/storage/v1/object/public/exercise_gifs/1080/020013.gif",
             "equipment":"cable"
          }
       ]
    }
    ''';

    return json.decode(jsonString) as Map<String, dynamic>;
  }
}

