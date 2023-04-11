import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fire3/repository/firestore_repository.dart';
import '../../models/task.dart';
import '../bloc_exports.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<GetAllTasks>(_getAllTasks);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnfavoriteTask>(_onMarkFavoriteOrUnfavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTasks>(_onDeleteAllTask);
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    await FirestoreRepository.createTask(task: event.task);
  }

  void _getAllTasks(GetAllTasks event, Emitter<TasksState> emit) async {
    List<Task> pendingTasks = [];
    List<Task> completedTasks = [];
    List<Task> favoriteTasks = [];
    List<Task> removedTasks = [];
    final data = await FirestoreRepository.getAllTasks().then((value) {
      value.forEach((task) {
        if (task.isDeleted == true) {
          removedTasks.add(task);
        } else {
          if (task.isDone == true) {
            completedTasks.add(task);
          }
          if (task.isFavorite == true) {
            favoriteTasks.add(task);
          } else {
            pendingTasks.add(task);
          }
        }
      });
    });
    emit(TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: removedTasks,
    ));
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    if (event.task.isDone == false) {
      final updatedTask = Task(
          title: event.task.title,
          description: event.task.description,
          id: event.task.id,
          date: event.task.date,
          isDone: true);
      await FirestoreRepository.update(task: updatedTask);
    } else {
      final updatedTask = Task(
          title: event.task.title,
          description: event.task.description,
          id: event.task.id,
          date: event.task.date,
          isDone: false);
      await FirestoreRepository.update(task: updatedTask);
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    final Task deletedTask = event.task;
    FirestoreRepository.delete(task: deletedTask);
  }

  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) async {
    final Task deletedTask = event.task.copyWith(isDeleted: true);
    await FirestoreRepository.update(task: deletedTask);
    state.removedTasks.add(deletedTask);
  }

  void _onMarkFavoriteOrUnfavoriteTask(
      MarkFavoriteOrUnfavoriteTask event, Emitter<TasksState> emit) async {
    if (event.task.isFavorite == false) {
      final Task favTask = event.task.copyWith(isFavorite: true);
      await FirestoreRepository.update(task: favTask);
    } else {
      final Task favTask = event.task.copyWith(isFavorite: false);
      await FirestoreRepository.update(task: favTask);
    }
  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) async {
    final Task editedTask = event.newTask
        .copyWith(isDone: false, isDeleted: false, isFavorite: false);
    await FirestoreRepository.update(task: editedTask);
  }

  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) async {
    final Task restoredTask =
        event.task.copyWith(isDeleted: false, isDone: false, isFavorite: false);
    await FirestoreRepository.update(task: restoredTask);
    state.pendingTasks.add(restoredTask);
  }

  void _onDeleteAllTask(DeleteAllTasks event, Emitter<TasksState> emit) async {
    await FirestoreRepository.deleteAll(taskList: state.removedTasks);
  }
}
