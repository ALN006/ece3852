// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtest_dot_product_combinational.h for the primary calling header

#include "Vtest_dot_product_combinational__pch.h"

VlCoroutine Vtest_dot_product_combinational___024root___eval_initial__TOP__Vtiming__0(Vtest_dot_product_combinational___024root* vlSelf);
VlCoroutine Vtest_dot_product_combinational___024root___eval_initial__TOP__Vtiming__1(Vtest_dot_product_combinational___024root* vlSelf);

void Vtest_dot_product_combinational___024root___eval_initial(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_initial\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    {
        // Body
        // Inlined CFunc: _eval_initial__TOP
        vlSelfRef.test_dot_product_combinational__DOT__clk = 1U;
    }
    Vtest_dot_product_combinational___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    Vtest_dot_product_combinational___024root___eval_initial__TOP__Vtiming__1(vlSelf);
}

void Vtest_dot_product_combinational___024root___eval_sample(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_sample\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___dump_triggers__ico(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag);
#endif  // VL_DEBUG

bool Vtest_dot_product_combinational___024root___eval_ico(Vtest_dot_product_combinational___024root* vlSelf, ::CData/*0:0*/ firstIteration) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_ico\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VicoTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VicoTriggered[0U]) 
                                     | (::IData)((::IData)(firstIteration)));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtest_dot_product_combinational___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
    }
#endif
    return (0U);
}

void Vtest_dot_product_combinational___024root___timing_ready(Vtest_dot_product_combinational___024root* vlSelf);
void Vtest_dot_product_combinational___024root___trigger_orInto__act_vec_vec(::VlUnpacked<::QData/*63:0*/, 1> &out, const ::VlUnpacked<::QData/*63:0*/, 1> &in);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___dump_triggers__act(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag);
#endif  // VL_DEBUG
bool Vtest_dot_product_combinational___024root___trigger_anySet__act(const ::VlUnpacked<::QData/*63:0*/, 1> &in);
void Vtest_dot_product_combinational___024root___timing_resume(Vtest_dot_product_combinational___024root* vlSelf);
void Vtest_dot_product_combinational___024root___act_comb__TOP__0(Vtest_dot_product_combinational___024root* vlSelf);

bool Vtest_dot_product_combinational___024root___eval_act(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_act\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    ::CData/*0:0*/ __VactExecute;
    // Body
    {
        // Body
        // Inlined CFunc: _eval_triggers_vec__act
        vlSelfRef.__VactTriggered[0U] = (::QData)((::IData)(
                                                            ((vlSelfRef.__Vnontrivs.__VdlySched.awaitingCurrentTime() 
                                                              << 1U) 
                                                             | ((::IData)(vlSelfRef.test_dot_product_combinational__DOT__clk) 
                                                                & (~ (::IData)(vlSelfRef.__Vtrigprevexpr___TOP__test_dot_product_combinational__DOT__clk__0))))));
        vlSelfRef.__Vtrigprevexpr___TOP__test_dot_product_combinational__DOT__clk__0 
            = vlSelfRef.test_dot_product_combinational__DOT__clk;
    }
    Vtest_dot_product_combinational___024root___timing_ready(vlSelf);
    Vtest_dot_product_combinational___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VactTriggered, vlSelfRef.__VactTriggeredAcc);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtest_dot_product_combinational___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vtest_dot_product_combinational___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    __VactExecute = Vtest_dot_product_combinational___024root___trigger_anySet__act(vlSelfRef.__VactTriggered);
    if (__VactExecute) {
        vlSelfRef.__VactTriggeredAcc.fill(0ULL);
        Vtest_dot_product_combinational___024root___timing_resume(vlSelf);
        {
            // Body
            // Inlined CFunc: _eval_body__act
            if ((((1ULL & vlSelfRef.__VactTriggered[0U])) != 0ULL)) {
                Vtest_dot_product_combinational___024root___act_comb__TOP__0(vlSelf);
                vlSelfRef.__VtraceActivity[1U] = 1U;
            }
        }
    }
    return (__VactExecute);
}

bool Vtest_dot_product_combinational___024root___eval_inact(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_inact\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    ::CData/*0:0*/ __VinactExecute;
    // Body
    __VinactExecute = vlSelfRef.__Vnontrivs.__VdlySched.awaitingZeroDelay();
    if (__VinactExecute) {
        VL_FATAL_MT("final_project/test/test_dot_product_combinational.sv", 10, "", "ZERODLY: Design Verilated with '--no-sched-zero-delay', but #0 delay executed at runtime");
    }
    return (__VinactExecute);
}

void Vtest_dot_product_combinational___024root___trigger_clear__act(::VlUnpacked<::QData/*63:0*/, 1> &out);

bool Vtest_dot_product_combinational___024root___eval_nba(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_nba\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    ::CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vtest_dot_product_combinational___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        {
            // Body
            // Inlined CFunc: _eval_body__nba
            if ((((1ULL & vlSelfRef.__VnbaTriggered[0U])) != 0ULL)) {
                Vtest_dot_product_combinational___024root___act_comb__TOP__0(vlSelf);
                vlSelfRef.__VtraceActivity[2U] = 1U;
            }
        }
        Vtest_dot_product_combinational___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

bool Vtest_dot_product_combinational___024root___eval_obs(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_obs\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    return (0U);
}

bool Vtest_dot_product_combinational___024root___eval_react(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_react\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    return (0U);
}

void Vtest_dot_product_combinational___024root___eval_postponed(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_postponed\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vtest_dot_product_combinational___024root____VbeforeTrig_h5b390de9__0(Vtest_dot_product_combinational___024root* vlSelf, const char* __VeventDescription);

VlCoroutine Vtest_dot_product_combinational___024root___eval_initial__TOP__Vtiming__0(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_initial__TOP__Vtiming__0\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSymsp->_vm_contextp__->dumpfile("test_dot_product_combinational.vcd"s);
    vlSymsp->_traceDumpOpen();
    Vtest_dot_product_combinational___024root____VbeforeTrig_h5b390de9__0(vlSelf, 
                                                                          "@(posedge test_dot_product_combinational.clk)");
    co_await vlSelfRef.__Vnontrivs.__VtrigSched_h5b390de9__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge test_dot_product_combinational.clk)", 
                                                                     "final_project/test/test_dot_product_combinational.sv", 
                                                                     38);
    vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__0__KET__ = 0ULL;
    vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__1__KET__ = 0ULL;
    Vtest_dot_product_combinational___024root____VbeforeTrig_h5b390de9__0(vlSelf, 
                                                                          "@(posedge test_dot_product_combinational.clk)");
    co_await vlSelfRef.__Vnontrivs.__VtrigSched_h5b390de9__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge test_dot_product_combinational.clk)", 
                                                                     "final_project/test/test_dot_product_combinational.sv", 
                                                                     41);
    vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__0__KET__ = 0x0000000000400801ULL;
    vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__1__KET__ = 0ULL;
    if (vlSymsp->_vm_contextp__->assertCtlGet<2, 1>(VerilatedAssertCtlQuery::ASSERT_CTL_ON)) {
        if (vlSymsp->_vm_contextp__->assertCtlGet<2, 1>(VerilatedAssertCtlQuery::ASSERT_CTL_FAIL_ON)) {
            if (VL_UNLIKELY(((0U != (0x00ffffffU & 
                                     (VL_EXTENDS_II(24,22, vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__) 
                                      + vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__)))))) {
                VL_WRITEF_NX("[%0t] %%Error: test_dot_product_combinational.sv:42: Assertion failed in %m: dot_product Fail -> Expected: 0, Found: %h\n",4, 'M',vlSymsp->__Vm_topNames[1].c_str(),"", 'T',-8
                             , '#',64,VL_TIME_UNITED_Q(10)
                             , '~',24,(0x00ffffffU 
                                       & (VL_EXTENDS_II(24,22, vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__) 
                                          + vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__)));
                VL_STOP_MT("final_project/test/test_dot_product_combinational.sv", 42, "");
            }
        }
    }
    Vtest_dot_product_combinational___024root____VbeforeTrig_h5b390de9__0(vlSelf, 
                                                                          "@(posedge test_dot_product_combinational.clk)");
    co_await vlSelfRef.__Vnontrivs.__VtrigSched_h5b390de9__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge test_dot_product_combinational.clk)", 
                                                                     "final_project/test/test_dot_product_combinational.sv", 
                                                                     45);
    vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__0__KET__ = 0x0000000000400801ULL;
    vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__1__KET__ = 0x0000000000400801ULL;
    if (vlSymsp->_vm_contextp__->assertCtlGet<2, 1>(VerilatedAssertCtlQuery::ASSERT_CTL_ON)) {
        if (vlSymsp->_vm_contextp__->assertCtlGet<2, 1>(VerilatedAssertCtlQuery::ASSERT_CTL_FAIL_ON)) {
            if (VL_UNLIKELY(((0U != (0x00ffffffU & 
                                     (VL_EXTENDS_II(24,22, vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__) 
                                      + vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__)))))) {
                VL_WRITEF_NX("[%0t] %%Error: test_dot_product_combinational.sv:46: Assertion failed in %m: dot_product Fail -> Expected: 0, Found: %h\n",4, 'M',vlSymsp->__Vm_topNames[1].c_str(),"", 'T',-8
                             , '#',64,VL_TIME_UNITED_Q(10)
                             , '~',24,(0x00ffffffU 
                                       & (VL_EXTENDS_II(24,22, vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__) 
                                          + vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__)));
                VL_STOP_MT("final_project/test/test_dot_product_combinational.sv", 46, "");
            }
        }
    }
    Vtest_dot_product_combinational___024root____VbeforeTrig_h5b390de9__0(vlSelf, 
                                                                          "@(posedge test_dot_product_combinational.clk)");
    co_await vlSelfRef.__Vnontrivs.__VtrigSched_h5b390de9__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge test_dot_product_combinational.clk)", 
                                                                     "final_project/test/test_dot_product_combinational.sv", 
                                                                     49);
    vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__0__KET__ = 0x00000000007ff003ULL;
    vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__1__KET__ = 0x0000000001002ffaULL;
    if (vlSymsp->_vm_contextp__->assertCtlGet<2, 1>(VerilatedAssertCtlQuery::ASSERT_CTL_ON)) {
        if (vlSymsp->_vm_contextp__->assertCtlGet<2, 1>(VerilatedAssertCtlQuery::ASSERT_CTL_FAIL_ON)) {
            if (VL_UNLIKELY(((3U != (0x00ffffffU & 
                                     (VL_EXTENDS_II(24,22, vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__) 
                                      + vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__)))))) {
                VL_WRITEF_NX("[%0t] %%Error: test_dot_product_combinational.sv:50: Assertion failed in %m: dot_product Fail -> Expected: 000003, Found: %h\n",4, 'M',vlSymsp->__Vm_topNames[1].c_str(),"", 'T',-8
                             , '#',64,VL_TIME_UNITED_Q(10)
                             , '~',24,(0x00ffffffU 
                                       & (VL_EXTENDS_II(24,22, vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__) 
                                          + vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__)));
                VL_STOP_MT("final_project/test/test_dot_product_combinational.sv", 50, "");
            }
        }
    }
    Vtest_dot_product_combinational___024root____VbeforeTrig_h5b390de9__0(vlSelf, 
                                                                          "@(posedge test_dot_product_combinational.clk)");
    co_await vlSelfRef.__Vnontrivs.__VtrigSched_h5b390de9__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge test_dot_product_combinational.clk)", 
                                                                     "final_project/test/test_dot_product_combinational.sv", 
                                                                     53);
    if (vlSymsp->_vm_contextp__->assertCtlGet<2, 1>(VerilatedAssertCtlQuery::ASSERT_CTL_ON)) {
        if (vlSymsp->_vm_contextp__->assertCtlGet<2, 1>(VerilatedAssertCtlQuery::ASSERT_CTL_FAIL_ON)) {
            if (VL_UNLIKELY(((0x00ffffe8U != (0x00ffffffU 
                                              & (VL_EXTENDS_II(24,22, vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__) 
                                                 + vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__)))))) {
                VL_WRITEF_NX("[%0t] %%Error: test_dot_product_combinational.sv:54: Assertion failed in %m: dot_product Fail -> Expected: ffffe8, Found: %h\n",4, 'M',vlSymsp->__Vm_topNames[1].c_str(),"", 'T',-8
                             , '#',64,VL_TIME_UNITED_Q(10)
                             , '~',24,(0x00ffffffU 
                                       & (VL_EXTENDS_II(24,22, vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__) 
                                          + vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__)));
                VL_STOP_MT("final_project/test/test_dot_product_combinational.sv", 54, "");
            }
        }
    }
    VL_WRITEF_NX("done simulating dot_product_combinational\n",0);
    VL_FINISH_MT("final_project/test/test_dot_product_combinational.sv", 57, "");
    co_return;
}

VlCoroutine Vtest_dot_product_combinational___024root___eval_initial__TOP__Vtiming__1(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_initial__TOP__Vtiming__1\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    while (VL_LIKELY(!vlSymsp->_vm_contextp__->gotFinish())) {
        co_await vlSelfRef.__Vnontrivs.__VdlySched.delay(0x000000000000000aULL, 
                                                         nullptr, 
                                                         "final_project/test/test_dot_product_combinational.sv", 
                                                         26);
        vlSelfRef.test_dot_product_combinational__DOT__clk 
            = (1U & (~ (::IData)(vlSelfRef.test_dot_product_combinational__DOT__clk)));
    }
    co_return;
}

bool Vtest_dot_product_combinational___024root___trigger_anySet__ico(const ::VlUnpacked<::QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___trigger_anySet__ico\n"); );
    // Locals
    ::IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((::IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

bool Vtest_dot_product_combinational___024root___trigger_anySet__act(const ::VlUnpacked<::QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___trigger_anySet__act\n"); );
    // Locals
    ::IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((::IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vtest_dot_product_combinational___024root___act_comb__TOP__0(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___act_comb__TOP__0\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    ::IData/*21:0*/ test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__0__KET__;
    ::IData/*21:0*/ test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__1__KET__;
    // Body
    test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__0__KET__ = 0;
    test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__1__KET__ = 0;
    vlSelfRef.test_dot_product_combinational__DOT__vectors[0U] 
        = vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__0__KET__;
    vlSelfRef.test_dot_product_combinational__DOT__vectors[1U] 
        = vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__1__KET__;
    vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__vectors[0U] 
        = vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__0__KET__;
    vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__vectors[1U] 
        = vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__1__KET__;
    vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__ 
        = (0x003fffffU & ((0x000007ffU & (::IData)(
                                                   (vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__1__KET__ 
                                                    >> 0x00000016U))) 
                          * (0x000007ffU & (::IData)(
                                                     (vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__0__KET__ 
                                                      >> 0x00000016U)))));
    test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__1__KET__ 
        = (0x003fffffU & ((0x000007ffU & (::IData)(
                                                   (vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__1__KET__ 
                                                    >> 0x0000000bU))) 
                          * (0x000007ffU & (::IData)(
                                                     (vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__0__KET__ 
                                                      >> 0x0000000bU)))));
    test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__0__KET__ 
        = (0x003fffffU & ((0x000007ffU & (::IData)(vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__1__KET__)) 
                          * (0x000007ffU & (::IData)(vlSelfRef.test_dot_product_combinational__DOT__vectors__BRA__0__KET__))));
    vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products[2U] 
        = vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__;
    vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products[1U] 
        = test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__1__KET__;
    vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products[0U] 
        = test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__0__KET__;
    vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums[0U] 
        = (0x00ffffffU & VL_EXTENDS_II(24,22, test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__0__KET__));
    vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__ 
        = (0x00ffffffU & (VL_EXTENDS_II(24,22, test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__0__KET__) 
                          + VL_EXTENDS_II(24,22, test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__1__KET__)));
    vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums[1U] 
        = vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__;
    vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums[2U] 
        = (0x00ffffffU & (VL_EXTENDS_II(24,22, vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__) 
                          + vlSelfRef.test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__));
}

void Vtest_dot_product_combinational___024root___timing_ready(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___timing_ready\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((((1ULL & vlSelfRef.__VactTriggered[0U])) != 0ULL)) {
        vlSelfRef.__Vnontrivs.__VtrigSched_h5b390de9__0.ready(
                                                              "@(posedge test_dot_product_combinational.clk)");
    }
}

void Vtest_dot_product_combinational___024root___timing_resume(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___timing_resume\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vnontrivs.__VtrigSched_h5b390de9__0.moveToResumeQueue(
                                                                      "@(posedge test_dot_product_combinational.clk)");
    vlSelfRef.__Vnontrivs.__VtrigSched_h5b390de9__0.resume(
                                                           "@(posedge test_dot_product_combinational.clk)");
    if ((((2ULL & vlSelfRef.__VactTriggered[0U])) != 0ULL)) {
        vlSelfRef.__Vnontrivs.__VdlySched.resume();
    }
}

void Vtest_dot_product_combinational___024root___trigger_orInto__act_vec_vec(::VlUnpacked<::QData/*63:0*/, 1> &out, const ::VlUnpacked<::QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    ::IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((::IData)(1U) + n);
    } while ((0U >= n));
}

void Vtest_dot_product_combinational___024root___trigger_clear__act(::VlUnpacked<::QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___trigger_clear__act\n"); );
    // Locals
    ::IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((::IData)(1U) + n);
    } while ((1U > n));
}

void Vtest_dot_product_combinational___024root____VbeforeTrig_h5b390de9__0(Vtest_dot_product_combinational___024root* vlSelf, const char* __VeventDescription) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root____VbeforeTrig_h5b390de9__0\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    ::VlUnpacked<::QData/*63:0*/, 1> __VTmp;
    // Body
    __VTmp[0U] = (::QData)((::IData)(((::IData)(vlSelfRef.test_dot_product_combinational__DOT__clk) 
                                      & (~ (::IData)(vlSelfRef.__Vtrigprevexpr___TOP__test_dot_product_combinational__DOT__clk__0)))));
    vlSelfRef.__Vtrigprevexpr___TOP__test_dot_product_combinational__DOT__clk__0 
        = vlSelfRef.test_dot_product_combinational__DOT__clk;
    if ((1ULL & __VTmp[0U])) {
        vlSelfRef.__Vnontrivs.__VtrigSched_h5b390de9__0.ready(__VeventDescription);
    }
    vlSelfRef.__VactTriggeredAcc[0U] = (vlSelfRef.__VactTriggeredAcc[0U] 
                                        | __VTmp[0U]);
}

#ifdef VL_DEBUG
void Vtest_dot_product_combinational___024root___eval_debug_assertions(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_debug_assertions\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
#endif  // VL_DEBUG
