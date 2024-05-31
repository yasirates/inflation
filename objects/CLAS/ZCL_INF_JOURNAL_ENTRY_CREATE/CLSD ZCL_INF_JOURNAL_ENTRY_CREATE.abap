class-pool .
*"* class pool for class ZCL_INF_JOURNAL_ENTRY_CREATE

*"* local type definitions
include ZCL_INF_JOURNAL_ENTRY_CREATE==ccdef.

*"* class ZCL_INF_JOURNAL_ENTRY_CREATE definition
*"* public declarations
  include ZCL_INF_JOURNAL_ENTRY_CREATE==cu.
*"* protected declarations
  include ZCL_INF_JOURNAL_ENTRY_CREATE==co.
*"* private declarations
  include ZCL_INF_JOURNAL_ENTRY_CREATE==ci.
endclass. "ZCL_INF_JOURNAL_ENTRY_CREATE definition

*"* macro definitions
include ZCL_INF_JOURNAL_ENTRY_CREATE==ccmac.
*"* local class implementation
include ZCL_INF_JOURNAL_ENTRY_CREATE==ccimp.

*"* test class
include ZCL_INF_JOURNAL_ENTRY_CREATE==ccau.

class ZCL_INF_JOURNAL_ENTRY_CREATE implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_INF_JOURNAL_ENTRY_CREATE implementation
