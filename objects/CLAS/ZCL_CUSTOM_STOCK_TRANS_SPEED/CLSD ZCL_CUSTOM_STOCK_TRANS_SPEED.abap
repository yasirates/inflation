class-pool .
*"* class pool for class ZCL_CUSTOM_STOCK_TRANS_SPEED

*"* local type definitions
include ZCL_CUSTOM_STOCK_TRANS_SPEED==ccdef.

*"* class ZCL_CUSTOM_STOCK_TRANS_SPEED definition
*"* public declarations
  include ZCL_CUSTOM_STOCK_TRANS_SPEED==cu.
*"* protected declarations
  include ZCL_CUSTOM_STOCK_TRANS_SPEED==co.
*"* private declarations
  include ZCL_CUSTOM_STOCK_TRANS_SPEED==ci.
endclass. "ZCL_CUSTOM_STOCK_TRANS_SPEED definition

*"* macro definitions
include ZCL_CUSTOM_STOCK_TRANS_SPEED==ccmac.
*"* local class implementation
include ZCL_CUSTOM_STOCK_TRANS_SPEED==ccimp.

*"* test class
include ZCL_CUSTOM_STOCK_TRANS_SPEED==ccau.

class ZCL_CUSTOM_STOCK_TRANS_SPEED implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_CUSTOM_STOCK_TRANS_SPEED implementation
