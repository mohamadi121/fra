import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../../models/product_model.dart';
import '../../../../repositories/product_repository.dart';
import '../../../../services/api_status.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {

  AddProductBloc() : super(AddProductState.initial()){
    on<AddProductEvent>((event, emit) {});

    on<ProductTypeEvent>(_changeProductType);
    on<IsMarketerEvent>(_changeMarketerType);
    on<ProductPriceStockEvent>(_changeProductPriceStockExtra);
    on<DiscountTypeEvent>(_changeDiscountType);
    on<ProductExtraEvent>(_changeProductExtra);
    on<ProductTagSaleEvent>(_changeProductTgSale);

    on<AddNewProductEvent>(_addNewProduct);

  }

  _changeProductType(ProductTypeEvent event, Emitter<AddProductState> emit) {
    emit(state.copyWith(productType: event.type));
  }

  _changeMarketerType(IsMarketerEvent event, Emitter<AddProductState> emit) {
    emit(state.copyWith(isMarketer: event.isMarketer));
  }

  _changeProductPriceStockExtra(ProductPriceStockEvent event, Emitter<AddProductState> emit) {
    emit(state.copyWith(
        productStock: event.stock,
        productPrice: event.price
    ));
  }

  _changeDiscountType(DiscountTypeEvent event, Emitter<AddProductState> emit) {
    emit(state.copyWith(discountType: event.type));
  }

  _changeProductExtra(ProductExtraEvent event, Emitter<AddProductState> emit) {
    emit(state.copyWith(
      productGift: event.gift,
      productExtra: event.extra
    ));
  }

  _changeProductTgSale(ProductTagSaleEvent event, Emitter<AddProductState> emit) {
    emit(state.copyWith(
      productTag: event.tag,
      productPosition: event.position,
      productSaleType: event.saleType,
      productSalePrice: event.sendPrice,
    ));
  }

  _addNewProduct(AddNewProductEvent event, Emitter<AddProductState> emit) async{
    emit(state.copyWith(status: AddProductStatus.loading));
    ProductModel product = ProductModel(
      market: event.market,
      name: event.name,
      description: event.description,
      technicalDetail: event.technicalDetail,
      stock: event.stock,
      price: event.price,
      requiredProduct: event.requiredProduct,
      giftProduct: event.giftProduct,
      isMarketer: event.isMarketer,
      sellType: event.sellType,
      shipCost: event.shipCost,
      shipCostPayType: event.shipCostPayType,
    );

    try {
      var res = await ProductRepository().createProduct(
        product,
      );
      if (res is Success) {
        // var json = jsonDecode(res.response.toString());
        emit(state.copyWith(
          productSalePrice: '',
          productSaleType: '',
          productExtra: false,
          productType: false,
          discountType: -1,
          isMarketer: false,
          productGift: false,
          productPrice: false,
          productPosition: '',
          productTag: '',
          productStock: false,
          status: AddProductStatus.success
        ));
      } else {
        emit(state.copyWith(
          status: AddProductStatus.failure,
        ));
        if (kDebugMode) {
          print('add product error is ${res.error.toString()}');
        }
      }
    } catch (e) {
      emit(state.copyWith(
        status: AddProductStatus.failure,
      ));
      if (kDebugMode) {
        print('add product error is $e');
      }
    }
    emit(state.copyWith(
      status: AddProductStatus.initial,
    ));
  }

}
