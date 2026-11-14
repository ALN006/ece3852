// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtest_dot_product_combinational.h for the primary calling header

#include "Vtest_dot_product_combinational__pch.h"

VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_static(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_static\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__test_dot_product_combinational__DOT__clk__0 
        = vlSelfRef.test_dot_product_combinational__DOT__clk;
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___dump_triggers__stl(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtest_dot_product_combinational___024root___trigger_anySet__stl(const ::VlUnpacked<::QData/*63:0*/, 1> &in);
void Vtest_dot_product_combinational___024root___act_comb__TOP__0(Vtest_dot_product_combinational___024root* vlSelf);

VL_ATTR_COLD bool Vtest_dot_product_combinational___024root___eval_stl(Vtest_dot_product_combinational___024root* vlSelf, ::CData/*0:0*/ firstIteration) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_stl\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    ::CData/*0:0*/ __VstlExecute;
    // Body
    vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VstlTriggered[0U]) 
                                     | (::IData)((::IData)(firstIteration)));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtest_dot_product_combinational___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
    __VstlExecute = Vtest_dot_product_combinational___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        {
            // Body
            // Inlined CFunc: _eval_body__stl
            if ((((1ULL & vlSelfRef.__VstlTriggered[0U])) != 0ULL)) {
                Vtest_dot_product_combinational___024root___act_comb__TOP__0(vlSelf);
                {
                    // Body
                    // Inlined CFunc: __VtraceActivitySetAll
                    vlSelfRef.__VtraceActivity[0U] = 1U;
                    vlSelfRef.__VtraceActivity[1U] = 1U;
                    vlSelfRef.__VtraceActivity[2U] = 1U;
                }
            }
        }
    }
    return (__VstlExecute);
}

VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_dump_triggers__stl(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_dump_triggers__stl\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    Vtest_dot_product_combinational___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___dump_triggers__ico(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_dump_triggers__ico(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_dump_triggers__ico\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    Vtest_dot_product_combinational___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
#endif
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___dump_triggers__act(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_dump_triggers__act(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_dump_triggers__act\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    Vtest_dot_product_combinational___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
}

VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_dump_triggers__nba(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_dump_triggers__nba\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    Vtest_dot_product_combinational___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
}

VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_dump_triggers__obs(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_dump_triggers__obs\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_dump_triggers__react(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_dump_triggers__react\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_final(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___eval_final\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___dump_triggers__stl(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (::IData)(Vtest_dot_product_combinational___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (::IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Vtest_dot_product_combinational___024root___trigger_anySet__stl(const ::VlUnpacked<::QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___trigger_anySet__stl\n"); );
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

bool Vtest_dot_product_combinational___024root___trigger_anySet__ico(const ::VlUnpacked<::QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___dump_triggers__ico(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (::IData)(Vtest_dot_product_combinational___024root___trigger_anySet__ico(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (::IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

bool Vtest_dot_product_combinational___024root___trigger_anySet__act(const ::VlUnpacked<::QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___dump_triggers__act(const ::VlUnpacked<::QData/*63:0*/, 1> &triggers, const ::std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (::IData)(Vtest_dot_product_combinational___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (::IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge test_dot_product_combinational.clk)\n");
    }
    if ((1U & (::IData)((triggers[0U] >> 1U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 1 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtest_dot_product_combinational___024root___ctor_var_reset(Vtest_dot_product_combinational___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_dot_product_combinational___024root___ctor_var_reset\n"); );
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->test_dot_product_combinational__DOT__vectors__BRA__0__KET__ = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 16933335794179633389ull);
    vlSelf->test_dot_product_combinational__DOT__vectors__BRA__1__KET__ = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 6632017878579149926ull);
    vlSelf->test_dot_product_combinational__DOT__vectors[0] = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 12784301287143698980ull);
    VL_UNPACKED_FILL(vlSelf->test_dot_product_combinational__DOT__vectors.data(), sizeof(vlSelf->test_dot_product_combinational__DOT__vectors[0]), 2);
    vlSelf->test_dot_product_combinational__DOT__clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 14472479452250908858ull);
    vlSelf->test_dot_product_combinational__DOT__dut__DOT__vectors[0] = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 11627325655389283093ull);
    VL_UNPACKED_FILL(vlSelf->test_dot_product_combinational__DOT__dut__DOT__vectors.data(), sizeof(vlSelf->test_dot_product_combinational__DOT__dut__DOT__vectors[0]), 2);
    vlSelf->test_dot_product_combinational__DOT__dut__DOT__component_products__BRA__2__KET__ = VL_SCOPED_RAND_RESET_I(22, __VscopeHash, 15595129946449163790ull);
    vlSelf->test_dot_product_combinational__DOT__dut__DOT__component_products[0] = VL_SCOPED_RAND_RESET_I(22, __VscopeHash, 5586913836381014764ull);
    VL_UNPACKED_FILL(vlSelf->test_dot_product_combinational__DOT__dut__DOT__component_products.data(), sizeof(vlSelf->test_dot_product_combinational__DOT__dut__DOT__component_products[0]), 3);
    vlSelf->test_dot_product_combinational__DOT__dut__DOT__partial_sums__BRA__1__KET__ = VL_SCOPED_RAND_RESET_I(24, __VscopeHash, 10214264743757045166ull);
    vlSelf->test_dot_product_combinational__DOT__dut__DOT__partial_sums[0] = VL_SCOPED_RAND_RESET_I(24, __VscopeHash, 1421857273522798724ull);
    VL_UNPACKED_FILL(vlSelf->test_dot_product_combinational__DOT__dut__DOT__partial_sums.data(), sizeof(vlSelf->test_dot_product_combinational__DOT__dut__DOT__partial_sums[0]), 3);
    vlSelf->__VstlTriggered[0] = 0;
    VL_UNPACKED_FILL(vlSelf->__VstlTriggered.data(), sizeof(vlSelf->__VstlTriggered[0]), 1);
    vlSelf->__VicoTriggered[0] = 0;
    VL_UNPACKED_FILL(vlSelf->__VicoTriggered.data(), sizeof(vlSelf->__VicoTriggered[0]), 1);
    vlSelf->__VactTriggered[0] = 0;
    VL_UNPACKED_FILL(vlSelf->__VactTriggered.data(), sizeof(vlSelf->__VactTriggered[0]), 1);
    vlSelf->__VactTriggeredAcc[0] = 0;
    VL_UNPACKED_FILL(vlSelf->__VactTriggeredAcc.data(), sizeof(vlSelf->__VactTriggeredAcc[0]), 1);
    vlSelf->__Vtrigprevexpr___TOP__test_dot_product_combinational__DOT__clk__0 = 0;
    vlSelf->__VnbaTriggered[0] = 0;
    VL_UNPACKED_FILL(vlSelf->__VnbaTriggered.data(), sizeof(vlSelf->__VnbaTriggered[0]), 1);
    vlSelf->__VtraceActivity[0] = 0;
    VL_UNPACKED_FILL(vlSelf->__VtraceActivity.data(), sizeof(vlSelf->__VtraceActivity[0]), 3);
}
