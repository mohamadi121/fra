// ignore_for_file: unnecessary_type_check

import 'package:asood/models/market_model.dart';
import 'package:asood/services/api_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../models/customer_request_model.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc() : super(CustomerState.initial()) {
    on<GetCusomerRequest>(_onGetCusomerRequest);
    on<GetCusomerOrders>(_onGetCusomerOrders);
    on<GetCusomerStors>(_onGetCusomerStors);
    on<TrackPayment>(_onTrackPayment);
    on<AcceptPayment>(_onAcceptPayment);
  }

  void _onGetCusomerRequest(
      GetCusomerRequest event, Emitter<CustomerState> emit) {
    emit(state.copyWith(status: Status.loading));
    try {
      final res = Success();
      if (res is Success) {
        emit(state.copyWith(status: Status.success));
      } else {}
    } catch (e) {
      emit(state.copyWith(status: Status.failure));
    }
  }

  void _onGetCusomerOrders(
      GetCusomerOrders event, Emitter<CustomerState> emit) {
    emit(state.copyWith(status: Status.loading));
    try {
      final res = Success();
      if (res is Success) {
        emit(state.copyWith(status: Status.success));
      } else {}
    } catch (e) {
      emit(state.copyWith(status: Status.failure));
    }
  }

  void _onGetCusomerStors(GetCusomerStors event, Emitter<CustomerState> emit) {
    emit(state.copyWith(status: Status.loading));
    try {
      final res = Success();
      if (res is Success) {
        emit(state.copyWith(status: Status.success));
      } else {}
    } catch (e) {
      emit(state.copyWith(status: Status.failure));
    }
  }

  void _onTrackPayment(TrackPayment event, Emitter<CustomerState> emit) {
    emit(state.copyWith(status: Status.loading));
    try {
      final res = Success();
      if (res is Success) {
        emit(state.copyWith(status: Status.success));
      } else {}
    } catch (e) {
      emit(state.copyWith(status: Status.failure));
    }
  }

  void _onAcceptPayment(AcceptPayment event, Emitter<CustomerState> emit) {
    emit(state.copyWith(status: Status.loading));
    try {
      final res = Success();
      if (res is Success) {
        emit(state.copyWith(status: Status.success));
      } else {}
    } catch (e) {
      emit(state.copyWith(status: Status.failure));
    }
  }
}
