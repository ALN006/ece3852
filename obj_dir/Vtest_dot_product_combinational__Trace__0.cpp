// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vtest_dot_product_combinational__Syms.h"


void Vtest_dot_product_combinational___024root__trace_chg_0_sub_0(Vtest_dot_product_combinational___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtest_dot_product_combinational___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root__trace_chg_0\n"); );
    // Body
    Vtest_dot_product_combinational___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtest_dot_product_combinational___024root*>(voidSelf);
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    Vtest_dot_product_combinational___024root__trace_chg_0_sub_0((&vlSymsp->vlInst.TOP), bufp);
}

void Vtest_dot_product_combinational___024root__trace_chg_0_sub_0(Vtest_dot_product_combinational___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root__trace_chg_0_sub_0\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 0);
    if (VL_UNLIKELY(((vlSelfRef.__VtraceActivity[1U] 
                      | vlSelfRef.__VtraceActivity[2U])))) {
        bufp->chgQData(oldp+0,(vlSelfRef.test_dot_product_combinational__DOT__vectors[0]),33);
        bufp->chgQData(oldp+2,(vlSelfRef.test_dot_product_combinational__DOT__vectors[1]),33);
        bufp->chgIData(oldp+4,((0x00ffffffU & (VL_EXTENDS_II(24,22, vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__) 
                                               + vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__))),24);
        bufp->chgQData(oldp+5,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__vectors[0]),33);
        bufp->chgQData(oldp+7,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__vectors[1]),33);
        bufp->chgIData(oldp+9,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products[0]),22);
        bufp->chgIData(oldp+10,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products[1]),22);
        bufp->chgIData(oldp+11,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products[2]),22);
        bufp->chgIData(oldp+12,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums[0]),24);
        bufp->chgIData(oldp+13,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums[1]),24);
        bufp->chgIData(oldp+14,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums[2]),24);
    }
    bufp->chgBit(oldp+15,(vlSelfRef.test_dot_product_combinational__DOT__clk));
}

void Vtest_dot_product_combinational___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root__trace_cleanup\n"); );
    // Body
    Vtest_dot_product_combinational___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtest_dot_product_combinational___024root*>(voidSelf);
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    vlSymsp->__Vm_activity = false;
    vlSymsp->vlInst.TOP.__VtraceActivity[0U] = 0U;
    vlSymsp->vlInst.TOP.__VtraceActivity[1U] = 0U;
    vlSymsp->vlInst.TOP.__VtraceActivity[2U] = 0U;
}
