// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtest_dot_product_combinational__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vtest_dot_product_combinational::Vtest_dot_product_combinational(VerilatedContext* _vcontextp__, const char* _vcname__)
    : Vtest_dot_product_combinational{_vcontextp__, _vcname__, true} {}

Vtest_dot_product_combinational::Vtest_dot_product_combinational(VerilatedContext* _vcontextp__, const char* _vcname__, bool _vcisRoot__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vtest_dot_product_combinational__Syms(contextp(), this, _vcname__, _vcisRoot__)}
    , m_evalLoop{*this, /*convergeLimit:*/ 10000}
    , rootp{&(vlSymsp->vlInst.TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
}

Vtest_dot_product_combinational::Vtest_dot_product_combinational(const char* _vcname__)
    : Vtest_dot_product_combinational(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vtest_dot_product_combinational::~Vtest_dot_product_combinational() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vtest_dot_product_combinational___024root___eval_debug_assertions(Vtest_dot_product_combinational___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_static(Vtest_dot_product_combinational___024root* vlSelf);
void Vtest_dot_product_combinational___024root___eval_initial(Vtest_dot_product_combinational___024root* vlSelf);
VL_ATTR_COLD bool Vtest_dot_product_combinational___024root___eval_stl(Vtest_dot_product_combinational___024root* vlSelf, ::CData/*0:0*/ firstIteration);
void Vtest_dot_product_combinational___024root___eval_sample(Vtest_dot_product_combinational___024root* vlSelf);
bool Vtest_dot_product_combinational___024root___eval_ico(Vtest_dot_product_combinational___024root* vlSelf, ::CData/*0:0*/ firstIteration);
bool Vtest_dot_product_combinational___024root___eval_act(Vtest_dot_product_combinational___024root* vlSelf);
bool Vtest_dot_product_combinational___024root___eval_inact(Vtest_dot_product_combinational___024root* vlSelf);
bool Vtest_dot_product_combinational___024root___eval_nba(Vtest_dot_product_combinational___024root* vlSelf);
bool Vtest_dot_product_combinational___024root___eval_obs(Vtest_dot_product_combinational___024root* vlSelf);
bool Vtest_dot_product_combinational___024root___eval_react(Vtest_dot_product_combinational___024root* vlSelf);
void Vtest_dot_product_combinational___024root___eval_postponed(Vtest_dot_product_combinational___024root* vlSelf);
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_final(Vtest_dot_product_combinational___024root* vlSelf);
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_dump_triggers__stl(Vtest_dot_product_combinational___024root* vlSelf);
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_dump_triggers__ico(Vtest_dot_product_combinational___024root* vlSelf);
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_dump_triggers__act(Vtest_dot_product_combinational___024root* vlSelf);
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_dump_triggers__nba(Vtest_dot_product_combinational___024root* vlSelf);
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_dump_triggers__obs(Vtest_dot_product_combinational___024root* vlSelf);
VL_ATTR_COLD void Vtest_dot_product_combinational___024root___eval_dump_triggers__react(Vtest_dot_product_combinational___024root* vlSelf);

void Vtest_dot_product_combinational::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtest_dot_product_combinational::eval_step\n"); );
    m_evalLoop.eval();
}

void Vtest_dot_product_combinational::evalBegin() {
#ifdef VL_DEBUG
    // Debug assertions
    Vtest_dot_product_combinational___024root___eval_debug_assertions(&(vlSymsp->vlInst.TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
}

void Vtest_dot_product_combinational::evalEnd() {
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
    vlSymsp->vlInst.TOP.__Vnontrivs.__VdlySched.cleanupForevered();
}

void Vtest_dot_product_combinational::evalStatic() {
    Vtest_dot_product_combinational___024root___eval_static(&(vlSymsp->vlInst.TOP));
}

void Vtest_dot_product_combinational::evalInitial() {
    Vtest_dot_product_combinational___024root___eval_initial(&(vlSymsp->vlInst.TOP));
}

bool Vtest_dot_product_combinational::evalStl(bool firstIteration) {
    return Vtest_dot_product_combinational___024root___eval_stl(&(vlSymsp->vlInst.TOP), firstIteration);
}

void Vtest_dot_product_combinational::evalSample() {
    Vtest_dot_product_combinational___024root___eval_sample(&(vlSymsp->vlInst.TOP));
}

bool Vtest_dot_product_combinational::evalIco(bool firstIteration) {
    return Vtest_dot_product_combinational___024root___eval_ico(&(vlSymsp->vlInst.TOP), firstIteration);
}

bool Vtest_dot_product_combinational::evalAct() {
    return Vtest_dot_product_combinational___024root___eval_act(&(vlSymsp->vlInst.TOP));
}

bool Vtest_dot_product_combinational::evalInact() {
    return Vtest_dot_product_combinational___024root___eval_inact(&(vlSymsp->vlInst.TOP));
}

bool Vtest_dot_product_combinational::evalNba() {
    return Vtest_dot_product_combinational___024root___eval_nba(&(vlSymsp->vlInst.TOP));
}

bool Vtest_dot_product_combinational::evalObs() {
    return Vtest_dot_product_combinational___024root___eval_obs(&(vlSymsp->vlInst.TOP));
}

bool Vtest_dot_product_combinational::evalReact() {
    return Vtest_dot_product_combinational___024root___eval_react(&(vlSymsp->vlInst.TOP));
}

void Vtest_dot_product_combinational::evalPostponed() {
    Vtest_dot_product_combinational___024root___eval_postponed(&(vlSymsp->vlInst.TOP));
}

void Vtest_dot_product_combinational::evalFinal() {
    Vtest_dot_product_combinational___024root___eval_final(&(vlSymsp->vlInst.TOP));
}

VL_ATTR_COLD void Vtest_dot_product_combinational::dumpTriggersStl() {
    Vtest_dot_product_combinational___024root___eval_dump_triggers__stl(&(vlSymsp->vlInst.TOP));
}

VL_ATTR_COLD void Vtest_dot_product_combinational::dumpTriggersIco() {
    Vtest_dot_product_combinational___024root___eval_dump_triggers__ico(&(vlSymsp->vlInst.TOP));
}

VL_ATTR_COLD void Vtest_dot_product_combinational::dumpTriggersAct() {
    Vtest_dot_product_combinational___024root___eval_dump_triggers__act(&(vlSymsp->vlInst.TOP));
}

VL_ATTR_COLD void Vtest_dot_product_combinational::dumpTriggersNba() {
    Vtest_dot_product_combinational___024root___eval_dump_triggers__nba(&(vlSymsp->vlInst.TOP));
}

VL_ATTR_COLD void Vtest_dot_product_combinational::dumpTriggersObs() {
    Vtest_dot_product_combinational___024root___eval_dump_triggers__obs(&(vlSymsp->vlInst.TOP));
}

VL_ATTR_COLD void Vtest_dot_product_combinational::dumpTriggersReact() {
    Vtest_dot_product_combinational___024root___eval_dump_triggers__react(&(vlSymsp->vlInst.TOP));
}

void Vtest_dot_product_combinational::eval_end_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+eval_end_step Vtest_dot_product_combinational::eval_end_step\n"); );
#ifdef VM_TRACE
    // Tracing
    if (VL_UNLIKELY(vlSymsp->__Vm_dumping)) vlSymsp->_traceDump();
#endif  // VM_TRACE
}

//============================================================
// Events and timing
bool Vtest_dot_product_combinational::eventsPending() { return !vlSymsp->vlInst.TOP.__Vnontrivs.__VdlySched.empty() && !contextp()->gotFinish(); }

uint64_t Vtest_dot_product_combinational::nextTimeSlot() { return vlSymsp->vlInst.TOP.__Vnontrivs.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vtest_dot_product_combinational::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

VL_ATTR_COLD void Vtest_dot_product_combinational::final() {
    contextp()->executingFinal(true);
    evalFinal();
    contextp()->executingFinal(false);
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vtest_dot_product_combinational::hierName() const { return vlSymsp->name(); }
const char* Vtest_dot_product_combinational::modelName() const { return "Vtest_dot_product_combinational"; }
unsigned Vtest_dot_product_combinational::threads() const { return 1; }
void Vtest_dot_product_combinational::prepareClone() const { contextp()->prepareClone(); }
void Vtest_dot_product_combinational::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vtest_dot_product_combinational::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false}};
};

//============================================================
// Trace configuration

void Vtest_dot_product_combinational___024root__trace_decl_types(VerilatedVcd* tracep);

void Vtest_dot_product_combinational___024root__trace_init_top(Vtest_dot_product_combinational___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vtest_dot_product_combinational___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtest_dot_product_combinational___024root*>(voidSelf);
    Vtest_dot_product_combinational__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(vlSymsp->name(), VerilatedTracePrefixType::SCOPE_MODULE);
    Vtest_dot_product_combinational___024root__trace_decl_types(tracep);
    Vtest_dot_product_combinational___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vtest_dot_product_combinational___024root__trace_register(Vtest_dot_product_combinational___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vtest_dot_product_combinational::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vtest_dot_product_combinational::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace-vcd with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->vlInst.TOP), name(), false, 19);
    Vtest_dot_product_combinational___024root__trace_register(&(vlSymsp->vlInst.TOP), stfp->spTrace());
}
