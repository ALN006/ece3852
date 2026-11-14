// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtest_dot_product_combinational.h for the primary calling header

#include "Vtest_dot_product_combinational__pch.h"

void Vtest_dot_product_combinational___024root___ctor_var_reset(Vtest_dot_product_combinational___024root* vlSelf);

void Vtest_dot_product_combinational___024root__ctor(Vtest_dot_product_combinational___024root* vlSelf, Vtest_dot_product_combinational__Syms* symsp, const char* namep) {
    vlSelf->vlSymsp = symsp;
    vlSelf->vlNamep = strdup(namep);
    // Construct members
    VL_INPLACE_CONSTRUCT(vlSelf->__Vnontrivs.__VdlySched, *vlSelf->vlSymsp->_vm_contextp__);
    VL_INPLACE_CONSTRUCT(vlSelf->__Vnontrivs.__VtrigSched_h5b390de9__0);
    // Reset structure values
    Vtest_dot_product_combinational___024root___ctor_var_reset(vlSelf);
}

Vtest_dot_product_combinational___024root::Vtest_dot_product_combinational___024root(Vtest_dot_product_combinational__Syms* symsp, const char* namep) {
    Vtest_dot_product_combinational___024root__ctor(this, symsp, namep);
}

void Vtest_dot_product_combinational___024root__dtor(Vtest_dot_product_combinational___024root* vlSelf) {
    // Destroy members
    VL_INPLACE_DESTRUCT(vlSelf->__Vnontrivs.__VtrigSched_h5b390de9__0);
    VL_INPLACE_DESTRUCT(vlSelf->__Vnontrivs.__VdlySched);
    VL_DO_DANGLING(std::free(const_cast<char*>(vlSelf->vlNamep)), vlSelf->vlNamep);
}

Vtest_dot_product_combinational___024root::~Vtest_dot_product_combinational___024root() {
    Vtest_dot_product_combinational___024root__dtor(this);
}
