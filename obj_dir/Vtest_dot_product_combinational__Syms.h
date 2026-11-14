// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VTEST_DOT_PRODUCT_COMBINATIONAL__SYMS_H_
#define VERILATED_VTEST_DOT_PRODUCT_COMBINATIONAL__SYMS_H_  // guard

#include "verilated.h"
#include "verilated_vcd_c.h"

// INCLUDE MODEL CLASS

#include "Vtest_dot_product_combinational.h"

// INCLUDE MODULE CLASSES
#include "Vtest_dot_product_combinational___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES) Vtest_dot_product_combinational__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vtest_dot_product_combinational* const __Vm_modelp;
    const bool __Vm_isRoot;
    std::string __Vm_topNames[2];
    bool __Vm_dumping = false;  // Dumping is active
    VerilatedMutex __Vm_dumperMutex;  // Protect __Vm_dumperp
    VerilatedVcdC* __Vm_dumperp VL_GUARDED_BY(__Vm_dumperMutex) = nullptr;  /// Trace class for $dump*
    bool __Vm_activity = false;  ///< Used by trace routines to determine change occurred
    uint32_t __Vm_baseCode = 0;  ///< Used by trace routines when tracing multiple models
    VlDeleter __Vm_deleter;
    bool& __Vm_didInit;

    // MODULE INSTANCE STATE
    union {
        struct {
            Vtest_dot_product_combinational___024root TOP;
        } vlInst;
    };

    // CONSTRUCTORS
    Vtest_dot_product_combinational__Syms(VerilatedContext* contextp, Vtest_dot_product_combinational* modelp, const char* namep, bool isRoot);
    ~Vtest_dot_product_combinational__Syms();

    // METHODS
    const char* name() const { return vlInst.TOP.vlNamep; }
    void _traceDump();
    void _traceDumpOpen();
    void _traceDumpClose();
};

#endif  // guard
