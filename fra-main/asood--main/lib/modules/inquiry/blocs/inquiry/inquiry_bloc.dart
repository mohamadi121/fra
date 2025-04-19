// ignore_for_file: avoid_print

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../models/inquiry_card_model.dart';
import '../../../../repositories/inquiry_repository.dart';
import '../../../../services/api_status.dart';

part 'inquiry_event.dart';
part 'inquiry_state.dart';

class InquiryBloc extends Bloc<InquiryEvent, InquiryState> {
  InquiryBloc() : super(InquiryState.initial()) {
    on<InquirySubmit>(_inquirySubmit);
    on<InquiryTypeSwitch>(_inquiryTypeSwitch);
    on<InquiryAddImage>(_inquiryAddImage);
    on<InquiryRemoveImage>(_inquiryRemoveImage);
  }
  final InquiryRepo repo = InquiryRepo();

  _inquirySubmit(InquirySubmit event, Emitter<InquiryState> emit) async {
    emit(state.copyWith(status: InquiryStatus.loading));
    try {
      var res = await repo.submitInquiry(
        event.inquiryType,
        event.inquiryTitle,
        event.inquiryDescription,
        event.inquiryDetails,
        event.inquiryCategory,
        event.inquiryAmount,
        event.inquiryUnit,
        event.inquiryName,
        event.inquiryImages,
      );
      if (res is Success) {
        emit(state.copyWith(status: InquiryStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: InquiryStatus.failure));
    }
  }

  _inquiryTypeSwitch(
      InquiryTypeSwitch event, Emitter<InquiryState> emit) async {
    emit(state.copyWith(inquiryType: event.inquiryType));
    print('inquiry type switch: ${state.inquiryType}');
  }

  _inquiryAddImage(InquiryAddImage event, Emitter<InquiryState> emit) async {
    final inquiryImages = List<File>.from(state.inquiryImages)
      ..add(event.image);

    emit(state.copyWith(inquiryImages: inquiryImages));
  }

  _inquiryRemoveImage(
      InquiryRemoveImage event, Emitter<InquiryState> emit) async {
    final inquiryImages = List<File>.from(state.inquiryImages)
      ..removeAt(event.index);

    emit(state.copyWith(inquiryImages: inquiryImages));
  }
}
