// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtest_dot_product_combinational.h for the primary calling header

#ifndef VERILATED_VTEST_DOT_PRODUCT_COMBINATIONAL___024ROOT_H_
#define VERILATED_VTEST_DOT_PRODUCT_COMBINATIONAL___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtest_dot_product_combinational__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtest_dot_product_combinational___024root final {
  public:

    // TRIVIALLY CONSTRUCTIBLE STATE
    ::CData/*0:0*/ test_dot_product_combinational__DOT__clk;
    ::CData/*0:0*/ __Vtrigprevexpr___TOP__test_dot_product_combinational__DOT__clk__0;
    ::IData/*21:0*/ test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__;
    ::IData/*23:0*/ test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__;
    ::QData/*32:0*/ test_dot_product_combinational__DOT__vectors__BRA__0__KET__;
    ::QData/*32:0*/ test_dot_product_combinational__DOT__vectors__BRA__1__KET__;
    ::VlUnpacked<::QData/*32:0*/, 2> test_dot_product_combinational__DOT__vectors;
    ::VlUnpacked<::QData/*32:0*/, 2> test_dot_product_combinational__DOT__dut__DOT__vectors;
    ::VlUnpacked<::IData/*21:0*/, 3> test_dot_product_combinational__DOT__dut__DOT__component_products;
    ::VlUnpacked<::IData/*23:0*/, 3> test_dot_product_combinational__DOT__dut__DOT__partial_sums;
    ::VlUnpacked<::QData/*63:0*/, 1> __VstlTriggered;
    ::VlUnpacked<::QData/*63:0*/, 1> __VicoTriggered;
    ::VlUnpacked<::QData/*63:0*/, 1> __VactTriggered;
    ::VlUnpacked<::QData/*63:0*/, 1> __VactTriggeredAcc;
    ::VlUnpacked<::QData/*63:0*/, 1> __VnbaTriggered;
    ::VlUnpacked<::CData/*0:0*/, 3> __VtraceActivity;

    // NOT TRIVIALLY CONSTRUCTIBLE STATE
    union {
        struct {
            ::VlDelayScheduler __VdlySched;
            ::VlTriggerScheduler __VtrigSched_h5b390de9__0;
        } __Vnontrivs;
    };

    // INTERNAL VARIABLES
    Vtest_dot_product_combinational__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vtest_dot_product_combinational___024root(Vtest_dot_product_combinational__Syms* symsp, const char* namep);
    ~Vtest_dot_product_combinational___024root();
    VL_UNCOPYABLE(Vtest_dot_product_combinational___024root);
    VL_UNMOVABLE(Vtest_dot_product_combinational___024root);

    // INTERNAL METHODS
};


#endif  // guard
