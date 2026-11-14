// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vtest_dot_product_combinational__Syms.h"


VL_ATTR_COLD void Vtest_dot_product_combinational___024root__trace_init_sub__TOP__0(Vtest_dot_product_combinational___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root__trace_init_sub__TOP__0\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    VL_TRACE_PUSH_PREFIX(tracep, "test_dot_product_combinational", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+16,0,"DIMENSIONS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+17,0,"COORD_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+18,0,"RESULT_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_PUSH_PREFIX(tracep, "vectors", VerilatedTracePrefixType::ARRAY_UNPACKED, 0, 1);
    for (int i = 0; i < 2; ++i) {
        VL_TRACE_DECL_QUAD_ARRAY(tracep,c+0+i*2,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, (i + 0), 32,0);
    }
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"dot_product",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 23,0);
    VL_TRACE_DECL_BIT(tracep,c+15,0,"clk",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_PUSH_PREFIX(tracep, "dut", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+16,0,"DIMENSIONS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+17,0,"COORD_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+18,0,"RESULT_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_PUSH_PREFIX(tracep, "vectors", VerilatedTracePrefixType::ARRAY_UNPACKED, 0, 1);
    for (int i = 0; i < 2; ++i) {
        VL_TRACE_DECL_QUAD_ARRAY(tracep,c+5+i*2,0,"",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, (i + 0), 32,0);
    }
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"dot_product",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 23,0);
    VL_TRACE_PUSH_PREFIX(tracep, "component_products", VerilatedTracePrefixType::ARRAY_UNPACKED, 0, 2);
    for (int i = 0; i < 3; ++i) {
        VL_TRACE_DECL_BUS_ARRAY(tracep,c+9+i*1,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, (i + 0), 21,0);
    }
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "partial_sums", VerilatedTracePrefixType::ARRAY_UNPACKED, 0, 2);
    for (int i = 0; i < 3; ++i) {
        VL_TRACE_DECL_BUS_ARRAY(tracep,c+12+i*1,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, (i + 0), 23,0);
    }
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
}

VL_ATTR_COLD void Vtest_dot_product_combinational___024root__trace_init_top(Vtest_dot_product_combinational___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root__trace_init_top\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtest_dot_product_combinational___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vtest_dot_product_combinational___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vtest_dot_product_combinational___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtest_dot_product_combinational___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtest_dot_product_combinational___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vtest_dot_product_combinational___024root__trace_register(Vtest_dot_product_combinational___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root__trace_register\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vtest_dot_product_combinational___024root__trace_const_0, 0, vlSelf);
    tracep->addFullCb(&Vtest_dot_product_combinational___024root__trace_full_0, 0, vlSelf);
    tracep->addChgCb(&Vtest_dot_product_combinational___024root__trace_chg_0, 0, vlSelf);
    tracep->addCleanupCb(&Vtest_dot_product_combinational___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vtest_dot_product_combinational___024root__trace_const_0_sub_0(Vtest_dot_product_combinational___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtest_dot_product_combinational___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root__trace_const_0\n"); );
    // Body
    Vtest_dot_product_combinational___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtest_dot_product_combinational___024root*>(voidSelf);
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vtest_dot_product_combinational___024root__trace_const_0_sub_0((&vlSymsp->vlInst.TOP), bufp);
}

VL_ATTR_COLD void Vtest_dot_product_combinational___024root__trace_const_0_sub_0(Vtest_dot_product_combinational___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root__trace_const_0_sub_0\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullIData(oldp+16,(3U),32);
    bufp->fullIData(oldp+17,(0x0000000bU),32);
    bufp->fullIData(oldp+18,(0x00000018U),32);
}

VL_ATTR_COLD void Vtest_dot_product_combinational___024root__trace_full_0_sub_0(Vtest_dot_product_combinational___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtest_dot_product_combinational___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root__trace_full_0\n"); );
    // Body
    Vtest_dot_product_combinational___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtest_dot_product_combinational___024root*>(voidSelf);
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vtest_dot_product_combinational___024root__trace_full_0_sub_0((&vlSymsp->vlInst.TOP), bufp);
}

VL_ATTR_COLD void Vtest_dot_product_combinational___024root__trace_full_0_sub_0(Vtest_dot_product_combinational___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root__trace_full_0_sub_0\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullQData(oldp+0,(vlSelfRef.test_dot_product_combinational__DOT__vectors[0]),33);
    bufp->fullQData(oldp+2,(vlSelfRef.test_dot_product_combinational__DOT__vectors[1]),33);
    bufp->fullIData(oldp+4,((0x00ffffffU & (VL_EXTENDS_II(24,22, vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__) 
                                            + vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__))),24);
    bufp->fullQData(oldp+5,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__vectors[0]),33);
    bufp->fullQData(oldp+7,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__vectors[1]),33);
    bufp->fullIData(oldp+9,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products[0]),22);
    bufp->fullIData(oldp+10,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products[1]),22);
    bufp->fullIData(oldp+11,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products[2]),22);
    bufp->fullIData(oldp+12,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums[0]),24);
    bufp->fullIData(oldp+13,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums[1]),24);
    bufp->fullIData(oldp+14,(vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums[2]),24);
    bufp->fullBit(oldp+15,(vlSelfRef.test_dot_product_combinational__DOT__clk));
}
