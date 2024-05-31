class-pool .
*"* class pool for class ZINF_TRIAL_BALANCE_SERVICE

*"* local type definitions
include ZINF_TRIAL_BALANCE_SERVICE====ccdef.

*"* class ZINF_TRIAL_BALANCE_SERVICE definition
*"* public declarations
  include ZINF_TRIAL_BALANCE_SERVICE====cu.
*"* protected declarations
  include ZINF_TRIAL_BALANCE_SERVICE====co.
*"* private declarations
  include ZINF_TRIAL_BALANCE_SERVICE====ci.
endclass. "ZINF_TRIAL_BALANCE_SERVICE definition

*"* macro definitions
include ZINF_TRIAL_BALANCE_SERVICE====ccmac.
*"* local class implementation
include ZINF_TRIAL_BALANCE_SERVICE====ccimp.

*"* test class
include ZINF_TRIAL_BALANCE_SERVICE====ccau.

class ZINF_TRIAL_BALANCE_SERVICE implementation.
*"* method's implementations
  include methods.
endclass. "ZINF_TRIAL_BALANCE_SERVICE implementation
